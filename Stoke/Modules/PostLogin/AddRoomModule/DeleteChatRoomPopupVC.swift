//
//  DeleteChatRoomPopupVC.swift
//  Stoke
//
//  Created by Admin on 22/03/21.
//

import UIKit

protocol DeleteChatRoomPopupDelegate:AnyObject {
    func deleteTapped()
}

class DeleteChatRoomPopupVC: BaseVC {

    @IBOutlet weak var cancel: AppButton!
    @IBOutlet weak var delete: AppButton!

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    
    weak var delegate: DeleteChatRoomPopupDelegate?
    var heading:String = ""
    var subheading:String = ""
    
    
    var isFromSignup:Bool = false
    var msg:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initalSetup() {
        cancel.btnType = .whiteColor
        delete.btnType = .themeColor
    }
    
    override func setupFounts() {
        headingLabel.font = AppFonts.Medium.withSize(18)
        subHeading.font = AppFonts.Regular.withSize(16)
        subHeading.textColor = AppColors.labelColor
//        headingLabel.text = heading
//        subHeading.text = subheading
        
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        delegate?.deleteTapped()
        dismiss(animated: false, completion: nil)
    }
    @IBAction func canelTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

}
