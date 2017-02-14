class Admin::BusinessCategoriesController < Admin::ApplicationController
  before_action :set_business_category, only: [:show, :update, :destroy]

  def index
    @business_categories = BusinessCategory.order(prefix: :asc)
    @business_category = BusinessCategory.new
  end

  def show
  end

  def create
    @business_category = BusinessCategory.new(business_category_params)
    @business_category.save

    render layout: false
  end

  def update
    @updated = @business_category.update(business_category_params)

    render layout: false
  end

  def destroy
    @business_category.destroy

    render layout: false
  end

  private

  def set_business_category
    @business_category = BusinessCategory.find_by(id: params[:id])
    redirect_to admin_business_categories_url unless @business_category
  end

  def business_category_params
    params.require(:business_category).permit(:name, :prefix, :number)
  end
end
