class Kibela::ApiError
  def initialize(errors)
    @waitMilliseconds = nil
    @codes = errors.map do |error|
      # リクエスト制限エラーの場合、待機時間を取得
      waitMilliseconds = error.try(&:waitMilliseconds)
      if @waitMilliseconds.nil? || @waitMilliseconds < waitMilliseconds
        @waitMilliseconds = waitMilliseconds
      end
      error.extensions.code
    end
  end

  def only_rate_limit?
    @codes.all? {|code| %w(TOKEN_BUDGET_EXHAUSTED)}
  end
end