//
//  EventGroupListVC.swift
//  Stoke
//
//  Created by Admin on 21/03/21.
//

import UIKit
import EmptyDataSet_Swift
import FittedSheets

class EventGroupListVC: BaseVC {

    @IBOutlet weak var trendingBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var slidderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var followingCollectionView: UICollectionView!
    @IBOutlet weak var roomTitle: UILabel!
    
    
    var iSFromHistory:Bool = false
    var event:Event!
    var viewModel:EventGroupListVM!
    
     var refreshController : UIRefreshControl  = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        roomTitle.isHidden = true
        viewModel = EventGroupListVM(NetworkLayer(), eventId: event.id)
        roomTitle.font = AppFonts.Medium.withSize(16)
        roomTitle.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        viewModel.notifyUpdate = { [weak self] in
            self?.roomTitle.isHidden = self?.viewModel.trendingChatRooms.chatRooms.isEmpty ?? true
            self?.trendingCollectionView.reloadData()
            self?.followingCollectionView.reloadData()
        }
        if iSFromHistory || event.isEventConcluded{
            hideRightBtn()
        }else{
            showRightBtn()
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonFunctions.navigationTitleImageView.isHidden = true
        viewModel.getAllTrendingChatRooms(type: .trending)
    }
    
    override func initalSetup() {
        trendingCollectionView.contentInset = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        setNavigationBar(title: event.name, backButton: true)
        addRightButtonToNavigation(image: #imageLiteral(resourceName: "ic_add_room"))
        trendingCollectionView.registerCell(with: GroupCVCell.self)
        followingCollectionView.registerCell(with: GroupCVCell.self)
        [trendingCollectionView,followingCollectionView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
        trendingCollectionView.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo Chatroom Available", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "ic-no-chatroom"))
                .didTapDataButton {
                }
                .didTapContentView {
                }
        }
        followingCollectionView.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo Chatroom Available", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "ic-no-chatroom"))
                .didTapDataButton {
                }
                .didTapContentView {
                }
        }

        
    }

    override func setupFounts() {
        trendingBtn.isSelected = true
        [trendingBtn,followingBtn].forEach { $0?.setTitleColor(AppColors.themeColor, for: .selected)
            $0?.setTitleColor(#colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), for: .normal)
            $0?.titleLabel?.font = AppFonts.Medium.withSize(16)
        }
    }
    
    override func rightBarButtonTapped(_ sender: UIButton) {
        let vc = AddRoomVC.instantiate(fromAppStoryboard: .Events)
        vc.event = event
        vc.isEditingMode = false
        AppRouter.pushFromTabbar(vc)
    }
    
    
    // Mark:- IBActions
    
    @IBAction func trendingTapped(_ sender: UIButton) {
        setSelectedButton(sender)
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func followingTapped(_ sender: UIButton) {
        self.setSelectedButton(sender)
        self.scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
    }
    
    
    
    private func setSelectedButton(_ sender:UIButton){
        
        trendingBtn.isSelected   = sender === trendingBtn ? true:false
        followingBtn.isSelected   = sender === followingBtn ? true:false
        
    }
    
    private func presentDetail(_ chat:ChatRoom){
        guard CommonFunctions.checkForInternet() else { return }
        viewModel.groupDetail(chat._id) { [weak self](data) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = GroupDetailVC.instantiate(fromAppStoryboard: .Events)
                vc.room = data
                vc.delegate = self
                let sheet = SheetViewController(controller: vc, sizes: [.fixed(self.view.bounds.height*0.75), .marginFromTop(35)])
                sheet.gripSize = .zero
                sheet.gripColor = .clear
                sheet.minimumSpaceAbovePullBar = 0
                sheet.contentBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                sheet.cornerRadius = 0
                sheet.pullBarBackgroundColor = .clear
                self.present(sheet, animated: false, completion: nil)
            }
        }
    }
    
    private func addPullToRefresh(){
        refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        trendingCollectionView.refreshControl = refreshController
        followingCollectionView.refreshControl = refreshController
    }
    
    @objc func refresh(){
        trendingCollectionView.reloadData()
        followingCollectionView.reloadData()
        refreshController.endRefreshing()
    }
    
    private func presentPopupView(){
        let vc = RoomCreatedSuccessVC.instantiate(fromAppStoryboard: .Events)
        vc.delegate = self
        vc.heading = "Chatroom Saved"
        vc.subheading = "You have successfully saved the chat room\nWe will notify once the chatroom is live"
        vc.okBtntitle = "Go Back to Chat Rooms"
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

// Mark:- UIScrollView

extension EventGroupListVC : UIScrollViewDelegate    {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView)    {
        guard scrollView != trendingCollectionView else { return }
        guard scrollView != followingCollectionView else { return }
        let width = scrollView.width/slidderView.width
        let scroll = scrollView.contentOffset.x
        slidderView.transform = CGAffineTransform(translationX: scroll/width, y: 0)
        switch scroll {
        case  0:
            viewModel.getAllTrendingChatRooms(type: .trending)
            setSelectedButton(trendingBtn)
        case  UIDevice.width :
            viewModel.getAllTrendingChatRooms(type: .following)
            setSelectedButton(followingBtn)
        default :
            break
        }
    }
}


extension EventGroupListVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === trendingCollectionView{
            return viewModel != nil ? viewModel.trendingChatRooms.chatRooms.count : 0
        }else{
            return /*viewModel != nil ? viewModel.followingChatRooms.chatRooms.count :*/ 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: GroupCVCell.self, indexPath: indexPath)
        if collectionView === trendingCollectionView{
            cell.populatecell(viewModel.trendingChatRooms.chatRooms[indexPath.row])
        }else{
            cell.populatecell(viewModel.followingChatRooms.chatRooms[indexPath.row])
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20)/2
        return CGSize(width: width, height: 215)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !iSFromHistory else { return }
        if collectionView === trendingCollectionView{
            presentDetail(viewModel.trendingChatRooms.chatRooms[indexPath.row])
        }else{
            presentDetail(viewModel.followingChatRooms.chatRooms[indexPath.row])
        }
    }
}


extension EventGroupListVC : GroupDetailDelegate {
    func editRoom(_ room: ChatRoom) {
        let vc = AddRoomVC.instantiate(fromAppStoryboard: .Events)
        vc.event = event
        vc.room = room
        vc.isEditingMode = true
        AppRouter.pushFromTabbar(vc)
    }
    
    func showSaveRoomPopup() {
        presentPopupView()
    }
}


extension EventGroupListVC : SignupSucessDelegate {
    func okTapped() {
        AppRouter.goToMyrooms()
    }
}


