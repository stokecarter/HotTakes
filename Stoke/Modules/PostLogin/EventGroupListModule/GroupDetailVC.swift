//
//  GroupDetailVC.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit

protocol GroupDetailDelegate:AnyObject {
    func editRoom(_ room:ChatRoom)
    func showSaveRoomPopup()
}

class GroupDetailVC: BaseVC {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var bgViewTopConstraint: NSLayoutConstraint!
    
    var viewModel:GroupDetailVM!
    var room:ChatRoom!
    weak var delegate:GroupDetailDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if room.isCreatedByMe{
            if !room.isLive{
                editBtn.isHidden = false
            }else{
                editBtn.isHidden = true
            }
        }else{
            editBtn.isHidden = true
        }
        viewModel = GroupDetailVM(NetworkLayer(), room: room)
        viewModel.notifyChatSave = { [weak self] in
            self?.dismiss(animated: false) {
                guard let self = self else { return }
                self.delegate?.showSaveRoomPopup()
            }
        }
        headerView.roundCorner([.topRight,.topLeft], radius: 25)
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.roundCorner([.topRight,.topLeft], radius: 25)
    }
    
    override func initalSetup() {
        headerView.roundCorner([.topRight,.topLeft], radius: 25)
        tableView.registerCell(with: ChatroomHeaderTVCell.self)
        tableView.registerCell(with: ChatRoomDetailTVCell.self)
        tableView.delegate = self
        tableView.dataSource = self
//        let gestureRecognizer = UIPanGestureRecognizer(target: self,
//                                                       action: #selector(panGestureRecognizerHandler(_:)))
//        view.addGestureRecognizer(gestureRecognizer)
        editBtn.setTitleColor(AppColors.themeColor, for: .normal)
        editBtn.titleLabel?.font = AppFonts.Medium.withSize(14)
    }
    
//    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
//        let touchPoint = sender.location(in: view?.window)
//        var initialTouchPoint = CGPoint.zero
//        switch sender.state {
//        case .began:
//            if touchPoint.y == bgView.frame.origin.y{
//                break
//            }else{
//                initialTouchPoint = touchPoint
//            }
//        case .changed:
//            if touchPoint.y == bgView.frame.origin.y {
//                break
//            }else if touchPoint.y > initialTouchPoint.y {
//                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                    self.bgView.frame.origin.y = touchPoint.y - initialTouchPoint.y
//                    self.headerView.layoutIfNeeded()
//                })
//
//            }
//        case .ended, .cancelled:
//            if touchPoint.y - initialTouchPoint.y > 280 {
//                dismiss(animated: false, completion: nil)
//            } else {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.bgView.frame = CGRect(x: 0,
//                                               y: 0,
//                                               width: self.view.frame.size.width,
//                                               height: self.view.frame.size.height)
//
//                })
//            }
//        case .failed, .possible:
//            break
//        }
//    }
    
    @IBAction func edittapped(_ sender: Any) {
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.delegate?.editRoom(self.room)
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}


extension GroupDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: ChatroomHeaderTVCell.self)
            cell.populateCell(room)
            return cell
        default:
            let cell = tableView.dequeueCell(with: ChatRoomDetailTVCell.self)
            cell.populateCell(room)
            cell.joinTapped = { [weak self] in
                guard let self = self else { return }
                if self.room.isLive{
                    CommonFunctions.showToastWithMessage("Under Development")
                }else{
                    if self.room.isCreatedByMe{
                               
                    }else{
                        if self.room.isSaved{
                            self.viewModel.hitForUnsaveChatRoom { [weak self] in
                                self?.room.isSaved = false
                                self?.tableView.reloadData()
                            }
                        }else{
                            self.viewModel.hitForSaveChatRoom()

                        }
                    }
                }
            }
            return cell
        }
    }
}

extension GroupDetailVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = scrollView.contentOffset.y
//        if (y > 0 && y > (view.frame.origin.y - bgView.frame.origin.y)){
//            UIView.animate(withDuration: 0.2, animations: {
//                if self.bgViewTopConstraint.constant - y > 20{
//                    self.bgViewTopConstraint.constant -= y
//                }
//                self.view.layoutIfNeeded()
//            })
//        }
//        print(y)
    }
}
