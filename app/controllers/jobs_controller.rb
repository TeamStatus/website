class JobsController < ApplicationController

	before_action :set_board
	before_action :set_job, only: [:update, :destroy, :duplicate]

	def index
		@jobs = @board.jobs
	end

	def new
	end

	def edit
	end

	def destroy
		@job.destroy
		respond_to do |format|
			format.html { redirect_to board_jobs_url(@board) }
			format.json { head :no_content }
		end
	end

	def update
		respond_to do |format|
			if @job.update_attributes(job_update_params)
				format.html { redirect_to [@board, @job], notice: 'Job was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @job.errors, status: :unprocessable_entity }
			end
		end
	end

	def duplicate
		respond_to do |format|
			if @board.jobs.push(@job.clone)
				format.html { redirect_to [@board, @job], notice: 'Job was successfully created.' }
				format.json { render action: 'show', status: :created, location: board_job_path(@board, @job) }
			else
				format.html { render action: 'new' }
				format.json { render json: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	def create
		@job = @board.jobs.new(job_params)
		logger.debug "New job: #{@job.attributes.inspect}"
		logger.debug "Job should be valid: #{@job.valid?}"

		respond_to do |format|
			if @job.save
				format.html { redirect_to [@board, @job], notice: 'Job was successfully created.' }
				format.json { render action: 'show', status: :created, location: board_job_path(@board, @job) }
			else
				format.html { render action: 'new' }
				format.json { render json: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	private
	def set_board
		@board = @user.boards.find(params[:board_id])
	end

	def set_job
		@job = @board.jobs.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def job_params
		params.slice(:jobId, :settings, :widgetSettings).permit!
	end

	def job_update_params
		params.slice(:settings, :widgetSettings).permit!
	end
end