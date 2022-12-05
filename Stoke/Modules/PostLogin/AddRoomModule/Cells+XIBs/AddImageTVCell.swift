//
//  AddImageTVCell.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit

class AddImageTVCell: UITableViewCell {
    
    
    @IBOutlet weak var profileIMView: UIImageView!
    
    var tapOnIMView:(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addProfileTapped(_ sender: Any) {
        if let tap = tapOnIMView { tap() }
    }
    
    func populateImage(_ img:String){
        profileIMView.setImageWithIndicator(with: URL(string: img), placeholderImage: UIImage())
    }
    
}
