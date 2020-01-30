# frozen_literal_string: true

desc 'Import categories'

task import_categories: :environment do
  file = Roo::Spreadsheet.open('docs/categories.xlsx')
  sheet = file.sheet(0)
  CSV.parse(sheet.to_csv, headers: true, header_converters: :symbol).each do |record|
    attributes_hash = record.to_h
    category = Category.find_or_create_by(name: attributes_hash[:item_name].strip.titleize)
    next if attributes_hash[:subitem_name]&.strip.blank?

    types = attributes_hash[:type].to_s.split(',')
    capacities = attributes_hash[:capacity].to_s.split(',')

    category.sub_categories.find_or_create_by(name: attributes_hash[:subitem_name].strip.titleize, types: types, capacities: capacities)
    p "Created category #{category.name} with sub_category #{attributes_hash[:subitem_name].strip}"
  # rescue StandardError => e
  #   p e.message
  end
end
