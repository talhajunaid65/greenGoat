ActiveAdmin.register Error do
  actions :index, :destroy

  index do
    selectable_column
    column :message
    column 'Created at' do |error|
      error.created_at.strftime('%d/%m/%Y')
    end
  end
end
