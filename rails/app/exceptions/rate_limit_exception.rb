class RateLimitException < StandardError
  attr_accessor :rate_limit_reset_time, :next_path
  def initialize(rate_limit_reset_time, next_path)
    self.rate_limit_reset_time = rate_limit_reset_time
    self.next_path = next_path
  end
end