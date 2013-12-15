class WidgetsController < ApplicationController

	before_action :set_board
	before_action :set_widget, only: [:update, :destroy]

	def index
		@widgets = @board.widgets
	end

	def new
	end

	def edit
	end

	def destroy
		@widget.destroy
		respond_to do |format|
			format.html { redirect_to board_widgets_url(@board) }
			format.json { head :no_content }
		end
	end

	def update
   respond_to do |format|
     if @widget.update_attributes(widget_update_params)
       format.html { redirect_to [@board, @widget], notice: 'Widget was successfully updated.' }
       format.json { head :no_content }
     else
       format.html { render action: 'edit' }
       format.json { render json: @widget.errors, status: :unprocessable_entity }
     end
   end
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

		def set_widget
			@widget = @board.widgets.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def widget_params
			params.slice(:widget, :settings, :widgetSettings).permit!
		end

		def widget_update_params
			params.slice(:settings, :widgetSettings).permit!
		end
end