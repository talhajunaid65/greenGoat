# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#sample old projects
ZillowLocation.create(type_of_project: 0, address: '161 Highland Ave', city: 'Newton', state: 'MA', zip: '02465', user_id: 1, year_built: '1872', val_sf: '17.032967032967')
ZillowLocation.create(type_of_project: 0, address: '11 Aspinet Dr.', city: 'Orleans', state: 'MA', zip: '02643', user_id: 1, year_built: '2004', val_sf: '35.8724534986714')
ZillowLocation.create(type_of_project: 0, address: '122 Shornecliffe Rd', city: 'Newton', state: 'MA', zip: '02458', user_id: 1, year_built: '1914', val_sf: '19.1369606003752')
ZillowLocation.create(type_of_project: 0, address: '97 Crest Rd', city: 'Wellesly', state: 'MA', zip: '02482', user_id: 1, year_built: '1920', val_sf: '5.29616724738676')
ZillowLocation.create(type_of_project: 0, address: '346 congress, PH1 & PH2', city: 'Boston', state: 'MA', zip: '02110', user_id: 1, year_built: '1899', val_sf: '30.0751879699248')

ZillowLocation.create(type_of_project: 2, address: '80 audubon rd', city: 'Wellesly', state: 'MA', zip: '02481', user_id: 1, year_built: '1933', val_sf: '2.21143473570658')
ZillowLocation.create(type_of_project: 2, address: '124 Day St', city: 'Newton', state: 'MA', zip: '02466', user_id: 1, year_built: '1941', val_sf: '2.93111871030777')
ZillowLocation.create(type_of_project: 2, address: '20 Evelyn Ave', city: 'Waban', state: 'MA', zip: '02468', user_id: 1, year_built: '1900', val_sf: '7.57805395574417')
ZillowLocation.create(type_of_project: 2, address: '8 Juniper Rd', city: 'Sudbury', state: 'MA', zip: '01776', user_id: 1, year_built: '1966', val_sf: '2.06100577081616')
ZillowLocation.create(type_of_project: 2, address: '21 Marlborough St', city: 'Boston', state: 'MA', zip: '02136', user_id: 1, year_built: '1910', val_sf: '32.5971580208868')
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?