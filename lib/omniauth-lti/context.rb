module Omniauth
  module Lti
    module Context

      def self.included(receiver)
        # add lti_tool_provider as a helper method to received object
        receiver.class_eval do
          helper_method :lti_tool_provider
        end
      end
      
      def lti_tool_provider
        return nil unless session['lti_launch_params']
        @tp ||= IMS::LTI::ToolProvider.new(session['lti_launch_params']['oauth_consumer_key'], 
                                           nil, 
                                           session['lti_launch_params'])
      end
      
      def save_lti_context
        session['lti_launch_params'] = request.env['lti.launch_params']
      end
    end
  end
end