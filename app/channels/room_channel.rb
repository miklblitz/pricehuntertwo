class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:user_id]}"
    reject unless params[:user_id].present?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
