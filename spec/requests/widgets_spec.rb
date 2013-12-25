require 'spec_helper'


module OptionsRunner
	module OptionsRequests

		def options(path, parameters = nil, headers = nil)
			process :options, path, parameters, headers
		end

		# Performs a OPTIONS request, following any subsequent redirect.
		# See +request_via_redirect+ for more information.
		def options_via_redirect(path, parameters = nil, headers = nil)
			request_via_redirect(:options, path, parameters, headers)
		end

	end

	def reset!
	  @integration_session = ActionDispatch::Integration::Session.new(app)
	  @integration_session.extend(OptionsRequests)
	end

	%w(options options_via_redirect).each do |method|
	  define_method(method) do |*args|
	    reset! unless integration_session
	    # reset the html_document variable, but only for new get/post calls
	    @html_document = nil unless method == 'cookies' || method == 'assigns'
	    integration_session.__send__(method, *args).tap do
	      copy_session_variables!
	    end
	  end
	end
end

shared_examples_for "any CORS request" do
  it "should set the Access-Control-Allow-Origin header to allow CORS from boards" do
    response.headers['Access-Control-Allow-Origin'].should == ENV['BOARDS_URL']
  end

  it "should allow general HTTP methods thru CORS (GET/POST/PUT/DELETE)" do
    allowed_http_methods = response.header['Access-Control-Allow-Methods']
    %w{GET POST PUT DELETE}.each do |method|
      allowed_http_methods.should include(method)
    end
  end

  it "should be succesful" do
    response.should be_success
  end
end

describe "HTTP OPTIONS /boards/52b81c6f736572492b000000/widgets/52b9293a7365725e47010000.json" do
  # With Rails 4 (currently in master) we'll be able to `options :index`
  before(:each) {
  	self.extend(OptionsRunner)
  	self.reset!
  	options "/boards/52b81c6f736572492b000000/widgets/52b9293a7365725e47010000.json"
  }

  it_should_behave_like "any CORS request"
end
