class BoardsController < ApplicationController

	before_action :set_board, only: [:show, :edit, :update, :destroy, :reset_public_id]

	def index
		@boards = current_user.boards
		unless @boards.exists?
			board = current_user.boards.build({ :name => "First board!" })
			board.jobs.build({:jobId => 'static-html', :widgetSettings => { :title => "Welcome!",
				:html => '<p>This is your first board!</p>
<p>Use menu on top  to add widgets!</p>
<p>If you need any help please <a href="mailto:pawel@teamstatus.tv">contact me</a></p>
<p>Sincerely, Pawel Niewiadomski, CEO</p>' }})
			board.save
			redirect_to public_board_url(board) + '#edit'
		end
	end

	def show
	end

	def new
	end

	def edit
	end

	def reset_public_id
		@board.reset_public_id
		@board.save
		render :show
	end

	def create
		@board = current_user.boards.new(board_params)
		logger.debug "New board: #{@board.attributes.inspect}"
		logger.debug "Board should be valid: #{@board.valid?}"

		respond_to do |format|
			if @board.save
				format.html { redirect_to [@board], notice: 'Board was successfully created.' }
				format.json { render action: 'show', status: :created, location: board_path(@board) }
			else
				format.html { render action: 'new' }
				format.json { render json: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @board.update_attributes(board_params)
				format.html { redirect_to [@board], notice: 'Board was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @job.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@board.destroy
		respond_to do |format|
			format.html { redirect_to boards_url(@board) }
			format.json { head :no_content }
		end
	end

	private

	def set_board
		@board = current_user.boards.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def board_params
		params.slice(:name).permit!
	end
end
