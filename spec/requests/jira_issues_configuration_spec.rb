require 'spec_helper'

describe 'JIRA Issues Counter Configuration' do
	let (:board) { create(:board) }

  it 'shows JIRA server configutaion', :js => true do
    visit new_board_job_path(board._id, :anchor => '/jira-issue-list')
    page.should have_content('JIRA Server')
  end
end