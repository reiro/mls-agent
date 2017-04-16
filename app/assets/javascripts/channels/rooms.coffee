jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0
    messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

    sleep = (ms) ->
      start = new Date().getTime()
      continue while new Date().getTime() - start < ms

    messages_to_bottom()

    App.global_agent = App.cable.subscriptions.create {
      channel: "AgentRoomsChannel"
      agent_room_id: messages.data('agent-room-id')
    },
      connected: ->
    # Called when the subscription is ready for use on the server

      disconnected: ->
    # Called when the subscription has been terminated by the server

      received: (data) ->
        messages.append data['message']
        messages_to_bottom()

      send_message: (message, agent_room_id) ->
        @perform 'send_message', message: message, agent_room_id: agent_room_id

    $('#new_message').keydown (e) ->
      keyCode = if e.keyCode then e.keyCode else e.which
      if keyCode == 13
        $('#new_message').trigger 'submit'

    $('#new_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#message_body')
      if $.trim(textarea.val()).length > 0
        App.global_agent.send_message textarea.val(), messages.data('agent-room-id')
        textarea.val('')
      e.preventDefault()
      return false
