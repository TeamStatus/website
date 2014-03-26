class DueJobsQuery
  def initialize(relation = Job.all)
    @relation = relation
  end

  def find_each(&block)
    @relation
    	.where('next_run_at <= NOW() OR next_run_at IS NULL')
    	.find_each(&block)
  end
end