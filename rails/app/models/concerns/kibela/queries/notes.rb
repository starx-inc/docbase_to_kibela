module Kibela::Queries::Notes
  extend ActiveSupport::Concern
  
  Query = Kibela::Client::Client.parse <<-'GRAPHQL'
    query($after: String, $before: String, $first: Int, $last: Int, $orderBy: NoteOrder, $folderId: ID, $active: Boolean) {
      notes(
        after: $after
        before: $before
        first: $first
        last: $last
        orderBy: $orderBy
        folderId: $folderId
        active: $active
      ) {
        nodes {
          title
          url
        },
        totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }  
  GRAPHQL
  
  def get_notes(after=nil, per=1000)
    query(
      Query,
      variables: {
        first: per,
        last: per,
        after: after,
        active: true
      }
    )
  end
end
