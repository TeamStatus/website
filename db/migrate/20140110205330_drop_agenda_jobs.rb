class DropAgendaJobs < Mongoid::Migration
  def self.up
  	Mongoid.default_session[:agendaJobs].drop
  end

  def self.down
  end
end