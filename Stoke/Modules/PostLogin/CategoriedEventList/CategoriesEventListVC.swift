//
//  CategoriesEventListVC.swift
//  Stoke
//
//  Created by Admin on 19/03/21.
//

import UIKit

class CategoriesEventListVC: BaseVC {
    
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var slidderView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var historyTableView: UITableView!
    
    var category:Categories!
    
    var viewModel:CategoriesEventList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        viewModel = CategoriesEventList(NetworkLayer(), categoryId: category.id)
        viewModel.getEvent(.upcoming)
        viewModel.notifyUpdate = { [weak self] in
            self?.upcomingTableView.reloadData()
            self?.historyTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func initalSetup() {
        setNavigationBar(title: category.name, backButton: true)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.dataSource = self
        [upcomingTableView,historyTableView].forEach {
            $0?.registerCell(with: FeaturesTVCell.self)
            $0?.registerCell(with: ViewAllHeaderBtnTVCell.self)
        }
        upcomingTableView.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo Event Available", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "ic-no-event"))
                .didTapDataButton {
                    
                }
                .didTapContentView {
                    // Do something
                }
        }
        historyTableView.emptyDataSetView { view in
            view.titleLabelString(NSAttributedString(string: "\n\nNo Event Available", attributes: [NSAttributedString.Key.font:AppFonts.Semibold.withSize(16),NSAttributedString.Key.foregroundColor:UIColor.black]))
                .image(#imageLiteral(resourceName: "ic-no-event"))
                .didTapDataButton {
                }
                .didTapContentView {
                }
        }
    }
    
    
    
    override func setupFounts() {
        upcomingBtn.isSelected = true
        [upcomingBtn,historyBtn].forEach { $0?.setTitleColor(AppColors.themeColor, for: .selected)
            $0?.setTitleColor(#colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), for: .normal)
            $0?.titleLabel?.font = AppFonts.Medium.withSize(16)
        }
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
        
        upcomingBtn.isSelected   = sender === upcomingBtn ? true:false
        historyBtn.isSelected   = sender === historyBtn ? true:false
        
    }
    
    private func showViewAll(_ event:SortedEvents, type:EventType){
        let vc = TodaysEventListVC.instantiate(fromAppStoryboard: .Home)
        vc.dayString = event.weakDay
        vc.isTodays = false
        vc.type = type
        vc.startDate = event.startTimeStamp
        vc.category = event.events.first?.category
        AppRouter.pushViewController(self, vc)
    }
}

// Mark:- UIScrollView

extension CategoriesEventListVC : UIScrollViewDelegate    {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView)    {
        if scrollView === historyTableView || scrollView === upcomingTableView {
            return
        }
        let width = scrollView.width/slidderView.width
        let scroll = scrollView.contentOffset.x
        print(scroll)
        slidderView.transform = CGAffineTransform(translationX: scroll/width, y: 0)
        switch scroll {
        case  0:
            setSelectedButton(upcomingBtn)
            viewModel.getEvent(.upcoming)
        case  UIDevice.width :
            setSelectedButton(historyBtn)
            viewModel.getEvent(.history)
        default :
            break
        }
    }
}


extension CategoriesEventListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === upcomingTableView{
            return viewModel.upcomingEvents.data.count
        }else{
            return viewModel.historyEvents.data.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === upcomingTableView{
            let count = viewModel.upcomingEvents.data[section].events.count
            return count > 0 ? count + 1 : 0
        }else{
            let count = viewModel.historyEvents.data[section].events.count
            return count > 0 ? count + 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === upcomingTableView {
            switch indexPath.row {
            case 0:
                let cell =  tableView.dequeueCell(with: ViewAllHeaderBtnTVCell.self)
                let d = viewModel.upcomingEvents.data[indexPath.section]
                let txt = d.events[0].weakDay
                cell.headerLabel.text = txt
                cell.viewAllBtn.isHidden = !d.isMoreAvailable
                cell.btnAction = { [weak self] in
                    guard let self = self else { return }
                    self.showViewAll(self.viewModel.upcomingEvents.data[indexPath.section], type: .upcoming)
                }
                return cell
            default:
                let cell = tableView.dequeueCell(with: FeaturesTVCell.self)
                cell.populateData(viewModel.upcomingEvents.data[indexPath.section].events[indexPath.row - 1])
                return cell
            }
        }else{
            switch indexPath.row {
            case 0:
                let cell =  tableView.dequeueCell(with: ViewAllHeaderBtnTVCell.self)
                let d = viewModel.historyEvents.data[indexPath.section]
                let txt = d.events[0].weakDay
                cell.headerLabel.text = txt
                cell.viewAllBtn.isHidden = !d.isMoreAvailable
                cell.btnAction = { [weak self] in
                    guard let self = self else { return }
                    self.showViewAll(self.viewModel.historyEvents.data[indexPath.section], type: .history)
                }
                return cell
            default:
                let cell = tableView.dequeueCell(with: FeaturesTVCell.self)
                cell.populateData(viewModel.historyEvents.data[indexPath.section].events[indexPath.row - 1])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else { return }
        if tableView === upcomingTableView {
            let vc = EventGroupListVC.instantiate(fromAppStoryboard: .Home)
            vc.event = viewModel.upcomingEvents.data[indexPath.section].events[indexPath.row - 1]
            AppRouter.pushViewController(self, vc)
        }else{
            let vc = EventGroupListVC.instantiate(fromAppStoryboard: .Home)
            vc.event = viewModel.historyEvents.data[indexPath.section].events[indexPath.row - 1]
            vc.iSFromHistory = true
            AppRouter.pushViewController(self, vc)
        }
    }
}
