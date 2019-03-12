module Mutations
  # inherit Mutations::BaseMutation
  class CreatePost < Mutations::BaseMutation
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