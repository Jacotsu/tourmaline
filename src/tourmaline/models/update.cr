module Tourmaline
  # # This object represents a Telegram user or bot.
  class Update
    include JSON::Serializable
    include Tourmaline::Model

    # The update‘s unique identifier. Update identifiers start from a certain
    # positive number and increase sequentially. This ID becomes especially
    # handy if you’re using Webhooks, since it allows you to ignore
    # repeated updates or to restore the correct update sequence,
    # should they get out of order. If there are no new updates
    # for at least a week, then identifier of the next update
    # will be chosen randomly instead of sequentially.
    getter update_id : Int64

    # Optional. New incoming message of any kind — text, photo, sticker, etc.
    getter message : Message?

    # Optional. New version of a message that is known to the bot and was edited
    getter edited_message : Message?

    # Optional. New incoming channel post of any kind — text, photo, sticker, etc.
    getter channel_post : Message?

    # Optional. New version of a channel post that is known to the bot and was edited
    getter edited_channel_post : Message?

    # Optional. New incoming inline query
    getter inline_query : InlineQuery?

    # Optional. The result of an inline query that was chosen by a user and sent to
    # their chat partner. Please see our documentation on the feedback collecting
    # for details on how to enable these updates for your bot.
    getter chosen_inline_result : ChosenInlineResult?

    # Optional. New incoming callback query
    getter callback_query : CallbackQuery?

    # Optional. New incoming shipping query. Only for invoices with flexible price
    getter shipping_query : ShippingQuery?

    # Optional. New incoming pre-checkout query. Contains full information about checkout
    getter pre_checkout_query : PreCheckoutQuery?

    # Optional. New poll state. Bots receive only updates about stopped polls and polls,
    # which are sent by the bot
    getter poll : Poll?

    # Optional. A user changed their answer in a non-anonymous poll. Bots receive new
    # votes only in polls that were sent by the bot itself.
    getter poll_answer : PollAnswer?

    # Context object allowing data to be passed from middleware to handlers.
    @[JSON::Field(ignore: true)]
    getter context : Middleware::Context { Middleware::Context.new }

    # Returns all users included in this update as a Set
    def users
      users = [] of User?

      [self.channel_post, self.edited_channel_post, self.edited_message, self.message].compact.each do |message|
        if message
          users.concat(message.users)
        end
      end

      if query = self.callback_query
        users << query.from
        if message = query.message
          users.concat(message.users)
        end
      end

      [self.chosen_inline_result, self.shipping_query, self.inline_query, self.pre_checkout_query].compact.each do |e|
        users << e.from if e.from
      end

      [self.poll_answer].compact.each do |e|
        users << e.user if e.user
      end

      users.compact.uniq!
    end

    # Yields each unique user in this update to the block.
    def users(&block : User ->)
      self.users.each { |u| block.call(u) }
    end

    # Returns all unique chats included in this update
    def chats
      chats = [] of Chat
      [self.channel_post, self.edited_channel_post, self.edited_message, self.message].compact.each do |message|
        if message
          chats.concat(message.chats)
        end
      end
      chats
    end

    # Yields each unique chat in this update to the block.
    def chats(&block : Chat ->)
      self.chats.each { |c| block.call(c) }
    end
  end
end
