class Api::V1::WebsitesController < ApplicationController
  before_action :set_website, only: [:show, :destroy]

  def create
    website = Website.create(url: params[:url])
    render json: website, status: :created
  end

  def index
    websites = Website.all
    render json: websites
  end

  def show
    responses = @website.responses.order(checked_at: :desc)
    render json: {
      website: @website,
      responses: responses 
    }
  end

  def destroy
    @website.destroy
    head :no_content 
  end

  private

  def set_website
    @website = Website.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Website not found' }, status: :not_found
  end

end
