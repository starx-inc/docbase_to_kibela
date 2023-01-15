module Kibela::Mutations::CreateComment
  extend ActiveSupport::Concern
  
  Mutation = Kibela::Client::Client.parse <<-'GRAPHQL'
    mutation ($input: CreateCommentInput!) {
      createComment(input: $input) {
        comment {
          id,
          path
        }
      }
    }
  GRAPHQL
  
  def create_comment(commentable_id, content, author_id)
    query(
      Mutation,
      variables: {
        input: {
          commentableId: commentable_id,
          content: content,
          authorId: author_id
        }
      }
    )
  end
end
