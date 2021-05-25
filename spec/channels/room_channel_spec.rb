require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  it "successfully subscribes" do
    subscribe ({channel: "RoomChannel", user_id: 1})
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("room_channel_1")
  end
end
