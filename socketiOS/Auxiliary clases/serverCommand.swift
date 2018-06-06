//
//  serverCommand.swift
//  socketiOS
//
//  Created by Daniel Lahoz on 6/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

///The posible verbs that our *Socket.io* server accept
///
///Uses **.rawValue** to get the *String* needed for SocketIO
/// ```
///     serverCommand.addUser.rawValue
/// ```
public enum serverCommand: String {
    case    login = "login",
    addUser = "add user",
    newMessage = "new message",
    typing = "typing",
    stopTyping = "stop typing",
    dissconnect = "disconnect",
    reconnect = "reconnect",
    reconnectError = "reconnect_error",
    userJoined = "user joined",
    userLeft = "user left"
    
    static let allValues = [login, addUser, newMessage, typing, stopTyping, dissconnect, reconnect, reconnectError, userJoined, userLeft]
    static let allRawValues: [String] = [login.rawValue, addUser.rawValue, newMessage.rawValue, typing.rawValue, stopTyping.rawValue, dissconnect.rawValue, reconnect.rawValue, reconnectError.rawValue, userJoined.rawValue, userLeft.rawValue]
}
