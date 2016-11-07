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
    $ cd todo-list
    ```

1. 서버 실행하기

    ```bash
    $ rails s
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

1. CSS 적용하기 : [Spoqa 폰트](http://spoqa.github.io/spoqa-han-sans/), [w3schools](http://www.w3schools.com/css/css_form.asp)

    `app/assets/stylesheets/todos.scss`

    ```scss
    @import url(//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSans-kr.css);
    * { font-family: 'Spoqa Han Sans', 'Spoqa Han Sans JP', 'Sans-serif'; }

    input[type=text], input[type=email], input[type=password] {
        width: 200px;
        padding: 12px 20px;
        margin: 8px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }

    input[type=submit] {
        background-color: #4CAF50;
        color: white;
        padding: 14px 20px;
        margin: 8px 0;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    input[type=submit]:hover {
        background-color: #45a049;
    }

    ul {
      padding: 0;
      li {
        list-style: none;
        padding: 6px 0;
      }
    }
    a {
      color: #5484A4;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
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

    +  def update
    +    todo = Todo.find(params[:id])
    +    todo.update(item: params[:item])
    +    redirect_to root_path
    +  end
     end
    ```

1. 체크 토글 버튼 추가하기 : [Font Awesome](http://fontawesome.io/icons/) 사용하여 아이콘 표현

    `app/views/todos/index.html.erb`

    ```erb
     <ul>
       <% @todos.each do |t| %>
         <li>
    +      <%= link_to toggle_todo_path(t) do %>
    +        <% if t.complete %>
    +          <i class="fa fa-check-square-o" aria-hidden="true"></i>
    +        <% else %>
    +          <i class="fa fa-square-o" aria-hidden="true"></i>
    +        <% end %>
    +      <% end %>
           <%= t.item %>
           <%= link_to '수정', edit_todo_path(t) %>
           <%= link_to '삭제', todo_path(t), method: :delete %>
    ```

1. [CDN에서 Font Awesome](https://www.bootstrapcdn.com/fontawesome/) 불러오기

    `app/views/layouts/application.html.erb`

    ```erb
         <%= csrf_meta_tags %>

         <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    +    <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css
         <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
       </head>
    ```

1. toggle 라우트 추가하기

    `config/routes.rb`

    ```erb
     Rails.application.routes.draw do
       root 'todos#index'
    -  resources :todos
    +  resources :todos do
    +    member do
    +      get 'toggle'
    +    end
    +  end

       # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
     end
    ```

1. toggle 액션 기능 구현하기

    ```ruby
         todo.update(item: params[:item])
         redirect_to root_path
       end

    +  def toggle
    +    todo = Todo.find(params[:id])
    +    todo.complete = !todo.complete
    +    todo.save
    +    redirect_to root_path
    +  end
     end
    ```

## 회원가입, 로그인 등 User 기능 만들기

1. [devise 젬](https://github.com/plataformatec/devise) 설치하기

    `Gemfile` 에 아래 코드 추가

    ```
    gem 'devise'
    ```

    젬 설치 하기

    ```bash
    $ bundle install
    ```

    Devise init 하기

    ```bash
    $ rails generate devise:install
    ```

    서버 재시작하기

    ```bash
    Ctrl + c 로 서버 종료 후
    $ rails s
    ```

    Devise 뷰 생성하기

    ```bash
    $ rails g devise:views
    ```

    User 모델 생성하기

    ```bash
    $ rails generate devise User
    ```

    users 테이블 생성하기

    ```bash
    $ rake db:migrate
    ```

1. 메뉴 만들기

    `app/views/layouts/application.html.erb`

    ```erb
       </head>

       <body>
    +    <% if user_signed_in? %>
    +      <%= current_user.email %>
    +      <%= link_to '로그아웃', destroy_user_session_path, method: :delete %>
    +    <% else %>
    +      <%= link_to '로그인', new_user_session_path %>
    +      <%= link_to '회원가입', new_user_registration_path %>
    +    <% end %>
    +
    +    <p class="notice"><%= notice %></p>
    +    <p class="alert"><%= alert %></p>
    +
         <%= yield %>
       </body>
     </html>
    ```

1. 로그인한 사용자만 접근 가능하도록 만들기

    `app/controllers/todos_controller.rb`

    ```ruby
     class TodosController < ApplicationController
    +  before_action :authenticate_user!

       def index
         @todos = Todo.all
       end
     end
    ```

1. todos 테이블에 user_id (foreign key) 추가하기

    ```bash
    $ rails g migration AddUserToTodos user:references
    ```

    todos 테이블에 user_id 컬럼 추가 반영하기

    ```bash
    $ rake db:migrate
    ```

1. Todo 모델과 User 모델 관계 설정하기

    `app/models/todo.rb`

    ```ruby
     class Todo < ApplicationRecord
    +  belongs_to :user
     end
    ```

    `app/models/user.rb`

    ```ruby
     class User < ApplicationRecord
       # Include default devise modules. Others available are:
       # :confirmable, :lockable, :timeoutable and :omniauthable
       devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :trackable, :validatable
    +  has_many :todos
     end
    ```

1. 사용자의 Todo만 보여주기

    `app/controllers/todos_controller.rb`

    ```ruby
       def index
    -    @todos = Todo.all
    +    @todos = current_user.todos
       end
    ```

1. Todo 작성시 사용자 정보 넣기

    `app/controllers/todos_controller.rb`

    ```ruby
       def create
    -    Todo.create(item: params[:item], complete: false)
    +    Todo.create(item: params[:item], complete: false, user: current_user)
         redirect_back fallback_location: root_path
       end
    ```

1. before_action을 이용해 권한 설정하기

    `app/controllers/todos_controller.rb`

    ```ruby
     class TodosController < ApplicationController
       before_action :authenticate_user!
    +  before_action :set_todo, only: [:destroy, :edit, :update, :toggle]
    +  before_action :check_owner, only: [:destroy, :edit, :update, :toggle]

       def index
         @todos = current_user.todos
       end

       def create
         Todo.create(item: params[:item], complete: false, user: current_user)
         redirect_back fallback_location: root_path
       end

       def destroy
    -    todo = Todo.find(params[:id])
    -    todo.destroy
    +    @todo.destroy
         redirect_back fallback_location: root_path
       end

       def edit
    -    @todo = Todo.find(params[:id])
       end

       def update
    -    todo = Todo.find(params[:id])
    -    todo.update(item: params[:item])
    +    @todo.update(item: params[:item])
         redirect_to root_path
       end

       def toggle
         todo = Todo.find(params[:id])
    -    todo.complete = !todo.complete
    -    todo.save
    +    @todo.complete = !todo.complete
    +    @todo.save
         redirect_to root_path
       end

    +  private
    +
    +  def set_todo
    +    @todo = Todo.find(params[:id])
    +  end
    +
    +  def check_owner
    +    unless current_user == @todo.user
    +      flash[:alert] = '권한이 없습니다'
    +      return redirect_to root_path
    +    end
    +  end
     end
    ```

