class TodosController < ApplicationController
  def index
    @todos = Todo.all
  end

  def create
    Todo.create(item: params[:item], complete: false)
    redirect_back fallback_location: root_path
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
    redirect_back fallback_location: root_path
  end

  def edit
    @todo = Todo.find(params[:id])
  end

  def update
    todo = Todo.find(params[:id])
    todo.update(item: params[:item])
    redirect_to root_path
  end
end
