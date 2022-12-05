//
//  InviteFriendsVC.swift
//  Stoke
//
//  Created by Admin on 24/03/21.
//

import UIKit

class InviteFriendsVC: BaseVC {
    
    
    @IBOutlet weak var inviteAll: UIButton!
    @IBOutlet weak var inviteSelected: AppButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:AddRoomVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.searchQuery = ""
        viewModel.notifyTOReload = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func initalSetup() {
        tableView.registerCell(with: InviteUserTVCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupFounts() {
        inviteSelected.btnType = .themeColor
        setNavigationBar(title: "Invite Friends", backButton: true)

    }
    
    @IBAction func textFieldDidChangeCharacters(_ sender: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.viewModel.searchQuery = sender.text ?? ""
        }
    }
    
    
    @IBAction func inviteSelectedTapped(_ sender: Any) {
        viewModel.inviteIds = viewModel.userList.data.filter { $0.isInvited}.map { $0.id}
        pop()
    }
    
    @IBAction func inviteAllTapped(_ sender: Any) {
        viewModel.isInviteAll = true
        pop()
    }
}

extension InviteFriendsVC : UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        view.endEditing(true)
        viewModel.searchQuery = ""
        return false
    }
    
}

extension InviteFriendsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userList.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: InviteUserTVCell.self)
        cell.populateCell(viewModel.userList.data[indexPath.row])
        if viewModel.inviteIds.contains(viewModel.userList.data[indexPath.row].id){
            cell.selectionBtn.isSelected = true
        }
        cell.selectionTapped = { [weak self] in
            guard let self = self else { return }
            let id = self.viewModel.userList.data[indexPath.row].id
            if self.viewModel.inviteIds.contains(id){
                if let index = self.viewModel.inviteIds.firstIndex(of: id){
                    self.viewModel.inviteIds.remove(at: index)
                    self.viewModel.userList.data[indexPath.row].isInvited = false
                }
            }else{
                self.viewModel.inviteIds.append(id)
                self.viewModel.userList.data[indexPath.row].isInvited = true
            }
            self.tableView.reloadData()
        }
        return cell
    }
}
