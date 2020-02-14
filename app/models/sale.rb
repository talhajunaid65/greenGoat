class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :pm, class_name: 'AdminUser', foreign_key: 'pm_id'

  enum payment_method: %i[cash check credit_card]
  enum sale_source: {
    'FB' => 0,
    'CL' => 1,
    'gG' => 2,
    'Cross Sell' => 3,
    'other' => 4
  }
  enum pickup_status: %i[pending delivered]

  validates :product_id, :user_id, presence: true

  delegate :status, to: :product, prefix: true, allow_nil: true

  scope :visits_due, -> { where(visit_date: Date.today) }
  scope :waiting_delivery, -> { where(pickup_status: 'pending') }
  scope :delivered, -> { where(pickup_status: 'pending') }
  scope :matched_zipcode, -> (zipcode) { where(zipcode: zipcode) }
  scope :user_sales, -> (user_id) { where(user_id: user_id) }
  scope :by_sale_source, -> (sale_source) { where(sale_source: sale_source) }
  scope :by_other_source, -> (other_source) { where('other_source LIKE ?', "%#{other_source}%") }
  scope :by_pm, -> (pm_id) { where(pm_id: pm_id) }

  validates :pickup_status, :delivery_address, :city, :state, :zipcode, :delivery_cost, :delivery_date, presence: true, if: :need_delivery?

  def to_s
    user
  end

  def self.search(params)
    sales = all.includes(:product, :user)
    sales = sales.where('DATE(created_at) >= ?', params[:from]) unless params[:from].blank?
    sales = sales.where('DATE(created_at) <= ?', params[:to]) unless params[:to].blank?
    sales = sales.matched_zipcode(params[:zipcode]) unless params[:zipcode].blank?
    sales = sales.user_sales(params[:user_id]) unless params[:user_id].blank?
    sales = sales.by_sale_source(params[:sale_source]) unless params[:sale_source].blank?
    sales = sales.by_other_source(params[:other_source]) unless params[:other_source].blank?
    sales = sales.by_pm(params[:pm_id]) unless params[:pm_id].blank?

    sales
  end
end
