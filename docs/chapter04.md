# Chap4 Query(GET)

!!! abstract "Goal of this chapter"
    1. Implement Query(GET)

In this chapter we will try to implement Query.

**Query is equivalent to Rest GET request.**

## Step1 Edit `query_type.rb`

This is initial `graphql/types/query_type.rb` file.
```ruby
module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
```

Add new query field `posts`
```ruby
field :posts, [PostType], null: true
def posts
  Post.all
end
```

So the `graphql/types/query_type.rb` is...

`graphql/types/query_type.rb`
```ruby
module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :posts, [PostType], null: true
    def posts
      Post.all
    end
  end
end
```

This means...

- field posts is array of PostType and It is ok to return nullable value.
- posts method returns Post.all

## Step2 define `PostType`

Next, We need to define `PostType`


![01](./docs/img/04-query-get/01.png)
https://graphql-ruby.org/getting_started#getting-started

`terminal`
```bash
rails g graphql:object Post title:String body:String

Running via Spring preloader in process 62001
      create  app/graphql/types/post_type.rb
```

This generates the below code.
`types/post_type.rb`
```ruby
module Types
  class PostType < Types::BaseObject
    field :title, String, null: true
    field :body, String, null: true
  end
end
```

Imitate official guide, we will add `description` and `id`.
![02](./docs/img/04-query-get/02.png)
https://graphql-ruby.org/getting_started#declare-types

so...

`post_type.rb`
```ruby
module Types
  class PostType < Types::BaseObject
    description "A blog post"
    field :id, ID, null: false
    field :title, String, null: false
    field :body, String, null: true
  end
end
```
​
## Step3 Run query from graphiql

visit: http://api.localhost:3000/graphiql​

Query by using graphiql...
![03](./docs/img/04-query-get/03.png)

It works!!!


## Step4 Recap the flow
Here we will recap the flow!!!

1. query posts from graphiql 
![04](./docs/img/04-query-get/04.png)
​

Check the terminal log!

2. `POST "/graphql"` is fired.

3. It fires `GraphqlController#execute` action.

`terminal`
```bash
Started POST "/graphql" for 127.0.0.1 at 2019-03-12 15:09:45 +0800
Processing by GraphqlController#execute as */*
  Parameters: {"query"=>"query {\n  posts {\n    id\n    title\n    body\n  }\n}", "variables"=>nil, "subdomain"=>"api", "graphql"=>{"query"=>"query {\n  posts {\n    id\n    title\n    body\n  }\n}", "variables"=>nil}}
  Post Load (0.9ms)  SELECT "posts".* FROM "posts"
  ↳ app/controllers/graphql_controller.rb:10
Completed 200 OK in 40ms (Views: 0.3ms | ActiveRecord: 11.1ms)
```

4. In def execute action, query is executed.

`graphql_controller.rb`
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
end
```
​

`RailsApiGraphqlCrudTutoSchema` is defined in...

`rails_api_graphql_crud_tuto_schema.rb`
```ruby
class RailsApiGraphqlCrudTutoSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
```

`Types::QueryType` is defined in...

`types/query_type.rb`
```ruby
module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :posts, [PostType], null: true
    def posts
      Post.all
    end
  end
end
```

`PostType` is defined in...

`types/post_type.rb`
```ruby
module Types
  class PostType < Types::BaseObject
    description "A blog post"
    field :id, ID, null: false
    field :title, String, null: false
    field :body, String, null: true
  end
end
```

So, finally we get the json result!

`result`
```
{
  "data": {
    "posts": [
      {
        "id": "1",
        "title": "Death Be Not Proud",
        "body": "Sapiente dignissimos veniam. Et eius velit. Quam dolorem id."
      }
    ]
  }
}
```
​

