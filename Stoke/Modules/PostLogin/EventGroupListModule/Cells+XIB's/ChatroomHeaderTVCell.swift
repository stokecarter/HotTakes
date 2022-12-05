//
//  ChatroomHeaderTVCell.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit

class ChatroomHeaderTVCell: UITableViewCell {
    
    
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var createrImageView: UIImageView!
    @IBOutlet weak var createrUsername: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var isPrivateicon: UIImageView!
    
    var isLive:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func populateCell(_ chat:ChatRoom){
        isLive = chat.isLive
        print(chat.startDateObject)
        print(chat.isToday)
        
        if !isLive{
            let dt = chat.startDateObject.toString(dateFormat: "MMM d")
            let time = chat.startDateObject.toString(dateFormat: "h:mm a")
            liveLabel.text = time + " | " + dt
            liveLabel.textColor = #colorLiteral(red: 0.4666666667, green: 0.4666666667, blue: 0.4666666667, alpha: 1)
            liveView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 0.4)
            liveLabel.font = AppFonts.Bold.withSize(11)
            liveView.isHidden = true
        }else{
            liveLabel.text = "Live"
            liveLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            liveView.backgroundColor = AppColors.themeColor
            liveLabel.font = AppFonts.Regular.withSize(11)
        }
        isPrivateicon.isHidden = chat.roomType == ._public
        roomImageView.setImageWithIndicator(with: URL(string: chat.image), placeholderImage: #imageLiteral(resourceName: "ic_profile_placeholder"))
        roomTitle.text = chat.name
        createrImageView.setImageWithIndicator(with: URL(string: chat.createdBy.image), placeholderImage: #imageLiteral(resourceName: "ic-profile-placeholder"))
        createrUsername.text = chat.createdBy.userName.isEmpty ? "Admin" : chat.createdBy.userName
        groupDesc.text = chat.description
    }
    
}
