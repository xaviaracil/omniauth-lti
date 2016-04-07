module OmniAuth
  module Strategies
    class Lti
      include OmniAuth::Strategy

      # Hash for storing your Consumer Tools credentials, whether:
      # - the key is the consumer_key
      # - the value is the comsumer_secret
      option :oauth_credentials, {}

      # Default username for users when LTI context doesn't provide a name
      option :default_user_name, 'User'

      # Allow all request methods by default
      option :only_accept_posts, false

      def callback_phase
        # prevent invalid request types
        return bad_request! unless request_method_allowed?
        # validate request
        return fail!(:invalid_credentials) unless valid_lti?
        #save the launch parameters for use in later request
        env['lti.launch_params'] = @tp.to_params
        super
      # rescue more generic OAuth errors and scenarios
      rescue ::Timeout::Error
        fail!(:timeout)
      rescue ::Net::HTTPFatalError, ::OpenSSL::SSL::SSLError
        fail!(:service_unavailable)
      rescue ::OAuth::Unauthorized
        fail!(:invalid_credentials)
      rescue ::OmniAuth::NoSessionError
        fail!(:session_expired)
      end

      # define the UID
      uid { @tp.user_id }

      # define the hash of info about user
      info do
        {
          :name => @tp.username(options.default_user_name),
          :email => @tp.lis_person_contact_email_primary,
          :first_name => @tp.lis_person_name_given,
          :last_name => @tp.lis_person_name_family,
          :image => @tp.user_image
        }
      end

      # define the hash of credentials
      credentials do
        {
          :token => @tp.consumer_key,
          :secret => @tp.consumer_secret
        }
      end

      #define extra hash
      extra do
        { :raw_info => @tp.to_params }
      end

      private

      def request_method_allowed?
        !options.only_accept_posts || request.request_method == 'POST'
      end

      def bad_request!
        [400, {}, ['400 Bad Request']]
      end

      def valid_lti?
        key = request.params['oauth_consumer_key']
        log :info, "Checking LTI params for key #{key}: #{request.params}"
        @tp = IMS::LTI::ToolProvider.new(key, options.oauth_credentials[key], request.params)
        @tp.valid_request?(request).tap do |valid|
          log :info, "Valid request? #{valid}"
        end
      end
    end
  end
end
