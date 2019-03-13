module Types
  class MutationType < Types::BaseObject
    field :destroyPost, mutation: Mutations::DestroyPost
    field :updatePost, mutation: Mutations::UpdatePost
    field :createPost, mutation: Mutations::CreatePost
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
