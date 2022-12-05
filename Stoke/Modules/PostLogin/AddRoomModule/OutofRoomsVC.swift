//
//  OutofRoomsVC.swift
//  Stoke
//
//  Created by Admin on 25/03/21.
//

import UIKit

protocol OutofRoomsDelegate:AnyObject{
    func popNow()
}

class OutofRoomsVC: BaseVC {
    
    
    @IBOutlet weak var okBtn: AppButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate:OutofRoomsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func initalSetup() {
        okBtn.btnType = .themeColor
        titleLabel.font = AppFonts.Medium.withSize(18)
        descLabel.font = AppFonts.Regular.withSize(13)
        descLabel.textColor = AppColors.labelColor
    }
    
    @IBAction func okTapped(_ sender: Any) {
        delegate?.popNow()
        dismiss(animated: false, completion: nil)
        
    }
    

}
