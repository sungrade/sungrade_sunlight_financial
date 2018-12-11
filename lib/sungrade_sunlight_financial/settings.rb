module SungradeSunlightFinancial
  class Settings
    attr_writer *Configuration::FIELDS
    attr_writer :access_token

    def initialize(opts = {})
      opts.each do |meth, val|
        if respond_to?("#{meth}=")
          self.send("#{meth}=", val)
        end
      end
    end

    def base_url
      with_required(__method__) do
        @base_url || Configuration.instance.base_url
      end
    end

    def boomi_api_token
      with_required(__method__) do
        @boomi_api_token || Configuration.instance.boomi_api_token
      end
    end

    def boomi_username
      with_required(__method__) do
        @boomi_username || Configuration.instance.boomi_username
      end
    end

    def salesforce_username
      with_required(__method__) do
        @salesforce_username || Configuration.instance.salesforce_username
      end
    end

    def salesforce_password
      with_required(__method__) do
        @salesforce_password || Configuration.instance.salesforce_password
      end
    end

    def salesforce_email
      with_required(__method__) do
        @salesforce_email || Configuration.instance.salesforce_email
      end
    end

    def show_connection_logs
      @show_connection_logs || Configuration.instance.show_connection_logs
    end

    def access_token
      raise NoAccessTokenSet.new("an access token is required for this request") unless @access_token
      @access_token
    end

    private

    def with_required(attribute)
      result = yield
      return result if result
      raise RequiredSettingMissing.new("#{attribute} is a required attribute needed for this request")
    end
  end
end
