OmniAuth LTI
============

The OmniAuth LTI gem provides a way for applications to authenticate users using LTI 1.1 specification. 

It relies on [ims-lti gem][] for validating LTI data.

Usage
=====

Add the provider to your OmniAuth stack, giving the tool_consumer credentials:

	provider :lti, :oauth_credentials => {:test => 'secret'}

Include Omniauth::Lti::Context in your application_controller:

	include Omniauth::Lti::Context

When you create the session in your sessions\_controller, call to save_lti_context for saving LTI context through all the application

For accessing the context anywhere in your application, just call the helper method lti\_tool\_provider:

	=lti_tool_provider.resource_link_title

You can find an example web application in [omniauth-lti-example-webapp][]

TODO
=====

Add support for outcomes

[ims-lti gem]: https://github.com/instructure/ims-lti
[omniauth-lti-example-webapp]: https://github.com/xaviaracil/omniauth-lti-example