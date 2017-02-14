class Admin::BusinessCategoriesController < Admin::ApplicationController

  layout 'admin'.freeze

  def index
    @business_categories = BusinessCategory.all
    @business_category = BusinessCategory.new
  end

  def create
    @business_category = BusinessCategory.create business_Category_params
    render layout: false
  end

  def destroy
    @business_category = BusinessCategory.find_by id: params[:id]
    @business_category.destroy if @business_category

    respond_to do |format|
      format.html { redirect_to admin_business_categories_path }
      format.js { render layout: false }
    end
  end

  private

  def business_Category_params
    params.require(:business_category).permit(:name, :prefix, :number)
  end
end
