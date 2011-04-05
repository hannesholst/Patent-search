class SearchesController < ApplicationController

  def index
    @search = Search.new
    
  end

  def new
  end
  def create
    @search = Search.new params[:search]
  end
end
