//
//  DiscoverVC.swift
//  Stoke
//
//  Created by Admin on 17/03/21.
//

import UIKit


class DiscoverVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:DiscoverVM!
    var refreshController = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar(title: "Discover", backButton: false)
        viewModel.hitApiForCategories(loader: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DiscoverVM(NetworkLayer())
        viewModel.notify = { [weak self] in
            self?.tableView.reloadData()
        }
        addPullToRefresh()
    }
    
    override func initalSetup() {
        tableView.registerCell(with: ViewAllHeaderBtnTVCell.self)
        tableView.registerCell(with: HorizontalCollectionViewTVCell.self)
        tableView.registerCell(with: FeaturesTVCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func addPullToRefresh(){
        refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    @objc func refresh(){
        viewModel.hitApiForCategories()
        viewModel.hitTodaysEvents()
        tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    
    @IBAction func openSearchVC(_ sender: Any) {
        let vc = SearchVC.instantiate(fromAppStoryboard: .Home)
        AppRouter.pushViewController(self, vc)
    }
    
    
    private func perfornBtnAction(_ section:Int){
        switch section {
        case 0:
            let vc = CategoriesListVC.instantiate(fromAppStoryboard: .Home)
            vc.viewModel = viewModel
            AppRouter.pushViewController(self, vc)
        default:
            let vc = TodaysEventListVC.instantiate(fromAppStoryboard: .Home)
            vc.dataSource = viewModel.events
            AppRouter.pushViewController(self, vc)
        }
    }
}

extension DiscoverVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel == nil ? 0 : viewModel.categories.isEmpty ? 0 : 2
        default:
            if viewModel == nil || viewModel.events.isEmpty{
                return 0
            }else {
                if viewModel.events.count > 2{
                    return 3
                }else{
                    return viewModel.events.count + 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(with: ViewAllHeaderBtnTVCell.self)
                cell.headerLabel.text = "Categories"
                cell.btnAction = { [weak self] in
                    self?.perfornBtnAction(indexPath.section)
                }
                cell.viewAllBtn.isHidden = viewModel.categories.count < 4
                return cell
            default:
                let cell = tableView.dequeueCell(with: HorizontalCollectionViewTVCell.self)
                cell.dataSource = viewModel.categories
                cell.delegate = self
                return cell
            }
        default:
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueCell(with: ViewAllHeaderBtnTVCell.self)
                cell.headerLabel.text = "Today's Events"
                cell.btnAction = { [weak self] in
                    self?.perfornBtnAction(indexPath.section)
                }
                cell.viewAllBtn.isHidden = viewModel.events.count < 3
                return cell
            default:
                let cell = tableView.dequeueCell(with: FeaturesTVCell.self)
                cell.populateData(viewModel.events[indexPath.item - 1])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row != 0{
            guard CommonFunctions.checkForInternet() else { return }
            let vc = EventGroupListVC.instantiate(fromAppStoryboard: .Home)
            vc.event = viewModel.events[indexPath.row - 1]
            AppRouter.pushViewController(self, vc)
        }
    }
}


extension DiscoverVC : HorizontalCollectionViewDelegate {
    func getSelectedCategory(_ category: Categories) {
        let vc = CategoriesEventListVC.instantiate(fromAppStoryboard: .Home)
        vc.category = category
        AppRouter.pushViewController(self, vc)
    }
}


