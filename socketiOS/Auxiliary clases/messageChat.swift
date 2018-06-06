//
//  messageChat.swift
//  socketiOS
//
//  Created by Daniel Lahoz on 6/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

///Message struct recived from Socket.io server
struct messageChat: Codable{
    let username: String
    let message: String
}
