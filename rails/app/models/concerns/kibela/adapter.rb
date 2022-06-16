class Kibela::Adapter
  include Kibela::Queries::Users
  include Kibela::Queries::Groups

  include Kibela::Mutations::CreateDummyUser
  include Kibela::Mutations::CreateAttachment

  def initialize(wait=true, retry_count=3)
    @wait = wait
    @retry_count = retry_count
  end

  def query(query, variables={variables: {}})
    response = Kibela::Client::Client.query query, variables: variables[:variables]
    pp response
    if response.errors.present?
      api_error = Kibela::ApiError.new response.errors
      pp "raise error"
      raise api_error
    end
    response
  end
end