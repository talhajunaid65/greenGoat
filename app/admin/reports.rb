ActiveAdmin.register_page "Reports" do
  content do
    render partial: 'admin/reports/types'
  end

  page_action :item_waiting_uninstallation, method: :get do
    @items = Product.available_products.need_uninstallation
    render 'admin/items/waiting_for_uninstallation'
  end

  page_action :sale_waiting_delivery, method: :get do
    @sales = Sale.waiting_delivery
    render 'admin/sales/waiting_delivery'
  end

  page_action :projects_approaching_demo, method: :get do
    @projects = Project.approaching_demo
    render 'admin/projects/approaching_demo'
  end

  page_action :sales_search do
    @sales = params[:q].present? ? Sale.search(params[:q]) : []
    render 'admin/sales/search'
  end
end
