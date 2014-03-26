class DueJobsQuery
  def initialize(relation = Job.all)
    @relation = relation
  end

  def find_each(&block)
    @relation
    	.where('next_run_at <= NOW() AND next_run_at IS NOT NULL')
    	.find_each(&block)
  end
end