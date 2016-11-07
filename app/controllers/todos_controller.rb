class TodosController < ApplicationController
  before_action :authenticate_user!

  def index
    @todos = current_user.todos
  end

  def create
    Todo.create(item: params[:item], complete: false, user: current_user)
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

  def toggle
    todo = Todo.find(params[:id])
    todo.complete = !todo.complete
    todo.save
    redirect_to root_path
  end
end
