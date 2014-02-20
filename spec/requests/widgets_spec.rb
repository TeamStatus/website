require 'spec_helper'

describe 'Integrations' do
  %w{static-html jira-issue-list jira-simple-counter static-html bamboo-builds crucible-reviews postgresql-list postgresql-number}.each do |widget|
    describe "GET #{widget}\'s HTML" do
      it 'works!' do
        get "/integrations/#{widget}/html"
        response.status.should be(200)
        response.body.should include('class="content')
      end
    end
  end

  %w{clock}.each do |widget|
    describe "GET #{widget}\'s HTML" do
      it 'works!' do
        get "/integrations/#{widget}/html"
        response.status.should be(200)
        response.body.should include('class=\'content')
      end
    end
  end

  %w{stfu}.each do |widget|
    describe "GET #{widget}\'s HTML" do
      it 'works!' do
        get "/integrations/#{widget}/html"
        response.status.should be(200)
        response.body.should include("class=\"#{widget}")
      end
    end
  end
end