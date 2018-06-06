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
    var username: String = ""
    
    var arrayOfMessages: [messageChat] = []
    
    @IBOutlet weak var tableViewOfMessages: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    @IBOutlet weak var sendButtonBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Get notified whrn keyboard changes size or appears
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Rremove delegate when we are to dessapear
        chatRoom?.chatReciverDelegate = nil
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack(){
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK:- Buttons
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
    
    //MARK:- Keyboard Show & Hide
    ///Handle keyboard size chnage and update bottom constrains for sendButton and textenter
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.sendButtonBottom?.constant = 20.0 //Default constrain
            } else {
                let newconstantHeight = endFrame?.size.height ?? 0.0 //Keyboard open
                self.sendButtonBottom?.constant = newconstantHeight + 20.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
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
        
        if username == messageChat.username{
            cell.username.textAlignment = .right
            cell.message.textAlignment = .right
        }else{
            cell.username.textAlignment = .left
            cell.message.textAlignment = .left
        }
        
        return cell
    }
    
}

extension ChatroomViewController: ChatRoomReciverDelegate{
    func chatRoomHasReciveNewMessage(message: messageChat) {
        
        self.arrayOfMessages.append(message)
        self.tableViewOfMessages.reloadData()
    }
    
}
