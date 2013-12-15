class WidgetsController < ApplicationController

	before_action :set_board

	def index
		@widgets = @board.widgets
	end

	def new
	end

	def create
		@widget = @board.widgets.new(widget_params)
		logger.debug "New widget: #{@widget.attributes.inspect}"
		logger.debug "Widget should be valid: #{@widget.valid?}"

		respond_to do |format|
			if @widget.save
				format.html { redirect_to [@board, @widget], notice: 'Widget was successfully created.' }
				format.json { render action: 'show', status: :created, location: board_widget_path(@board, @widget) }
			else
				format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	private
		def set_board
		  @board = ::Board.find(params[:board_id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def widget_params
		  params.slice(:widget, :settings, :widgetSettings).permit!
		end

end