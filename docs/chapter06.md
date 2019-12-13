# Chap6 Authentication
**Goal of this chapter**
- Only logged in user can create post


**Related official docs**
- https://graphql-ruby.org/authorization/overview.html#what-about-authentication
- https://graphql-ruby.org/mutations/mutation_authorization.html

## Step1 Define `current_user` method
In `controllers/graphql_controller.rb`, we can see a comment how to use `current_user`.

`controllers/graphql_controller.rb`
```ruby
class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = RailsApiGraphqlCrudTutoSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end
  ...
```

Okay let's uncomment this line.

`controllers/graphql_controller.rb`
```ruby
class GraphqlController < ApplicationController
  def execute
    ...
    context = {
      # Query context goes here, for example:
      current_user: current_user,
    }
    ...
```

We need to define `current_user` method.

`controllers/application_controller.rb`
```ruby
class ApplicationController < ActionController::API
  def current_user
    # If test situation when user is logged in
    User.first

    # If test situation when user is not logged in
    # nil
  end

  # This is actual my current_user method
  # current_user method depends on the person
  # def current_user
  #   token = AccessToken.find_token(bearer_token)

  #   if token && !token.expired?
  #     @current_user ||= token.user
  #   end
  # end
end
```

## Step2 Modify `create_post` mutation

Change this

```ruby
user = User.first
post = user.posts.new(title: title, body: body)
```
to

```ruby
post = context[:current_user].posts.new(title: title, body: body)
```
You can use context[:xxxxxxx] like this.

So entire code looks...

`mutations/create_post.rb`
```ruby
module Mutations
  # inherit Mutations::BaseMutation
  class CreatePost < Mutations::BaseMutation
    # Define what type of value to be returned
    field :post, Types::PostType, null: false

    # Define what argument this mutation accepts
    argument :title, String, required: true
    argument :body, String, required: true

    def resolve(title:, body:)
      # you can access current_user in context like this
      post = context[:current_user].posts.new(title: title, body: body)
      # Here returns post field, which is defined above.
      if post.save
        {
          post: post,
          errors: [],
        }
      else
        # Failed save, return the errors to the client
        {
          post: nil,
          errors: post.errors.full_messages
        }
      end
    end
  end
end
```

## Step3. Show error message when user is not logged in

![01](./docs/img/06-authentication/01.png)
https://graphql-ruby.org/mutations/mutation_authorization.html

`mutations/create_post.rb`
```ruby
module Mutations
  # inherit Mutations::BaseMutation
  class CreatePost < Mutations::BaseMutation    # https://stackoverflow.com/questions/3701264/passing-a-hash-to-a-function-args-and-its-meaning
    def ready?(**_args)
      if !context[:current_user]
        raise GraphQL::ExecutionError, "You need to login!"
      else
        true
      end
    end
    
    # Define what type of value to be returned
    field :post, Types::PostType, null: false

    # Define what argument this mutation accepts
    argument :title, String, required: true
    argument :body, String, required: true

    def resolve(title:, body:)
      # you can access current_user in context like this
      post = context[:current_user].posts.new(title: title, body: body)
      # Here returns post field, which is defined above.
      if post.save
        {
          post: post,
          errors: [],
        }
      else
        # Failed save, return the errors to the client
        {
          post: nil,
          errors: post.errors.full_messages
        }
      end
    end
  end
end
```

## Step4 Test it!
### 1. When there is logged-in user
*logged-in user is First User.
![02](./docs/img/06-authentication/02.png)


### 2. When user does not log in
Change current_user to `nil`
```ruby
class ApplicationController < ActionController::API
  def current_user
    # If test situation when user is logged in
    # User.first

    # If test situation when user is not logged in
    nil
  end
  ...
end
```

![03](./docs/img/06-authentication/03.png)

Finish!

