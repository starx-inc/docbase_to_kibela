module Kibela::Mutations::CreateNote
  extend ActiveSupport::Concern
  
  Mutation = Kibela::Client::Client.parse <<-'GRAPHQL'
    mutation createNote($input: CreateNoteInput!) {
      createNote(input: $input) {
        clientMutationId,
        note {
          id,
          path
        }
      }
    }
  GRAPHQL
  
  def create_note
    Kibela::Client::Client.query(
      Mutation,
      variables: {
        {
          input: {
            title: "test",
            content: "# test",
            coediting: true,
            groupIds: ["R3JvdXAvMQ"],
            folders: [
              {
                groupId: "R3JvdXAvMQ",
                folderName: "01.全社共有/イベント"
              }
            ],
            authorId: "VXNlci82NjE"
          }
        }
      }
    )
  end
end