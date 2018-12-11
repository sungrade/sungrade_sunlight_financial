module SungradeSunlightFinancial
  class Project
    class << self
      def create(settings:, body:)
        requester = SungradeSunlightFinancial::Request.new(settings: settings)
        response = requester.post do |req|
          req.url("/ws/rest/v1/pt/applicant/create/")
          req.body = body.is_a?(String) ? body : body.to_json
        end
        raise UnsuccessfulRequest.new(response: response) unless response.success?
        response
      end

      def update(settings:, body:)
        requester = SungradeSunlightFinancial::Request.new(settings: settings)
        response = requester.post do |req|
          req.url("/ws/rest/v1/pt/object/applicant")
          req.body = body.is_a?(String) ? body : body.to_json
        end
        raise UnsuccessfulRequest.new(response: response) unless response.success?
        response
      end
    end
  end
end
