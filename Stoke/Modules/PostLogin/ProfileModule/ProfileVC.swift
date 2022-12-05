//
//  ProfileVC.swift
//  Stoke
//
//  Created by Admin on 18/03/21.
//

import UIKit

class ProfileVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserModel.main = UserModel()
        AppRouter.checkUserFlow()
    }
}
