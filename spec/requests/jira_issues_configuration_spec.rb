require 'spec_helper'

describe 'JIRA Issues Counter Configuration' do
	let (:user) { create(:user) }
	let (:board) { create(:board, :user_id => user._id) }

  it 'shows JIRA server configutaion', :js => true do
    visit new_board_job_path(board._id, :anchor => '/jira-issue-list')
    page.should have_content('JIRA address')
  end
end