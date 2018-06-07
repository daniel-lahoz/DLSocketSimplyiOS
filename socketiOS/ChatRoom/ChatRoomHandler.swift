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
    func chatRoomHasReciveUserJoined(user: String)
    func chatRoomHasReciveUserLeft(user: String)
    func chatRoomHasReciveTyping(user: String)
    func chatRoomHasReciveStopTyping(user: String)
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
    var username, roomname: String?
    var iAmLogged: Bool = false
    
    //Socket variables
    var manager: SocketManager
    var socket: SocketIOClient
    
    //Delegates
    var loginDelegate: ChatRoomLoginDelegate?
    var chatReciverDelegate: ChatRoomReciverDelegate?
    
    let serverURL = /* URL(string: "http://localhost:3000")! */ URL(string: "http://192.168.1.55:3000/")!
    
    var recibedMethodsLoaded = false
    
    init(){
        //Doing the connection to the server
        self.manager = SocketManager(socketURL: serverURL, config: [.log(true), .compress, .selfSigned(true)])
        self.manager.reconnects = true
        self.socket = manager.defaultSocket
    }
    
    
    ///Create the connection to **Socket.io** server and join the room
    ///
    /// - Parameters:
    ///     - username: The *username* string
    ///     - roomname: The *name* of the *room* to be join.
    func connectToServer(username: String, roomname: String){
        self.username = username
        self.roomname = roomname

        //Whe we obtain connection we active the listeners of the reciverMethods() ans also call the login()
        self.socket.on(clientEvent: .connect) {data, ack in
            DispatchQueue.main.async {
                print("🔌 socket connected")
                self.iAmLogged = false
                if self.recibedMethodsLoaded == false{
                    self.recibedMethodsLoaded = true
                    self.reciverMothods()
                }
                self.logIn()
            }
        }
    
        self.socket.connect(timeoutAfter: 2.0) {
            DispatchQueue.main.async {
                print("🚨 connection problem")
            }
        }
        
        self.socket.on(clientEvent: .disconnect) { data, ack in
            DispatchQueue.main.async {
                print("🚨 DISCONNECT")
            }
        }
        
        self.socket.on(clientEvent: .error) { data, ack in
            DispatchQueue.main.async {
                print("🚨 ERROR")
            }
        }
        
        self.socket.on(clientEvent: .statusChange) { data, ack in
            DispatchQueue.main.async {
                print("🚨 STATUS \(data)")
            }
        }
        
    }
    
    ///LogIn into the room named with *roomname* and *username*
    func logIn(){
        if iAmLogged == false{
            DispatchQueue.main.async {
                self.socket.emit(serverCommand.addUser.rawValue, ["username" : self.username, "roomname" : self.roomname])
            }
        }
    }
    
    ///Send a new message to all room users
    public func sendNewMessage(message: String){
        DispatchQueue.main.async {
            self.socket.emit(serverCommand.newMessage.rawValue, message)
            //Send to myself, you can comment this line if you dont want to recive your own messages
            self.sendMyMessageToMyself(message: message)
        }
    }
    
    ///This function send the message to yourself so you can show in the tableView your own message
    func sendMyMessageToMyself(message: String){
        let message = messageChat(username: username!, message: message)
        if self.chatReciverDelegate != nil{
            DispatchQueue.main.async {
                self.chatReciverDelegate?.chatRoomHasReciveNewMessage(message: message)
            }
        }
    }
    
    ///Send a new message to all room users
    public func disconnectFromServer(){
        DispatchQueue.main.async {
            self.socket.disconnect()
            self.iAmLogged = false
        }
    }
    
    ///Send a Typing to the server
    public func sendTyping(){
        DispatchQueue.main.async {
            self.socket.emit(serverCommand.typing.rawValue, [])
        }
    }
    
    ///Send a StopTyping to the server
    public func sendStopTyping(){
        DispatchQueue.main.async {
            self.socket.emit(serverCommand.stopTyping.rawValue, [])
        }
    }
    
    
    
    
    //MARK: - Reciver Mothods
    ///This methods awaiting for messages from our Socket.io server
    // TODO: Manage all request and provide data to the protocol
    func reciverMothods(){
        
        socket.on(serverCommand.login.rawValue) { data, ack in
            self.iAmLogged = true

            if self.loginDelegate != nil{
                DispatchQueue.main.async {
                    self.loginDelegate?.chatRoomHasBeenLoged()
                }
            }
        }
        
        socket.on(serverCommand.newMessage.rawValue) {data, ack in
            guard let dicc = data[0] as? [String : String] else{
                return
            }
            
            let message = messageChat(username: dicc["username"]!, message: dicc["message"]!)
            
            if self.chatReciverDelegate != nil{
                DispatchQueue.main.async {
                    self.chatReciverDelegate?.chatRoomHasReciveNewMessage(message: message)
                }
            }
        }
        
        socket.on(serverCommand.userJoined.rawValue) {data, ack in
            guard let dicc = data[0] as? [String : Any] else{
                return
            }

            let username = dicc["username"] as! String
            
            if self.chatReciverDelegate != nil{
                DispatchQueue.main.async {
                    self.chatReciverDelegate?.chatRoomHasReciveUserJoined(user: username)
                }
            }
        }
        
        socket.on(serverCommand.userLeft.rawValue) {data, ack in
            guard let dicc = data[0] as? [String : Any] else{
                return
            }
            
            let username = dicc["username"] as! String
            
            if self.chatReciverDelegate != nil{
                DispatchQueue.main.async {
                    self.chatReciverDelegate?.chatRoomHasReciveUserLeft(user: username)
                }
            }
        }
        
        socket.on(serverCommand.typing.rawValue) {data, ack in
            guard let dicc = data[0] as? [String : String] else{
                return
            }
            
            let username = dicc["username"]!
            
            if self.chatReciverDelegate != nil{
                DispatchQueue.main.async {
                    self.chatReciverDelegate?.chatRoomHasReciveTyping(user: username)
                }
            }
        }
        
        socket.on(serverCommand.stopTyping.rawValue) {data, ack in
            guard let dicc = data[0] as? [String : String] else{
                return
            }
            
            let username = dicc["username"]!
            
            if self.chatReciverDelegate != nil{
                DispatchQueue.main.async {
                    self.chatReciverDelegate?.chatRoomHasReciveStopTyping(user: username)
                }
            }
        }
        
        socket.on(serverCommand.dissconnect.rawValue) {data, ack in
            DispatchQueue.main.async {
                print("Disconnect: \(data)")
            }
        }
        
        socket.on(serverCommand.reconnect.rawValue) {data, ack in
            DispatchQueue.main.async {
                print("ReConnect: \(data)")
            }
        }
        
        socket.on(serverCommand.reconnectError.rawValue) {data, ack in
            DispatchQueue.main.async {
                print("ReConnect ERROR: \(data)")
            }
        }
        
    }
    
}

