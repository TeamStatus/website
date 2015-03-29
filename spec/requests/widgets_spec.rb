require 'rails_helper'

describe 'Integrations', :type => :request do
  %w{static-html jira-issue-list jira-simple-counter static-html bamboo-builds crucible-reviews postgresql-list postgresql-number}.each do |widget|
    describe "GET #{widget}\'s HTML" do
      it 'works!' do
        get "/integrations/#{widget}/html"
        expect(response.status).to be(200)
        expect(response.body).to include('class="content')
      end
    end
  end

  %w{clock}.each do |widget|
    describe "GET #{widget}\'s HTML" do
      it 'works!' do
        get "/integrations/#{widget}/html"
        expect(response.status).to be(200)
        expect(response.body).to include('class=\'content')
      end
    end
  end

  %w{stfu}.each do |widget|
    describe "GET #{widget}\'s HTML" do
      it 'works!' do
        get "/integrations/#{widget}/html"
        expect(response.status).to be(200)
        expect(response.body).to include("class=\"#{widget}")
      end
    end
  end
end