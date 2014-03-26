class Team < ActiveRecord::Base
	has_many :users, :inverse_of => :team, :dependent => :destroy
	has_many :notes, :inverse_of => :team, :dependent => :destroy

  accepts_nested_attributes_for :users
end
