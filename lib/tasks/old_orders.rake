require 'csv'

namespace :old_orders do
  desc "Reset order and plan data for development and testing purposes."
  task add: :environment do

      #Inserting Plans
      # plan_queries = []
      # csv = CSV.read('db/client-data.csv', :headers=>true)

      # csv.each do |project|
      #   type_of_project = 0
      #   if project['type'] == 'demo'
      #     type_of_project = 0
      #   elsif project['type'] == 'kitch'
      #     type_of_project = 2
      #   elsif project['type'] == 'gut'
      #     type_of_project = 1
      #   end    

              
      #   if 
      #  Project.create(type_of_project: 0, address: project['Street'], city: project['City'], state: project['State']
      #   , zip: project['zip'], user_id: 1, year_built: project['year_built'], val_sf: project['val_sf'])
      # end
   
  end
end
