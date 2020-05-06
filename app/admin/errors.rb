ActiveAdmin.register Error do
  menu false
  actions :index, :destroy

  index do
    selectable_column
    column :message
    column 'Created at' do |error|
      error.created_at.strftime('%d/%m/%Y')
    end
  end
end
