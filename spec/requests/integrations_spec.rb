require 'spec_helper'

describe "Integrations" do
	%w{bamboo-builds jira-issue-list}.each do |widget|
	  describe "GET /integrations/#{widget}/config" do
	    it "works!" do
	      get "/integrations/#{widget}/config"
	      response.status.should be(200)
	    end
	  end
	end
end
