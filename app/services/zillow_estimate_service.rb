require "open-uri"

class ZillowEstimateService
  attr_reader :project_params, :project, :old_projects, :closest_distance_project

  def initialize(project_params)
    @project_params = project_params
    @closest_distance_project = ['', '']
  end

  def create_prospect_and_estimate
    create_project
    @old_projects = ZillowLocation.type(project.type_of_project).in_zipcode(project.zip)
    fetch_estimates_from_zillow_api
  rescue => e
    Error.create(message: e.message)
    project.errors.any? ? project.errors.full_messages.to_sentence : e.message
  end

  private

  def create_project
    @project = Project.new(project_params)
    puts project.inspect
  end

  def fetch_estimates_from_zillow_api
    data = URI.parse("https://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz17jcynzxx57_14qhc&address=#{project.address}&citystatezip=#{project.city} #{project.state} #{project.zip}").read
    xml_doc = Nokogiri::XML(data)

    unless xml_doc.at('code').text.to_i == 0
      project.save!
      ProjectMailer.wrong_donation_data(project, project.user.email).deliver_now
      #This is if Zillow couldn't find the address or zestimate is blank.
      return 'The Multiple Listing Services (MLS) database does not have data for this address. Very sorry.'
    end

    coordinates = [xml_doc.at('latitude').text, xml_doc.at('longitude').text]

    project.assign_attributes(
      estimated_value: xml_doc.at('amount').text,
      year_built: xml_doc.at('yearBuilt').text,
      sqft: xml_doc.at('finishedSqFt').text
    )

    if project.other?
      project.save!
      ProjectMailer.other_type_project(project.user, project).deliver_now
      return 'We have emailed you. We thank you for your interest and will be in touch.'
    end

    miles, miles2, year_dif = [Project::MILES1, Project::MILES2, Project::YEAR_DIFF].collect(&:to_i).map(&1.3.method(:*)) if project.estimated_value.to_f > 5000000

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
      project.save!
      return 'We have emailed you. Check your inbox. We thank you for your interest and will be in touch.'
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

    generic_msg_popup = 'We have emailed you. Check your inbox. We thank you for your interest and will be in touch.'

    if project.estimated_value.to_i < 1000000
      msg = "We estimate that your materials would be worth #{final_estimation}. Please remember that this is not an appraisal. Thank you for your interest. "
      msg_return = generic_msg_popup
      ProjectMailer.less_estimate(project.user, project, msg).deliver_now
    else
      if closest_distance_project[0] < miles2
        if year_difference < year_dif
          msg = "Fantastic! Based on similar projects, we estimate that your materials could be worth #{final_estimation}. Please remember that this is an estimate and needs further review."
          msg_return = generic_msg_popup
          ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
        else
          msg = "Fantastic! Based on similar projects, we estimate that your materials could be worth #{final_estimation}. Please remember that this is an estimate and needs further review."
          msg_return = generic_msg_popup
          ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
        end
      elsif closest_distance_project[0] < miles
        if year_difference < year_dif
          msg = "Fantastic! Based on similar projects, we estimate that your materials could be worth #{final_estimation}. Your house is a little distant from our comparison project, so values will vary widely."
          msg_return = generic_msg_popup
          ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
        else
          msg = "Fantastic! Based on similar projects, we estimate that your materials could be worth #{final_estimation}. Your house is a little distant from our comparison project, so values will vary widely."
          msg_return = generic_msg_popup
          ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
        end
      elsif closest_distance_project[0] > miles
        final_estimation = 0.0
        if year_difference < year_dif
          msg = 'You are in a new area for us! An estimate right now would be inaccurate, so please send a bit more information about the timing of your project. If we can schedule a site tour through a local partner, lets do that.'
          msg_return = generic_msg_popup
          ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
        else
          msg = 'You are in a new area for us! An estimate right now would be inaccurate, so please send a bit more information about the timing of your project. If we can schedule a site tour through a local partner, lets do that.'
          msg_return = generic_msg_popup
          ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
        end
      end
    end

    project.val_sf = final_estimation
    project.zillow_location = closest_project
    project.save!
  end

end
