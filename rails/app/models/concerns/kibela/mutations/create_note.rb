module Kibela::Mutations::CreateNote
  extend ActiveSupport::Concern
  
  Mutation = Kibela::Client::Client.parse <<-'GRAPHQL'
    mutation ($input: CreateNoteInput!) {
      createNote(input: $input) {
        clientMutationId,
        note {
          id,
          url
        }
      }
    }
  GRAPHQL
  
  def create_note(title, content, group_ids, folders, author_id)
    query(
      Mutation,
      variables: {
        input: {
          title: title,
          content: content,
          coediting: true,
          groupIds: group_ids,
          folders: folders,
          authorId: author_id
        }
      }
    )
  end
end
