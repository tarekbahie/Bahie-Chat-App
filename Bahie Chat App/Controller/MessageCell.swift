//
//  MessageCell.swift
//  Bahie Chat App
//
//  Created by tarek bahie on 2/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var senderImg: UIImageView!
    @IBOutlet weak var messageContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell (image : UIImage, content : String) {
        self.senderImg.image = image
        self.messageContent.text = content
        
    }

}
