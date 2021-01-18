module Tourmaline::Models
  class Chat
    enum Type
      Supergroup
      Private
      Group
      Channel
    end

    def name
      if first_name || last_name
        [first_name, last_name].compact.join(" ")
      else
        title.to_s
      end
    end

    def supergroup?
      type.supergroup?
    end

    def private?
      type.private?
    end

    def group?
      type.group?
    end

    def channel?
      type.channel?
    end

    def invite_link
      client.export_chat_invite_link(id)
    end

    def member_count
      client.get_chat_members_count(id)
    end

    def send_message(*args, **kwargs)
      client.send_message(id, *args, **kwargs)
    end

    def send_audio(audio, **kwargs)
      client.send_audio(id, audio, **kwargs)
    end

    def send_animation(animation, **kwargs)
      client.send_animation(id, animation, **kwargs)
    end

    def send_contact(phone_number, first_name, **kwargs)
      client.send_contact(id, phone_number, first_name, **kwargs)
    end

    def send_document(document, **kwargs)
      client.send_document(id, document, **kwargs)
    end

    def send_game(game_name, **kwargs)
      client.send_game(id, game_name, **kwargs)
    end

    def send_invoice(invoice, **kwargs)
      client.send_invoice(id, invoice, **kwargs)
    end

    def send_location(latitude, longitude, **kwargs)
      client.send_location(id, latitude, longitude, **kwargs)
    end

    def send_photo(photo, **kwargs)
      client.send_photo(id, photo, **kwargs)
    end

    def send_media_group(media, **kwargs)
      client.send_media_group(id, media, **kwargs)
    end

    def send_sticker(sticker, **kwargs)
      client.send_sticker(id, sticker, **kwargs)
    end

    def send_venue(latitude, longitude, title, address, **kwargs)
      client.send_venu(id, latitude, longitude, title, address, **kwargs)
    end

    def send_video(video, **kwargs)
      client.send_video(id, video, **kwargs)
    end

    def send_video_note(video_note, **kwargs)
      client.send_video(id, video_note, **kwargs)
    end

    def send_voice(voice, **kwargs)
      client.send_voice(id, voice, **kwargs)
    end

    def edit_live_location(latitude, longitude, **kwargs)
      client.edit_message_live_location(id, latitude, longitude, **kwargs)
    end

    def stop_live_location(**kwargs)
      client.stop_message_live_location(id, message_id, **kwargs)
    end

    def delete_chat_sticker_set
      client.delete_chat_sticker_set(id)
    end

    def send_chat_action(action : ChatAction)
      client.send_chat_action(id, action)
    end

    def unpin_message
      client.unpin_chat_message(id)
    end

    def set_photo(photo)
      client.set_chat_photo(id, photo)
      chat = get_chat
      @chat_photo = chat.chat_photo
    end

    def delete_photo
      client.delete_chat_photo(id)
    end

    def set_title(title)
      client.set_chat_title(id, title)
      @title = title
    end

    def set_description(description)
      client.set_chat_description(id, description)
      @description = description
    end

    def set_sticker_set(set_name)
      client.set_chat_sticker_set(id, set_name)
      @sticker_set_name = set_name
    end

    def set_administrator_custom_title(user, custom_title)
      client.set_chat_admininstrator_custom_title(id, user, custom_title)
    end

    def set_permissions(permissions)
      client.set_chat_permissions(id, permissions)
      @permissions = permissions.is_a?(ChatPermissions) ? permissions : ChatPermissions.new(permissions)
    end
  end
end
