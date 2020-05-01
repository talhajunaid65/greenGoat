ActiveAdmin.register ProjectProduct, as: 'ItemLocation' do
  menu false

  actions :new, :create

  form do |f|
    f.inputs do
      f.input :project, as: :select, collection: Project.contract
      f.input :product_id, as: :hidden, input_html: { value: params[:item_id] || resource.product_id }
    end
    f.actions do
      f.action :submit, label: 'Move to Project'
      f.action :cancel, label: 'Cancel'
    end
  end

  controller do
    def create
      create! do |format|
        if resource.save
          ProductStatus.create!(new_status: 9, admin_user_id: current_admin_user.id)
          format.html { redirect_to admin_project_path(resource.project_id) }
        else
          format.html { render :new }
        end
      end
    end
  end

  permit_params :project_id, :product_id
end
