//
//  ChatroomCellView.swift
//  DLSocketSimplyiOS
//
//  Created by Daniel Lahoz on 6/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import UIKit

class ChatroomCellView: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.username.text = ""
        self.message.text = ""
    }
    
}
