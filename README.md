OmniAuth LTI
============

The OmniAuth LTI gem provides a way for applications to authenticate users using LTI 1.1 specification. 

It relies on [ims-lti gem][] for validating LTI data.

Installation
============

Add the gem in your Gemfile:
	
	gem 'omniauth-lti'
	
And install it using bundle

	bundle install

Usage
=====

Add the provider to your OmniAuth stack, giving the tool_consumer credentials:

	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :lti, :oauth_credentials => {:test => 'secret'}
	end

Include `Omniauth::Lti::Context` in your `application_controller`:

	class ApplicationController < ActionController::Base
  	  ...
	  include Omniauth::Lti::Context
  	  ...
	end

When you create the session in your `sessions\_controller`, call to `save_lti_context` for saving LTI context through all the application

For accessing the context anywhere in your application, just call the helper method `lti_tool_provider`. 
For instance, to show the title of the resource that call your application just put in your haml view:

	=lti_tool_provider.resource_link_title

You can find an example web application in [omniauth-lti-example-webapp][]

Outcomes
========

`lti_tool_provider` gives you the full `IMS::LTI::ToolProvider` class. Please refer to (https://github.com/instructure/ims-lti#returning-results-of-a-quizassignment) to see how to do outcomes with this class

[ims-lti gem]: https://github.com/instructure/ims-lti
[omniauth-lti-example-webapp]: https://github.com/xaviaracil/omniauth-lti-example