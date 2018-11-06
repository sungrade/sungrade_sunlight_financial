module SungradeSunlightFinancial
  class Configuration
    FIELDS = [
      :base_url,
      :boomi_username,
      :boomi_api_token,
      :salesforce_username,
      :salesforce_password,
      :salesforce_email,
      :show_connection_logs
    ]
    attr_accessor *FIELDS
    class << self
      def instance
        @instance ||= new
      end

      def evaluate(blk)
        instance.instance_eval(&blk)
      end
    end

  end
end
