import consumer from "./consumer"

$(document).ready(function(){
  const user_id = $("#user_id").html();

  consumer.subscriptions.create({channel: "RoomChannel", user_id: user_id}, {
    connected() {
      console.log("Connected to channel!");
    },

    disconnected() {
    },

    received(data) {
      if(data.content.topic === 'price') {
        data.content.body.forEach((item)=>{
          if (item.price) {
            $('.minmax_'+item.id).html(item.min_max);
            $('.price_'+item.id).html(item.price + " " + item.currency );
          } else {
            $('.price_'+item.id).html('');
          }
        });
      }
    }
  });

});