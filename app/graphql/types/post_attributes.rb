module Types
  class PostAttributes < Types::BaseInputObject
    description "Attributes for creating or updating a blog post"
    argument :title, String, "Header for the post", required: true
    argument :body, String, "Full body of the post", required: true
  end
end
