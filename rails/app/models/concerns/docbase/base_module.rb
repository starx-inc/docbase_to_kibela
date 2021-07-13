module Docbase::BaseModule
  extend ActiveSupport::Concern
  require "net/http"

  TEAM_DOMAIN = 'starx'
  ACCESS_TOKEN = ENV['DOCBASE_TOKEN']
  BASE_URL   = "https://api.docbase.io/teams/#{TEAM_DOMAIN}"
  POSTS_PATH = "posts"
  REQUEST_HEADER = {'X-DocBaseToken' => ACCESS_TOKEN, 'Content-Type' => 'application/json'}
  PER_PAGE = 100

  

  module ClassMethods
    @@rate_limit_remaining = 300
    @@rate_limit_reset = Time.current

    def suppression(request_path, raise_exception=true)
      current_time = Time.current
      if @@rate_limit_remaining.zero? && current_time < @@rate_limit_reset
        puts "API call limit reached, request suppressed"
        puts "#{@@rate_limit_remaining} more...until reset #{@@rate_limit_reset}"
        if raise_exception
          raise RateLimitException.new(@@rate_limit_reset, request_path)
        else
          sleep(@@rate_limit_reset - current_time)
        end
      end
    end

    def get_file(file_name, force=false)
      pp "get_file #{file_name}"
      request_path = BASE_URL + "/attachments/#{file_name}"
      file_path = File.join(Rails.root.to_s, "attachments", file_name)

      # 既に存在しておりforce!=trueの場合はダウンロードしない
      return file_path if File.exist?(file_path) && !force

      FileUtils.mkdir_p(File.dirname(file_path))

      suppression(nil)
      request_uri = URI.parse(request_path)
      http = Net::HTTP.new(request_uri.host, request_uri.port)
      http.use_ssl = request_uri.scheme == 'https'
      request = Net::HTTP::Get.new(request_uri.request_uri)
      REQUEST_HEADER.each { |key, value| request.add_field(key, value) }
    
      response = http.request(request)
      @@rate_limit_remaining = response['X-RateLimit-Remaining'].to_i
      @@rate_limit_reset = Time.zone.at(response['X-RateLimit-Reset'].to_i)
      puts "requested:#{request_path} saved:#{file_path} #{@@rate_limit_remaining} more...until reset #{@@rate_limit_reset}"

      open(file_path, 'wb'){|f|
        f.write(response.body)
      }
    end

    def get(request_path)
      suppression(request_path)
      request_uri = URI.parse(request_path)
      http = Net::HTTP.new(request_uri.host, request_uri.port)
      http.use_ssl = request_uri.scheme == 'https'
    
      request = Net::HTTP::Get.new(request_uri.request_uri)
      REQUEST_HEADER.each { |key, value| request.add_field(key, value) }
    
      response = http.request(request)
      parsed_response = JSON.parse(response.body, symbolize_names: true)
      response_body = if parsed_response.kind_of? Hash
        ActiveSupport::HashWithIndifferentAccess.new(parsed_response)
      else
        key = request_uri.path.slice(/[^\/]*\z/).to_sym
        ActiveSupport::HashWithIndifferentAccess.new({
          key => parsed_response
        })
      end

      @@rate_limit_remaining = response['X-RateLimit-Remaining'].to_i
      @@rate_limit_reset = Time.zone.at(response['X-RateLimit-Reset'].to_i)
      puts "requested #{request_path} #{@@rate_limit_remaining} more...until reset #{@@rate_limit_reset}"

      message = if response.code == '200'
                  nil
                elsif response.code == '429'
                  raise RateLimitException.new(@@rate_limit_reset, request_path)
                else
                  response_body[:messages].join("\n")
                end
      {
        code: response.code,
        message: message,
        total: response_body.dig(:meta, :total),
        current_page: request_path,
        previous_page: response_body.dig(:meta, :previous_page),
        next_page: response_body.dig(:meta, :next_page),
        body: response_body,
        rate_limit: response['X-RateLimit-Limit'],
        rate_limit_remaining: response['X-RateLimit-Remaining'],
        rate_limit_reset_at: Time.zone.at(response['X-RateLimit-Reset'].to_i)
      }
    end


    def posts(from_updated_at: nil, to_updated_at: nil, tag: nil, title: nil, group: nil, next_path: nil)
      # next_pathを渡された場合はパラメータを無視してnext_pathを取得
      return self.get(next_path) if next_path
      base_path = "/posts?"
      queries = []
      if from_updated_at && to_updated_at
        queries << "changed_at:#{from_updated_at.to_date.to_s}~#{to_updated_at.to_date.to_s}"
      elsif from_updated_at
        queries << "changed_at:#{from_updated_at.to_date.to_s}~*"
      elsif to_updated_at
        queries << "changed_at:*~#{to_updated_at.to_date.to_s}"
      end
      if tag
        queries << "tag:#{tag}"
      end
      if title
        queries << "title:#{title}"
      end
      if group
        queries << "group:#{group}"
      end
      queries << "asc:changed_at"
      q = URI.encode_www_form(q: queries.join(' '))
      q << "&per_page=100"
      base_path << q
      self.get(BASE_URL + base_path)
    end

    def users(from_updated_at: nil, to_updated_at: nil, tag: nil, title: nil, group: nil, next_path: nil)
      # next_pathを渡された場合はパラメータを無視してnext_pathを取得
      return self.get(next_path) if next_path
      base_path = "/users?"
      queries = []
      q = URI.encode_www_form(q: queries.join(' '))
      q << "&per_page=100"
      base_path << q
      pp BASE_URL + base_path
      self.get(BASE_URL + base_path)
    end
  end
end