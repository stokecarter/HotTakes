//
//  HomeVC.swift
//  Stoke
//
//  Created by Admin on 16/03/21.
//

import UIKit

class HomeVC: BaseVC {
    
    @IBOutlet weak var featuredBtn: UIButton!
    @IBOutlet weak var recommendedBtn: UIButton!
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var slidderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var featuredTableView: UITableView!
    @IBOutlet weak var recommendedTV: UITableView!
    
    var fRefresh = UIRefreshControl()
    var rRefresh = UIRefreshControl()
    var isTitleImageViewHiden:Bool = false{
        didSet{
            print("\n\n\n\n********************\n\n\n\n")
            print(isTitleImageViewHiden)
            CommonFunctions.navigationTitleImageView.isHidden = isTitleImageViewHiden
        }
    }
    
    var viewModel:FeatureListVM!
    
    var height:CGFloat{
        return UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTitleImageViewHiden = false
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name.scrollTotop, object: nil)
        scrollToTop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        addEmptyScreens()
        applyTransparentBackgroundToTheNavigationBar(0)
        viewModel = FeatureListVM(NetworkLayer())
        viewModel.notify = { [unowned self] in
            self.addEmptyScreens()
        }
        [fRefresh,rRefresh].forEach { $0.addTarget(self, action: #selector(hitrefresh), for: .valueChanged)
        }
        featuredTableView.refreshControl = fRefresh
        recommendedTV.refreshControl = rRefresh
        
    }
    
    func addNavBarImage() {
        CommonFunctions.navigationTitleImageView.image = #imageLiteral(resourceName: "ic-stoke-red-small")
        CommonFunctions.navigationTitleImageView.contentMode = .scaleAspectFit
        CommonFunctions.navigationTitleImageView.translatesAutoresizingMaskIntoConstraints = false
        CommonFunctions.navigationTitleImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelTapOnHeader))
        CommonFunctions.navigationTitleImageView.addGestureRecognizer(tap)
        if let navC = self.navigationController{
            navC.navigationBar.addSubview(CommonFunctions.navigationTitleImageView)
            CommonFunctions.navigationTitleImageView.centerXAnchor.constraint(equalTo: navC.navigationBar.centerXAnchor).isActive = true
            CommonFunctions.navigationTitleImageView.centerYAnchor.constraint(equalTo: navC.navigationBar.centerYAnchor, constant: -3).isActive = true
            CommonFunctions.navigationTitleImageView.widthAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.3).isActive = true
            CommonFunctions.navigationTitleImageView.heightAnchor.constraint(equalTo: navC.navigationBar.widthAnchor, multiplier: 0.2).isActive = true
        }
    }
    
    func addEmptyScreens(){
        featuredTableView.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo Event Available", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "ic_no_event"))
                .didTapDataButton {
                    
                }
                .didTapContentView {
                    // Do something
                }
        }
        recommendedTV.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo Recommended", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "ic_no_recommended"))
                .didTapDataButton {
                    
                }
                .didTapContentView {
                    // Do something
                }
        }
        recommendedTV.reloadData()
        featuredTableView.reloadData()
    }
    
    @objc func scrollToTop() {
        setSelectedButton(featuredBtn)
        scrollView.setContentOffset(CGPoint.zero, animated: true)
        if let v = viewModel,v.dataSource.data.count > 0{
        featuredTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
//        recommendedTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func initalSetup() {
        scrollView.delegate = self
        [recommendedTV,featuredTableView].forEach {
            $0?.registerCell(with: FeaturesTVCell.self)
            $0?.registerCell(with: ViewAllHeaderBtnTVCell.self)
            $0?.delegate = self
            $0?.dataSource = self
        }
        
    }
    
    override func setupFounts() {
        featuredBtn.isSelected = true
        featuredBtn.setTitle("Featured Events", for: .normal)
        recommendedBtn.setTitle("Recommended", for: .normal)
        [featuredBtn,recommendedBtn].forEach { $0?.setTitleColor(AppColors.themeColor, for: .selected)
            $0?.setTitleColor(#colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), for: .normal)
            $0?.titleLabel?.font = AppFonts.Medium.withSize(16)
        }
    }
    
    @objc func hitrefresh(_ sender:UIRefreshControl){
        viewModel.hitFeaturesApi()
        addEmptyScreens()
        sender.endRefreshing()
    }
    
    
    // Mark:- IBActions
    
    @IBAction func featuredTapped(_ sender: UIButton) {
        setSelectedButton(sender)
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func recommendedTapped(_ sender: UIButton) {
        if CommonFunctions.isFromSignUp{
            CommonFunctions.isFromSignUp = false
            let vc = RecommentCoatchMarksVC.instantiate(fromAppStoryboard: .Home)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.height = self.height
            present(vc, animated: false) { [unowned self] in
                self.setSelectedButton(sender)
                self.scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
            }
        }else{
            self.setSelectedButton(sender)
            self.scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: true)
        }
    }
    
    private func setSelectedButton(_ sender:UIButton){
        featuredBtn.isSelected   = sender === featuredBtn ? true:false
        recommendedBtn.isSelected   = sender === recommendedBtn ? true:false
    }
    
    private func viewAllFor(_ data:SortedEvents){
        let vc = TodaysEventListVC.instantiate(fromAppStoryboard: .Home)
        vc.dayString = data.weakDay
        vc.isTodays = false
        vc.isFeatured = true
        vc.startDate = data.startTimeStamp
        vc.category = data.events.first?.category
        isTitleImageViewHiden = true
        AppRouter.pushViewController(self, vc)
    }
    
    
}

// Mark:- UIScrollView

extension HomeVC : UIScrollViewDelegate    {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView)    {
        let width = scrollView.width/slidderView.width
        let scroll = scrollView.contentOffset.x
        slidderView.transform = CGAffineTransform(translationX: scroll/width, y: 0)
        switch scroll {
        case  0:
            setSelectedButton(featuredBtn)
        case  UIDevice.width :
            setSelectedButton(recommendedBtn)
        default :
            break
        }
    }
}


extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === featuredTableView {
            guard viewModel != nil else { return 0 }
            return viewModel.dataSource.data.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === featuredTableView{
            guard viewModel != nil else { return 0 }
            return viewModel.dataSource.data[section].events.count + 1
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === featuredTableView{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(with: ViewAllHeaderBtnTVCell.self)
                let d = viewModel.dataSource.data[indexPath.section]
                let txt = d.weakDay
                cell.headerLabel.text = txt
                cell.viewAllBtn.isHidden = !d.isMoreAvailable
                cell.btnAction = { [weak self] in
                    self?.viewAllFor(d)
                }
                return cell
            default:
                let cell = tableView.dequeueCell(with: FeaturesTVCell.self)
                cell.populateData(viewModel.dataSource.data[indexPath.section].events[indexPath.row - 1])
                return cell
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        if tableView === featuredTableView{
            guard CommonFunctions.checkForInternet() else { return }
            let vc = EventGroupListVC.instantiate(fromAppStoryboard: .Home)
            vc.event = viewModel.dataSource.data[indexPath.section].events[indexPath.row - 1]
            isTitleImageViewHiden = true
            AppRouter.pushViewController(self, vc)
        }else{
            
        }
    }
}
