# jQuery와 Ruby on Rails로 쉽고 빠른 웹 개발하기

## Ruby on Rails 의 장점

1. 코드를 읽기 쉽다. Ruby는 psesudo 코드 같다
2. SQL문을 작성할 필요가 없다. ORM(Object Relation Mapping)이 너무 편하다
3. 최소한의 세팅으로 웹 개발에 필요한 온갖 라이브러리를 활용할 수 있다
4. 시간을 아껴주는 generator가 많다

## Ruby on Rails 개발환경 세팅하기

- [OS별 설치 가이드 : installrails.com](http://installrails.com/)
- 에디터는 [Atom](https://atom.io/), [Sublime Text](https://www.sublimetext.com/) 등 추천 (웹 개발은 Vim 또는 Emacs 사용 권장)
- 레일즈 버전 확인 : `$ rails -v`

## 레일즈 프로젝트 생성하기

1. 프로젝트 생성하기

    ```bash
    $ rails new todo-list
    $ cd todo-list
    ```

1. 서버 실행하기

    ```bash
    $ rails s
    ```

    http://localhost:3000 에서 확인 가능

## Scaffold를 이용해 Rails 구조 살펴보기

```
$ rails g scaffold Post title:string content:text
$ rake db:migrate
```

`http://localhost:3000/posts` 에서 확인

![레일즈 구조](./mvc.png)

## 간단한 TODO 리스트 만들기

1. Todo 모델 생성하기

    내용을 담을 item (string 타입)과 투두 완료 상태를 담을 complete (boolean 타입)을 컬럼으로 생성합니다.

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

    complete의 경우 default 값을 false로 지정하고 item의 경우 반드시 내용이 있도록 DB를 세팅합니다.

1. todos 테이블 생성하기

    마이그레이션 파일을 토대로 DB에 테이블을 생성합니다.

    ```bash
    $ rake db:migrate
    ```

    `$ rails console` 또는 `$ rails c` 명령어를 통해 레일즈 콘솔을 이용할 수 있습니다.

    콘솔에서 todo를 몇 가지 생성하고 조회해 보겠습니다.

    ```ruby
    Todo.create(item: '첫번째 할 일', complete: false)
    Todo.create(item: '두번째 할 일', complete: false)
    Todo.create(item: '세번째 할 일', complete: true)
    a = Todo.find(1)
    b = Todo.find(2)
    b.complete = true
    b.save
    Todo.all
    Todo.where(complete: true)
    ```

    [액티브레코드 쿼리 인터페이스](http://rubykr.github.io/rails_guides/active_record_querying.html)

1. Todos 컨트롤러 생성하기

    Todos 컨트롤러를 생성하고 컨트롤러 속에 index 액션을 추가합니다. 액션은 사용자의 요청을 처리하는 하나의 단위 이며 Todos 컨트롤러(클래스)에 index 메소드를 정의합니다. 그리고 app/views/todos/index.html.erb 파일을 자동 생성합니다.

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

    root '[컨트롤러]#[액션]' 은 홈페이지를 지정하는 것이며 root_path라는 별칭을 가집니다. `$ rake routes` 명령어로 라우트 규칙을 확인할 수 있습니다.

1. Todos 컨트롤러의 index 액션에서 전체 Todo 내용 불러오기

    `app/controllers/todos_controller.rb`

    ```ruby
     class TodosController < ApplicationController
       def index
    +    @todos = Todo.all
       end
     end
    ```

    .all 메소드를 이용해 Todo 모델에서 모든 데이터를 불러옵니다. @todos 변수는 인스턴스 변수로 view에서 활용할 수 있게 됩니다.

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

    `<% %>` 속에 루비코드를 작성할 수 있습니다. 리턴값 출력을 원할 경우 `<%= %>`를 사용합니다.

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

    form tag 헬퍼를 이용하면 csrf 공격 방어를 위한 코드를 자동생성 해줍니다.

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

    rails 4 버전의 경우 `redirect_back fallback_location: root_path` 대신 `redirect_to :back` 코드를 사용합니다.

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

    [rails 라우트 한글 가이드](http://guides.rorlab.org/routing.html)

1. [CDN에서 Font Awesome](https://www.bootstrapcdn.com/fontawesome/) 불러오기

    `app/views/layouts/application.html.erb`

    ```erb
         <%= csrf_meta_tags %>

         <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    +    <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css
         <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
       </head>
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

    앞으로 todo 객체에서 `.user` 메소드를 사용할 수 있게 됩니다. 해당 todo를 작성한 user 객체를 호출할 수 있습니다.

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
    앞으로 user 객체에서 `.todos` 메소드를 사용할 수 있게 됩니다. 해당 user가 작성한 todo 객체들의 배열을 가져 옵니다.

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

## 수정 기능 ajax 로 처리하기

1. item을 span tag로 감싸기

    `app/views/todos/index.html.erb`

    ```html
             <% if t.complete %>
               <i class="fa fa-check-square-o" aria-hidden="true"></i>
             <% else %>
               <i class="fa fa-square-o" aria-hidden="true"></i>
             <% end %>
           <% end %>
    -      <%= t.item %>
    +      <span data-id="<%= t.id %>" class="item"><%= t.item %></span>
           <%= link_to '수정', edit_todo_path(t) %>
           <%= link_to '삭제', todo_path(t), method: :delete %>
         </li>
    ```

1. javascript 코드 작성하기

    `app/assets/javascripts/todos.coffee`를 `app/assets/javascripts/todos.js`로 수정하기

    주석을 모두 제거하기

    ```javascript
    $(document).on('turbolinks:load', function() {
      $('.item').bind('dblclick', function() {
        $(this).attr('contentEditable', true)
          .keypress(function(e) {
            if (e.which == 13) {
              $.ajax({url: '/todos/' + $(this).data('id'),
                     type: 'patch',
                     data: {item: $(this).text()}});
              return false;
            }
          });
      }).blur(function() {
        $(this).attr('contentEditable', false);
      });
    });
    ```

1. jQuery <=> javascript

    - 참고자료 : [You might not need jQuery](http://youmightnotneedjquery.com/)


