require 'spec_helper'

describe "Integrations" do
	%w{bamboo-builds jira-issue-list}.each do |widget|
	  describe "GET /partials/integrations/#{widget}" do
	    it "works! (now write some real specs)" do
	      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
	      get "/partials/integrations/#{widget}"
	      response.status.should be(200)
	    end
	  end
	end
end
