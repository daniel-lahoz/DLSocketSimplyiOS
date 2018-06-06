//
//  ChatroomViewController.swift
//  DLSocketSimplyiOS
//
//  Created by Daniel Lahoz on 6/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import UIKit
import SocketIO

class ChatroomViewController: UIViewController {

    public var chatRoom: ChatRoomHandler?
    
    var arrayOfMessages: [messageChat] = []
    
    @IBOutlet weak var tableViewOfMessages: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Rremove delegate when we are to dessapear
        chatRoom?.chatReciverDelegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack(){
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Buttons
    @IBAction func touchGoBack(_ sender: Any) {
        goBack()
    }
    
    @IBAction func touchSendMessage(_ sender: Any) {
        if chatRoom != nil && txtMessage.text!.count > 0{
            chatRoom?.sendNewMessage(message: txtMessage.text!)
            txtMessage.text! = ""
            txtMessage.becomeFirstResponder()
        }
    }
    
    @IBAction func textMessageDidEndOnExit(_ sender: Any) {
        self.touchSendMessage(sender)
    }
    
    
}

//MARK:- UITableViewDelegate and UITableViewDataSource
extension ChatroomViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatroomCellView", for: indexPath) as! ChatroomCellView
        
        let messageChat = arrayOfMessages[indexPath.item]
        
        cell.username.text = messageChat.username
        cell.message.text = messageChat.message
        
        return cell
    }
    
}

extension ChatroomViewController: ChatRoomReciverDelegate{
    func chatRoomHasReciveNewMessage(message: messageChat) {
        
        self.arrayOfMessages.append(message)
        self.tableViewOfMessages.reloadData()
    }
    
}
