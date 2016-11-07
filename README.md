# jQuery와 Ruby on Rails로 쉽고 빠른 웹 개발하기

## Ruby on Rails 의 장점

1. 코드를 읽기 쉽다. Ruby는 psesudo 코드 같다
2. SQL문을 작성할 필요가 없다. ORM(Object Relation Mapping)이 너무 편하다
3. 최소한의 세팅으로 웹 개발에 필요한 온갖 라이브러리를 활용할 수 있다
4. 시간을 아껴주는 generator가 많다

## Ruby on Rails 개발환경 세팅하기

- [OS별 설치 가이드 : installrails.com](http://installrails.com/)
- 에디터는 [Atom](https://atom.io/), [Sublime Text](https://www.sublimetext.com/) 등 추천 (웹 개발은 Vim 또는 Emacs 사용 권장)


## 간단한 TODO 리스트 만들기

1. 프로젝트 생성하기

    ```bash
    $ rails new todo-list
    ```

1. Todo 모델 생성하기

    ```bash
    $ rails g model Todo item:string complete:boolean
    ```

1. todos 마이그레이션 파일 수정하기

    `db/migrate/xxxxxxxxxxxxxx_create_todos.rb`

    ```ruby
     class CreateTodos < ActiveRecord::Migration[5.0]
       def change
         create_table :todos do |t|
    -      t.string :item
    -      t.boolean :complete
    +      t.string :item, null: false
    +      t.boolean :complete, default: false

           t.timestamps
         end
    ```

1. todos 테이블 생성하기

    ```bash
    $ rake db:migrate
    ```

1. Todos 컨트롤러 생성하기

    ```bash
    $ rails g controller Todos index
    ```

1. 홈페이지 설정하고, todos 라우팅 설정하기

    `config/routes.rb` 파일 수정

    ```ruby
     Rails.application.routes.draw do
    -  get 'todos/index'
    +  root 'todos#index'
    +  resources :todos

       # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
     end
    ```

1. Todos 컨트롤러의 index 액션에서 전체 Todo 내용 불러오기

    `app/controllers/todos_controller.rb`

    ```ruby
     class TodosController < ApplicationController
       def index
    +    @todos = Todo.all
       end
     end
    ```

1. View에 전체 리스트 출력하기

    `app/views/todos/index.html.erb`

    ```html+erb
    -<h1>Todos#index</h1>
    -<p>Find me in app/views/todos/index.html.erb</p>
    +<h1>TODO 리스트</h1>
    +<ul>
    +  <% @todos.each do |t| %>
    +    <li><%= t.item %></li>
    +  <% end %>
    +</ul>
    ```

1. 새로운 TODO 작성을 위한 Form

    `app/views/todos/index.html.erb`

    ```html+erb
     <h1>TODO 리스트</h1>
    +<%= form_tag todos_path do %>
    +  <%= text_field_tag :item, nil, placeholder: "새로운 할 일", autofocus: true %>
    +  <%= submit_tag "추가" %>
    +<% end %>
     <ul>
       <% @todos.each do |t| %>
         <li><%= t.item %></li>
    ```

1. DB에 todo를 저장하기 위한 create 액션 작성하기

    `app/controllers/todos_controller.rb`

    ```ruby
       def index
         @todos = Todo.all
       end
    +
    +  def create
    +    Todo.create(item: params[:item], complete: false)
    +    redirect_back fallback_location: root_path
    +  end
     end
    ```

1. 삭제 링크 만들기

    `app/views/todos/index.html.erb`

    ```html+erb
     <% end %>
     <ul>
       <% @todos.each do |t| %>
    -    <li><%= t.item %></li>
    +    <li>
    +      <%= t.item %>
    +      <%= link_to '삭제', todo_path(t), method: :delete %>
    +    </li>
       <% end %>
     </ul>
    ```

1. destroy 액션 만들기

    `app/controllers/todos_controller.rb`

    ```ruby
         Todo.create(item: params[:item], complete: false)
         redirect_back fallback_location: root_path
       end
    +
    +  def destroy
    +    todo = Todo.find(params[:id])
    +    todo.destroy
    +    redirect_back fallback_location: root_path
    +  end
     end
    ```

1. edit 링크 추가

    `app/views/todos/index.html.erb`

    ```html+erb
       <% @todos.each do |t| %>
         <li>
           <%= t.item %>
    +      <%= link_to '수정', edit_todo_path(t) %>
           <%= link_to '삭제', todo_path(t), method: :delete %>
         </li>
       <% end %>
    ```

1. edit 액션 만들기

    `app/controllers/todos_controller.rb`

    ```ruby
         todo.destroy
         redirect_back fallback_location: root_path
       end
    +
    +  def edit
    +    @todo = Todo.find(params[:id])
    +  end
     end
    ```

1. `app/views/todos/edit.html.erb` edit 뷰 생성하기

    ```html+erb
    <%= form_tag todo_path(@todo), method: :patch do %>
      <%= text_field_tag :item, @todo.item, placeholder: "새로운 할 일", autofocus: true %>
      <%= submit_tag "수정" %>
    <% end %>
    ```

1. update 액션 기능 구현

    `app/controllers/todos_controller.rb`

    ```ruby
       def edit
         @todo = Todo.find(params[:id])
       end
    +
    +  def update
    +    todo = Todo.find(params[:id])
    +    todo.update(item: params[:item])
    +    redirect_to root_path
    +  end
     end
    ```

## 회원가입, 로그인 등 User 기능 만들기

1. devise 젬 설치하기
