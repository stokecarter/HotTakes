//
//  InviteUserTVCell.swift
//  Stoke
//
//  Created by Admin on 25/03/21.
//

import UIKit

class InviteUserTVCell: UITableViewCell {
    

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectionTapped:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionBtn.setImage(#imageLiteral(resourceName: "ic-check-inactive"), for: .normal)
        selectionBtn.setImage(#imageLiteral(resourceName: "ic_login_successful"), for: .selected)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        userImageView.roundCorners()
        
    }
    
    @IBAction func selectionbtnTapped(_ sender: Any) {
        if let select = selectionTapped { select()}
    }
    
    func populateCell(_ user:User){
        nameLabel.text = user.userName
        userNamelabel.text = user.fullName
        userImageView.setImageWithIndicator(with: URL(string: user.image), placeholderImage: #imageLiteral(resourceName: "ic-profile-placeholder"))
        selectionBtn.isSelected = user.isInvited
    }
    
    
}
