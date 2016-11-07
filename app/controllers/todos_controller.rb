class TodosController < ApplicationController
  def index
    @todos = Todo.all
  end

  def create
    Todo.create(item: params[:item], complete: false)
    redirect_back fallback_location: root_path
  end
end
