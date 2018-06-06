//
//  ViewController.swift
//  socketiOS
//
//  Created by Daniel Lahoz on 5/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import UIKit
import SocketIO

class LogInViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtRoomname: UITextField!
    @IBOutlet weak var txtMessage: UITextField!
    
    @IBOutlet weak var lbMessage: UILabel!
    
    
    var chatRoom: ChatRoomHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Buttons actions
    @IBAction func touchLogin(_ sender: Any) {
        if txtUsername.text!.count > 0 && txtRoomname.text!.count > 0{
            chatRoom = ChatRoomHandler.init(username: txtUsername.text!, roomname: txtRoomname.text!)
            chatRoom?.loginDelegate = self
            chatRoom?.chatReciverDelegate = self
        }
    }
    
    @IBAction func touchSendMessage(_ sender: Any) {
        if chatRoom != nil && txtMessage.text!.count > 0{
            chatRoom?.sendNewMessage(message: txtMessage.text!)
            txtMessage.text! = ""
        }
    }
    
}

extension LogInViewController: ChatRoomLoginDelegate{
    func chatRoomHasBeenLoged() {
        print("Logeado")
    }
    
    
}

extension LogInViewController: ChatRoomReciverDelegate{
    func chatRoomHasReciveNewMessage(message: messageChat) {
        let messageStr = message.message
        lbMessage.text = messageStr
    }
    
}
