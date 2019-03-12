module Mutations
  # inherit Mutations::BaseMutation
  class CreatePost < Mutations::BaseMutation
    # Define what type of value to be returned
    field :post, Types::PostType, null: false

    # Define what argument this mutation accepts
    argument :title, String, required: true
    argument :body, String, required: true

    def resolve(title:, body:)
      # we will use current_user in future
      user = User.first
      post = user.posts.new(title: title, body: body)
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