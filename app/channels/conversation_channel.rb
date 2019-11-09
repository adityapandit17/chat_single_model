class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations-#{current_user.id}"
    current_user.update_attributes(is_online: true)
  end

  def unsubscribed
    stop_all_streams
    current_user.update_attributes(is_online: false)
  end

  def speak(data)
    message_params = data['message'].each_with_object({}) do |el, hash|
      hash[el.values.first] = el.values.last
    end

    Message.create(message_params)
  end
end
