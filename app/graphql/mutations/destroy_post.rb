module Mutations
  # Don't forget to change to Mutations::BaseMutation
  class DestroyPost < Mutations::BaseMutation
    def ready?(**_args)
      if !context[:current_user]
        raise GraphQL::ExecutionError, "You need to login!"
      else
        true
      end
    end
    # Just returning id is okay
    field :id, ID, null: true

    argument :id, ID, required: true

    def resolve(id:)
      post = Post.find(id)
      if post.user != context[:current_user]
        raise GraphQL::ExecutionError, "You are not authorized!"
      end
      post.destroy
      {
        id: id,
      }
    end
  end
end
