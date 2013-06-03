module Omniauth
  module Lti
    module Context      
      
      def self.included(receiver)
        receiver.class_eval do
          # add lti_tool_provider as a helper method to received object
          helper_method :lti_tool_provider
          attr_reader :lti_credentials

          def lti_credentials=(credentials) 
            if credentials && credentials.is_a?(Hash)
              @lti_credentials = credentials.keys.inject({}) {|h,k| h[k.to_s] = credentials[k] ; h }
            end
          end
        end
      end      
      
      def save_lti_context
        session[LTI_LAUNCH_PARAMS_SESSION_NAME] = request.env['lti.launch_params']
      end
      
      private 
      
      LTI_LAUNCH_PARAMS_SESSION_NAME = 'lti_launch_params'

      def lti_launch_params
        session[LTI_LAUNCH_PARAMS_SESSION_NAME]
      end

      def lti_tool_provider        
        return nil unless lti_launch_params
        key = lti_launch_params['oauth_consumer_key']
        secret = self.lti_credentials[key] if self.lti_credentials
        @tp ||= IMS::LTI::ToolProvider.new(key, 
                                           secret, 
                                           lti_launch_params)
      end
            
    end
  end
end