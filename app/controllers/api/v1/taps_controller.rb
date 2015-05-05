module Api
  module V1
    class TapsController < ApiController

      def data
      end
      
      private

      def tap_params
      	params.require(:tap).permit(:data)
      end
      
    end
  end
end
