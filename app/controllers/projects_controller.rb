class ProjectsController < ApiController
    before_action :authenticate_user!, only: [:my_activity]

    def index
      projects = Project.all
      render json: projects, status: :ok
    end

    def show
      project = Project.find(params[:id])

      render json: project, status: :ok
    end

    def create
      project = current_user.project.new(project_params)
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
    	project = Project.create(project_params)
    	puts project.inspect
    	old_projects = ZillowLocation.all
    	closest_distance_project = ['', '']
    	msg_return = ''

    	#getting location information from zilloq
    	require "open-uri"
			data = URI.parse("https://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz17jcynzxx57_14qhc&address=#{project.address}&citystatezip=#{project.city} #{project.state} #{project.zip}").read
    	xml_doc = Nokogiri::XML(data)
    	if xml_doc.at('code').text == '0'
	    	zestimate = xml_doc.at('amount').text
	    	coordinates = [xml_doc.at('latitude').text, xml_doc.at('longitude').text]
	    	year_built = xml_doc.at('yearBuilt').text
	    	sqfoot = xml_doc.at('finishedSqFt').text

	    	#getting closest project from old projects
	    	if project.type_of_project == "gut" or project.type_of_project == "full"
	    		old_projects.each do |old_project|
	    			if old_project.type_of_project == "gut" or project.type_of_project == "full"
	    				old_data = URI.parse("https://www.zillow.com/webservice/GetSearchResults.htm?zws-id=X1-ZWz17jcynzxx57_14qhc&address=#{old_project.address}&citystatezip=#{old_project.city} #{old_project.state} #{old_project.zip}").read
				    	old_xml_doc = Nokogiri::XML(data)
				    	old_project_coordinates = [old_xml_doc.at('latitude').text, old_xml_doc.at('longitude').text]
	    				old_project_coordinates = Geocoder.search("#{old_project.address}, #{old_project.city} #{old_project.zip}").first.coordinates unless old_project_coordinates
	    				puts "#{old_project.address}, #{old_project.city} #{old_project.zip}"
	    				distance = Geocoder::Calculations.distance_between(coordinates, old_project_coordinates)
	    				closest_distance_project = [distance, old_project.id] if closest_distance_project.all?(&:blank?) or distance < closest_distance_project[0]
	    			end	
	    		end	

	    	elsif project.type_of_project == "kitchen"
	    		old_projects.each do |old_project|
	    			if old_project.type_of_project == "kitchen"
	    				old_data = URI.parse("https://www.zillow.com/webservice/GetSearchResults.htm?zws-id=X1-ZWz17jcynzxx57_14qhc&address=#{old_project.address}&citystatezip=#{old_project.city} #{old_project.state} #{old_project.zip}").read
				    	old_xml_doc = Nokogiri::XML(data)
				    	old_project_coordinates = [old_xml_doc.at('latitude').text, old_xml_doc.at('longitude').text]
	    				old_project_coordinates = Geocoder.search("#{old_project.address}, #{old_project.city} #{old_project.zip}").first.coordinates unless old_project_coordinates
	    				puts "#{old_project.address}, #{old_project.city} #{old_project.zip}"
	    				distance = Geocoder::Calculations.distance_between(coordinates, old_project_coordinates)
	    				closest_distance_project = [distance, old_project.id] if closest_distance_project.all?(&:blank?) or distance < closest_distance_project[0]
	    			end	
	    		end	
	    	else
	    		ProjectMailer.other_type_project(project.user, project).deliver_now
	    		msg_return = "We don't have estimations for this project type yet. We will contact you soon! Thank's"
	    	end	

	    	unless project.type_of_project == "other" 	
		    	#calculating estimation
		    	closest_project = ZillowLocation.find(closest_distance_project[1])
		    	
		    	if closest_distance_project[0] < 2
		    		if zestimate.to_i < 1000000
		    			ProjectMailer.less_estimate(project.user, project).deliver_now
		    			msg_return = "We will get back to you after further review of your application. Hang tight!!!"
		    		else
		    			if (closest_project.year_built.to_i - year_built.to_i) <10
		    				final_estimation = sqfoot * closest_project.val_sf
		    				msg = ''
		    				ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
		    				msg_return = "Please Check your email for our initial Qoute, Values may vary after appraisal"
		    			else
		    				msg = 'Your house is within 2 miles of one of our old project, but it is a few years old, so we will contact you after review.'
		    				ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
		    				msg_return = msg
		    			end	
		    		end						
		    	elsif closest_distance_project[0] <5
		    		if zestimate.to_i < 1000000
		    			ProjectMailer.less_estimate(project.user, project).deliver_now
		    			msg_return = "We will get back to you after further review of your application. Hang tight!!!"
		    		else
		    			if (closest_project.year_built.to_i - year_built.to_i) <10
		    				final_estimation = sqfoot * closest_project.val_sf
		    				msg = 'We found similar project a bit out of your neighbourhood, so values may very widely.'
		    				ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
		    				msg_return = msg
		    			else
		    				msg = 'Your house is within 5 miles of one of our old project, but it is a few years old, so we will contact you after review.'
		    				ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
		    				msg_return = msg
		    			end	
		    		end
		    	elsif closest_distance_project[0] > 5
		    		if zestimate.to_i < 1000000
		    			ProjectMailer.less_estimate(project.user, project).deliver_now
		    			msg_return = ''
		    		else
		    			if (closest_project.year_built.to_i - year_built.to_i) <10
		    				final_estimation = sqfoot * closest_project.val_sf
		    				msg = 'Your house is in a new neighbourhood for house, We would be happy to come check out your project free of charge.'
		    				ProjectMailer.estimate_email(project.user, project, final_estimation.to_i, msg).deliver_now
		    				msg_return = msg
		    			else
		    				msg = 'Your house is more than 5 miles far fromone of our old project, but that project is a few years old, so we will contact you after review.'
		    				ProjectMailer.old_house_estimate(project.user, project, msg).deliver_now
		    				msg_return = msg
		    			end	
		    		end
		    	end
		    end
		  else
		  	ProjectMailer.wrong_donation_data(project, project.user.email).deliver_now
		  	msg_return = "We could not find any house for the information provided above. Thank you"
	    end	

    	render json: { message: msg_return}, status: :ok
    end	

    def my_activity
    	my_projects = current_user.projects.select("id, created_at")
    	return_object = []

    	my_projects.each do |project|
    		return_object << {id: project.id.to_s , message: "Your donation form ID:#{project.id} is under review", created_at: "#{project.created_at.to_date} #{ project.created_at.strftime('%I:%M%p') }"}
    	end	
    	
    	render json: return_object, status: :ok
    end	

    private

    def project_params
      params.require(:project).permit(:type_of_project, :address, :city, :state, :zip, :year_built, :user_id, :status, :tracking_id, :val_sf, :estimated_value, :start_date)
    end
end