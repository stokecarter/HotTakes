//
//  UserListVC.swift
//  Stoke
//
//  Created by Admin on 17/03/21.
//

import UIKit
import SwiftyJSON
import EmptyDataSet_Swift

class UserListVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    var viewModel:SearchVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo User available", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "no_user"))
                .didTapDataButton {
                    
                }
                .didTapContentView {
                    // Do something
                }
        }

    }
    
    override func initalSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension UserListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: UserListTVCell.self)
        cell.populateCell(viewModel.userList.data[indexPath.row])
        return cell
    }
}




class UserListTVCell:UITableViewCell{
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imView.round()
        initialSetup()
    }
    
    private func initialSetup(){
        userNameLabel.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        nameLabel.textColor = AppColors.labelColor
        imView.backgroundColor = .clear
    }
    
    func populateCell(_ user:User){
        userNameLabel.text = user.userName
        nameLabel.text = user.firstName + " " + user.lastName
        imView.setImageWithIndicator(with: URL(string: user.image), placeholderImage: #imageLiteral(resourceName: "ic-profile-placeholder"))
    }
    
    
    

}
