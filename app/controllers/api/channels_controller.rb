class Api::ChannelsController < ApplicationController
  before_action :set_channel, only: [:show]

  # GET /channels
  # GET /channels.json



  # GET /channels/1
  # GET /channels/1.json
  def show
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def tweet_params
    #   params.require(:tweet).permit(:keyword, :unique_id, :full_json, :channel_id)
    # end
end
