//
//  AddRoomVC.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit
import Mantis


class AddRoomVC: BaseVC {

    
    @IBOutlet weak var tableview: UITableView!
    
    var isEditingMode:Bool = false
    var room:ChatRoom!
    var event:Event!
    var viewModel:AddRoomVM!
    var enableSaveBtn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppRouter.tabBar.isTitleImageViewHiden = true
        viewModel = AddRoomVM(NetworkLayer(), eventId: event.id)
        if isEditingMode{
            viewModel.room = room
            addRightButtonToNavigation(title: "Delete")

        }
        viewModel.notifyTOReload  = { [weak self] in
            self?.tableview.reloadData()
        }
        tableview.dataSource = self
        tableview.delegate = self
        viewModel.roomCreated = { [weak self] in
            DispatchQueue.main.async {
                self?.presentPopupView()
            }
        }
        viewModel.roomUpdated = { [weak self] msg in
            DispatchQueue.main.async {
                self?.presentPopupView(msg: msg)
            }
            
        }
        viewModel.roomDeleted = { [weak self] in
            DispatchQueue.main.async {
                self?.pop()
            }
            
        }
        viewModel.didEnableSaveBtn = { [weak self] flag in
            self?.enableSaveBtn = flag
            self?.tableview.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .none)
        }
        
        viewModel.notifyLimitreached = { [weak self] in
            guard let self = self else { return }
            let vc = OutofRoomsVC.instantiate(fromAppStoryboard: .Events)
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    override func initalSetup() {
        var t = isEditingMode ? "Edit Room" : "Add Room"
        setNavigationBar(title: t, backButton: true)
        tableview.registerCell(with: AddImageTVCell.self)
        tableview.registerCell(with: AppTFTVCell.self)
        tableview.registerCell(with: DescriptionTVCell.self)
        tableview.registerCell(with: RadioBtnTVCell.self)
        tableview.registerCell(with: AppThemeBtnTVCell.self)
        tableview.registerCell(with: TwoButtonsTVCell.self)
        
    }
    
    override func rightBarButtonTapped(_ sender: UIButton) {
        let vc = DeleteChatRoomPopupVC.instantiate(fromAppStoryboard: .Events)
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    private func showPopup(){
        let vc = ThreeBtnPopup.instantiate(fromAppStoryboard: .Home)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.delagate = self
        vc.btn1Title = "Gallery"
        vc.btn2Title = "Use Event Image"
        vc.btn3Title = "Cancel"
        present(vc, animated: false, completion: nil)
    }
    
    private func pushToInviteFriends(){
        let vc = InviteFriendsVC.instantiate(fromAppStoryboard: .Home)
        vc.viewModel = viewModel
        AppRouter.pushViewController(self, vc)
    }

}

extension AddRoomVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableview.dequeueCell(with: AddImageTVCell.self)
            if let img = viewModel.dummyImage{
                cell.profileIMView.image = img
            }else{
                cell.populateImage(viewModel.image)
            }
            
            cell.tapOnIMView = { [weak self] in
                self?.showPopup()
            }
            return cell
        case 1:
            let cell = tableview.dequeueCell(with: AppTFTVCell.self)
            cell.chatroomNameTF.text = viewModel.chatRoomName
            cell.chatroomNameTF.editingChange = { [weak self] in
                self?.viewModel.chatRoomName = cell.chatroomNameTF.text ?? ""
            }
            return cell
        case 2:
            let cell = tableview.dequeueCell(with: DescriptionTVCell.self)
            cell.descTextView.text = viewModel.roomDesc
            cell.descriptionText = { [weak self] desc in
                self?.viewModel.roomDesc = desc
            }
            return cell
        case 3:
            let cell = tableview.dequeueCell(with: RadioBtnTVCell.self)
            cell.isPublic = viewModel.roomType  == ._public
            cell.isPublicSelected = { [weak self] falg in
                self?.tableview.beginUpdates()
                self?.viewModel.roomType = falg ? ._public : ._private
                self?.tableview.endUpdates()
            }
            return cell
        case 4:
            let cell = tableview.dequeueCell(with: AppThemeBtnTVCell.self)
            cell.createRoom = { [weak self] in
                self?.pushToInviteFriends()
            }
            cell.clipsToBounds = true
            return cell
        default:
            let cell = tableview.dequeueCell(with: TwoButtonsTVCell.self)
            let tit = isEditingMode ? "Update" : "Save"
            cell.saveBtn.setTitle(tit, for: .normal)
            cell.enableBtn = enableSaveBtn
            cell.isSaveGroup = { [weak self] flag in
                guard let self = self else { return }
                if flag{
                    if self.isEditingMode{
                        self.viewModel.editroom()
                    }else{
                        self.viewModel.createRoom()
                    }
                }else{
                    self.pop()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 && viewModel != nil{
            if viewModel.roomType == ._public{
                return CGFloat.leastNormalMagnitude
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return UITableView.automaticDimension
        }
    }
    
    private func presentPopupView(msg:String = "Chat room created successfully"){
        let vc = RoomCreatedSuccessVC.instantiate(fromAppStoryboard: .Events)
        vc.delegate = self
        vc.heading = "Success!"
        vc.okBtntitle = "OK"
        vc.subheading = msg
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension AddRoomVC : SignupSucessDelegate {
    func okTapped() {
        pop()
    }
}

extension AddRoomVC : DeleteChatRoomPopupDelegate {
    func deleteTapped() {
        viewModel.deleteChatRooms()
    }
}

extension AddRoomVC : ThreeBtnPopupDelegate{
    func getUserChoice(_ index: Int) {
        if index == 0{
            captureImage(delegate: self)
        }else if index == 1 {
            viewModel.image = event.image ?? ""
            viewModel.dummyImage = nil
            tableview.reloadData()
        }
    }
}

extension AddRoomVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        var config = Mantis.Config()
        config.showRotationDial = false
        config.addCustomRatio(byVerticalWidth: 1, andVerticalHeight: 2)
        let vc = Mantis.cropViewController(image: image, config: config)
        vc.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 16.0 / 9.0)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddRoomVC : CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        cropViewController.dismiss(animated: false, completion: nil)
        viewModel.isUploading = true
        viewModel.dummyImage = cropped
        tableview.reloadData()
        CommonFunctions.showActivityLoader()
        AWSController.uploadImage(cropped, success: { [weak self](flag, url) in
            self?.viewModel.image = url
            self?.viewModel.isUploading = false
            CommonFunctions.hideActivityLoader()
            printDebug(url)
            }, progress: { (progress) in
                printDebug(progress)
        }) { [weak self](e) in
            self?.viewModel.isUploading = false
            CommonFunctions.hideActivityLoader()
            CommonFunctions.showToastWithMessage(e.localizedDescription)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        
    }
    
    
}


extension AddRoomVC : OutofRoomsDelegate {
    func popNow(){
        pop()
    }
}
