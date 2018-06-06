//
//  ChatRoomHandler.swift
//  socketiOS
//
//  Created by Daniel Lahoz on 5/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import Foundation
import SocketIO

///Protocol of ChatRoomHandler for handle login connection
protocol ChatRoomLoginDelegate {
    func chatRoomHasBeenLoged()
}

///Protocol of ChatRoomHandler for handle messages and status from a chat room
// TODO: Complete the protocol
protocol ChatRoomReciverDelegate {
    func chatRoomHasReciveNewMessage(message: messageChat)
}


func socketCommand(command: serverCommand, dataString: String) -> Data? {
    let commandDicc: [String: String] = ["command" : command.rawValue,
                                        "identifier" : dataString]
    let jsonData = try? JSONSerialization.data(withJSONObject: commandDicc, options: .prettyPrinted)
    
    if jsonData != nil{
        return jsonData
    }else{
       return nil
    }
}


///ChatRoomHandler connect to **Socket.io** server handle the chatroom messages and conections
class ChatRoomHandler{
    //Username and Room name
    var username, roomname: String
    
    //Socket variables
    var manager: SocketManager
    var socket: SocketIOClient
    
    //Delegates
    var loginDelegate: ChatRoomLoginDelegate?
    var chatReciverDelegate: ChatRoomReciverDelegate?
    
    ///Create the connection to **Socket.io** server and join the room
    ///
    /// - Parameters:
    ///     - username: The *username* string
    ///     - roomname: The *name* of the *room* to be join.
    init(username: String, roomname: String){
        self.username = username
        self.roomname = roomname
        
        //Doing the connection to the server
        // FIXME: Change the socket URL to your own server if needed
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress, .selfSigned(true)])
        self.socket = manager.defaultSocket
        
        //Whe we obtain connection we active the listeners of the reciverMethods() ans also call the login()
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.reciverMothods()
            self.logIn()
        }
        
        self.socket.connect()
    }
    
    ///LogIn into the room named with *roomname* and *username*
    func logIn(){
        socket.emit(serverCommand.addUser.rawValue, ["username" : username, "roomname" : roomname])
    }
    
    ///Send a new message to all room users
    public func sendNewMessage(message: String){
        socket.emit(serverCommand.newMessage.rawValue, message)
    }
    
    //MARK: - Reciver Mothods
    ///This methods awaiting for messages from our Socket.io server
    // TODO: Manage all request and provide data to the protocol
    func reciverMothods(){
        
        socket.on(serverCommand.login.rawValue) { data, ack in
            print("Login happend")
            
            if self.loginDelegate != nil{
                self.loginDelegate?.chatRoomHasBeenLoged()
            }
        }
        
        socket.on(serverCommand.newMessage.rawValue) {data, ack in
            print("Menssage Recived: \(data)")
            guard let dicc = data[0] as? [String : String] else{
                return
            }
            
            let message = messageChat(username: dicc["username"]!, message: dicc["message"]!)
            
            if self.chatReciverDelegate != nil{
                self.chatReciverDelegate?.chatRoomHasReciveNewMessage(message: message)
            }
        }
        
        socket.on(serverCommand.userJoined.rawValue) {data, ack in
            print("User Joined: \(data)")
        }
        
        socket.on(serverCommand.userLeft.rawValue) {data, ack in
            print("User left: \(data)")
        }
        
        socket.on(serverCommand.typing.rawValue) {data, ack in
            print("typing... \(data)")
        }
        
        socket.on(serverCommand.stopTyping.rawValue) {data, ack in
            print("stop typing... \(data)")
        }
        
        socket.on(serverCommand.dissconnect.rawValue) {data, ack in
            print("Disconnect: \(data)")
        }
        
        socket.on(serverCommand.reconnect.rawValue) {data, ack in
            print("ReConnect: \(data)")
        }
        
        socket.on(serverCommand.reconnectError.rawValue) {data, ack in
            print("ReConnect ERROR: \(data)")
        }
        
        
    }
    
    
}

