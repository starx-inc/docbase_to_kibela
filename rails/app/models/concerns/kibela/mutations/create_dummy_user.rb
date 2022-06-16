module Kibela::Mutations::CreateDummyUser
  extend ActiveSupport::Concern
  
  Mutation = Kibela::Client::Client.parse <<-'GRAPHQL'
    mutation($input: CreateDisabledUserInput!){
      createDisabledUser(input: $input) { 
        clientMutationId,
        user {
          id
          account
          email
        }
      }
    }
  GRAPHQL
  
  def create_dummy_user
    Kibela::Client::Client.query(
      Mutation,
      variables: {
        input: {
          account: "dummy-user",
          realName: "削除されたユーザー",
          email: "kanri@starx.co.jp"
        }
      }
    )
  end
end