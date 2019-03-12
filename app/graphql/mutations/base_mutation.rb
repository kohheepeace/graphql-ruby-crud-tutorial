# We use GraphQL::Schema::Mutation not GraphQL::Schema::RelayClassicMutation
# Because I use apollo-client
class Mutations::BaseMutation < GraphQL::Schema::Mutation
end