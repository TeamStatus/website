class DataController < WebsocketRails::BaseController
  def client_connected
    system_msg :new_message, "client #{client_id} connected"
  end
  def new_message
    user_msg :new_message, message[:msg_body].dup
  end
  def new_user
    connection_store[:user] = { user_name: sanitize(message[:user_name]) }
    broadcast_user_list
  end
  def change_username
    connection_store[:user] = sanitize(message)
    broadcast_user_list
  end
  def delete_user
    connection_store[:user] = nil
    system_msg "client #{client_id} disconnected"
    broadcast_user_list
  end
  def broadcast_user_list
    users = connection_store.collect_all(:user)
    broadcast_message :user_list, users
  end
end