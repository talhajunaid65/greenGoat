class Api::V1::ProjectsController < ApiController
  before_action :authenticate_user!, only: [:create]

  def index
    projects = Project.all
    render json: projects, status: :ok
  end

  def show
    project = Project.find(params[:id])

    render json: project, status: :ok
  end

  def create
    project = current_user.projects.new(project_params.merge(status: 'proposal'))
    project.save

    render_errors(project.errors.full_messages) && return if project.errors.any?

    render json: project, status: :created
  end

  def update
    project = Project.find(params[:id])

    project.update_attributes(project_params)


    render json: project, status: :ok
  end

  def destroy
    project = Project.find(params[:id])

    render_errors('Could not delete project') && return unless project.destroy
    render json: project, status: :ok
  end

  def zillow_flow
    project = Project.new(project_params.merge(status: 'proposal'))
    puts project.inspect
    old_projects = ZillowLocation.type(project.type_of_project).in_zipcode(project.zip)
    closest_distance_project = ['', '']
    msg_return = ''
    miles = 5.0
    miles2 = 2.0
    year_dif = 10.0

    begin
      #getting location information from zilloq
      require "open-uri"
      data = URI.parse("https://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz17jcynzxx57_14qhc&address=#{project.address}&citystatezip=#{project.city} #{project.state} #{project.zip}").read
      xml_doc = Nokogiri::XML(data)

      unless xml_doc.at('code').text.to_i == 0
        project.save
        ProjectMailer.wrong_donation_data(project, project.user.email).deliver_now
        return render json: { message: 'We could not find any information about the address you provided. Please check email for further information.' },
                      status: :ok
      end
      coordinates = [xml_doc.at('latitude').text, xml_doc.at('longitude').text]

      project.assign_attributes(
        estimated_value: xml_doc.at('amount').text,
        year_built: xml_doc.at('yearBuilt').text,
        sqft: xml_doc.at('finishedSqFt').text
      )

      if project.other?
        project.save
        ProjectMailer.other_type_project(project.user, project).deliver_now
        return render json: { message: "We can't provide any estimate right now. We will get back to you after further review." }, status: :ok
      end

      miles, miles2, year_dif = [miles, miles2, year_dif].collect(&:to_i).map(&1.3.method(:*)) if project.estimated_value > 5000000

      #getting closest project from old projects
      old_projects.each do |old_project|
        Rails.logger.info "OLD PROJECT: #{old_project.address}, #{old_project.city} #{old_project.zip}"

        old_project_coordinates = [old_project.latitude, old_project.longitude].compact
        if old_project_coordinates.blank?
          old_project_coordinates = Geocoder.search("#{old_project.address}, #{old_project.city} #{old_project.zip}").first&.coordinates
          next if old_project_coordinates.blank?

          old_project.update(latitude: old_project_coordinates[0], longitude: old_project_coordinates[1])
        end
        distance = Geocoder::Calculations.distance_between(coordinates, old_project_coordinates)
        closest_distance_project = [distance, old_project.id] if closest_distance_project.all?(&:blank?) or distance < closest_distance_project[0]
      end

      if closest_distance_project.all?(&:blank?)
        project.save
        return render json: { message: 'Sorry, We are unable to find any project similiar to your project, we will get back to you for more details' },
                      status: :ok
      end

      #calculating estimation
      closest_project = ZillowLocation.find(closest_distance_project[1])

      year_difference = (closest_project.year_built.to_i - project.year_built.to_i).abs
      final_estimation = (project.sqft.to_i * closest_project.val_sf.to_f).round(2)

      Rails.logger.info "CLOSEST PROJECT DISTANCE: #{closest_distance_project[0]}"
      Rails.logger.info "CLOSEST PROJECT BUILT: #{closest_project.year_built.to_i}"
      Rails.logger.info "YEAR BUILT OF ZILLOW: #{project.year_built.to_i}"
      Rails.logger.info "YEARS DIFFERENCE: #{year_difference}"
      Rails.logger.info "SQUREFOOT: #{project.sqft.to_i}"
      Rails.logger.info "CLOSED PROJET VALUE: #{closest_project.val_sf.to_f}"
      Rails.logger.info "Final Estimation: #{final_estimation}"

      if project.estimated_value.to_i < 1000000
        msg_return = "We will get back to you after further review of your application. Hang tight!!!"
        ProjectMailer.less_estimate(project.user, project).deliver_now
      else
        if closest_distance_project[0] < miles2
          if year_difference < year_dif
            msg = "Hoorrayyy!!! By donating this project you will be able to save approx. $#{final_estimation}. Amount may vary after on-site appraisal."
            msg_return = "Please Check your email for our initial Qoute, Values may vary after appraisal."
            ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
          else
            msg = "Your house is within 2 miles of one of our old project, but it is a few years old, With initial estimation you will be able to save approx. $#{final_estimation}. Values may vary widely after appraisal."
            msg_return = 'Your house is within 2 miles of one of our old project, but it is a few years old, Please Check Email!'
            ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
          end
        elsif closest_distance_project[0] < miles
          if year_difference < year_dif
            msg = 'We found similar project a bit out of your neighbourhood, so values may very. Check Email!'
            msg_return = "We have found an old project we did in your neighborhood, With initial estimation you will be able to save approx. $#{final_estimation}. Values may vary after appraisal."
            ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
          else
            msg = 'Your house is within 5 miles of one of our old project, but it is a few years old, so we will contact you after review.'
            msg_return = msg
            ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
          end
        elsif closest_distance_project[0] > miles
          final_estimation = 0.0
          if year_difference < year_dif
            msg = 'Your house is in a new neighbourhood for us, We would be happy to come check out your project free of charge.'
            msg_return = msg
            ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
          else
            msg = 'Your house is more than 5 miles away from one of our past project, but that project is a few years old, We will contact you after further review.'
            msg_return = msg
            ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
          end
        end
      end

      project.val_sf = final_estimation
      project.zillow_location = closest_project
      project.save
    rescue => e
      Error.create(message: e.message)
    end

    render json: { message: msg_return }, status: :ok
  end

  def contact_us
    email = params[:email]
    query = params[:query]

    ProjectMailer.contact_us(email, query).deliver_now

    render json: {status: "success"}, status: :ok
  end

  private

  def project_params
    params.require(:project).permit(:type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date)
  end
end
