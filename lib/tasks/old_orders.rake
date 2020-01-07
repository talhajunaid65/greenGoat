require 'csv'

namespace :old_orders do
  desc "Reset order and plan data for development and testing purposes."
  task add: :environment do
      ZillowLocation.delete_all
      #Inserting Plans
      plan_queries = []
      csv = CSV.read('db/client-data.csv', :headers=>true)

      csv.each do |project|
        type_of_project = 0
        if project['type'].strip == 'demo'
          type_of_project = 1
        elsif project['type'].strip == 'kitch'
          type_of_project = 2
        elsif project['type'].strip == 'gut'
          type_of_project = 0
        end    

        puts project['type'].strip

              
       ZillowLocation.create(type_of_project: type_of_project, address: project['Street'], city: project['City'], state: project['State'],
        zip: "0#{project['zip']}", user_id: 14, year_built: project['year_built'], val_sf: project['val_sf'])
      end
   
  end
end
