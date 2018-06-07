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
    
    var chatRoom: ChatRoomHandler = ChatRoomHandler()
    var chatRoomView: ChatroomViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Rremove delegate when we are going to dessapear
        chatRoom.loginDelegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Buttons actions
    @IBAction func touchLogin(_ sender: Any) {
        if txtUsername.text!.count > 0 && txtRoomname.text!.count > 0{
            chatRoom.connectToServer(username: txtUsername.text!, roomname: txtRoomname.text!)
            chatRoom.loginDelegate = self
        }
    }
    
}

extension LogInViewController: ChatRoomLoginDelegate{
    func chatRoomHasBeenLoged() {
        print("Loged")
        self.chatRoom.loginDelegate = nil //Rremove delegate when we are going to dessapear to avoid multiple calls from server
        
        //Create the chatRoomView
        chatRoomView = self.storyboard!.instantiateViewController(withIdentifier: "ChatroomViewController") as? ChatroomViewController
        //Injecting username
        chatRoomView!.username = txtUsername.text!
        //Injecting chatRoomManager y create delegation
        chatRoomView!.chatRoom = self.chatRoom
        chatRoomView!.chatRoom!.chatReciverDelegate = chatRoomView
        
        //Push the view
        self.navigationController!.pushViewController(chatRoomView!, animated: true)
    }
}
