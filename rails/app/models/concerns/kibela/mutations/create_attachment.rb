module Kibela::Mutations::CreateAttachment
  extend ActiveSupport::Concern
  
  Mutation = Kibela::Client::Client.parse <<-'GRAPHQL'
    mutation ($input: UploadAttachmentWithDataUrlInput!) {
      uploadAttachmentWithDataUrl(input: $input) {
        clientMutationId,
        attachment {
          path
        }
      }
    }
  GRAPHQL
  
  def craete_attachment(name, data_url)
    query(
      Mutation,
      variables: {
        input: {
          name: name,
          dataUrl: data_url,
          kind: "GENERAL"
        }
      }
    )
  end
end