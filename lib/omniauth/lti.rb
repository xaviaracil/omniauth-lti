require 'omniauth'
require 'ims/lti'
require 'oauth/request_proxy/rack_request'

module OmniAuth
  module Strategies
    autoload :Lti, 'omniauth/strategies/lti'
  end
end