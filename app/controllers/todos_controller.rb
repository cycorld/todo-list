class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [:destroy, :edit, :update, :toggle]
  before_action :check_owner, only: [:destroy, :edit, :update, :toggle]

  def index
    @todos = current_user.todos
  end

  def create
    Todo.create(item: params[:item], complete: false, user: current_user)
    redirect_back fallback_location: root_path
  end

  def destroy
    @todo.destroy
    redirect_back fallback_location: root_path
  end

  def edit
  end

  def update
    @todo.update(item: params[:item])
    redirect_to root_path
  end

  def toggle
    todo = Todo.find(params[:id])
    @todo.complete = !todo.complete
    @todo.save
    redirect_to root_path
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def check_owner
    unless current_user == @todo.user
      flash[:alert] = '권한이 없습니다'
      return redirect_to root_path
    end
  end
end
