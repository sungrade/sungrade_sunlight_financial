require 'faraday'
require "faraday_curl"
require "typhoeus"

module SungradeSunlightFinancial
  class Request
    attr_reader :settings, :requires_access_token

    def initialize(settings:, requires_access_token: true)
      @settings = settings
      @requires_access_token = requires_access_token
    end

    %w[get head delete post put patch].each do |meth|
      define_method(meth) do |url: nil, body: {}, headers: {}, &blk|
        run_request(verb: meth, url: url, body: body, headers: headers, &blk)
      end
    end

    def run_request(verb:, url:, body:, headers:)
      connection.send(verb, url, body, headers) do |req|
        req.headers.merge!({
          "Authorization" => "Basic #{basic_auth_token}",
          "Content-Type" => "application/json"
        })
        if requires_access_token
          req.headers.merge!({
            "SFAccessToken" => "Bearer #{settings.access_token}"
          })
        end
        yield(req) if block_given?
      end
    end

    def basic_auth_token
      Base64.strict_encode64("#{settings.boomi_username}:#{settings.boomi_api_token}")
    end

    def connection
      @connection ||= Faraday.new(url: settings.base_url) do |faraday|
        faraday.request :url_encoded
        faraday.request :curl, Rails.logger, :warn
        faraday.use(Faraday::Response::Logger) if settings.show_connection_logs
        faraday.adapter(:typhoeus)
      end
    end
  end
end
