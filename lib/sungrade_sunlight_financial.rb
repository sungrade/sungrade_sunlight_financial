require "sungrade_sunlight_financial/version"
require "sungrade_sunlight_financial/errors"
require "sungrade_sunlight_financial/configuration"
require "sungrade_sunlight_financial/settings"
require "sungrade_sunlight_financial/request"
require "sungrade_sunlight_financial/project"
require 'json'
require "base64"

module SungradeSunlightFinancial
  class << self
    def access_token(settings: new_settings)
      requester = SungradeSunlightFinancial::Request.new(
        settings: settings,
        requires_access_token: false
      )
      response = requester.post do |req|
        req.url("/ws/rest/v1/pt/gettoken/accesstoken")
        req.body = {
          username: settings.salesforce_username,
          password: settings.salesforce_password
        }.to_json
      end
      raise UnsuccessfulRequest.new(response: response) unless response.success?
      JSON.parse(response.body).fetch("access_token") { nil }
    end

    def calculate(settings: new_settings, term:, apr:, loan_amount:)
      requester = SungradeSunlightFinancial::Request.new(
        settings: settings,
        requires_access_token: false
      )
      response = requester.post do |req|
        req.url("ws/rest/v2/pt/slf/calculator")
        req.body = {
          term: term,
          apr: apr,
          loanAmount: loan_amount
        }.to_json
      end
      raise UnsuccessfulRequest.new(response: response) unless response.success?
      response
    end

    def new_settings
      SungradeSunlightFinancial::Settings.new
    end

    def configure
      yield(Configuration.instance)
    end
  end
end
