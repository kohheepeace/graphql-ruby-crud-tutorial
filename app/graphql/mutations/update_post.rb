module Mutations
  # Don't forget to change to Mutations::BaseMutation
  class UpdatePost < Mutations::BaseMutation
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
    argument :id, ID, required: true
    # Here we use input objects for practice
    argument :attributes, Types::PostAttributes, required: true

    def resolve(id:, attributes:)
      post = Post.find(id)
      # Add logic for authorization
      if post.user != context[:current_user]
        raise GraphQL::ExecutionError, "You are not authorized!"
      end
      if post.update(attributes.to_h)
        { post: post }
      else
        raise GraphQL::ExecutionError, post.errors.full_messages.join(", ")
      end
    end
  end
end
