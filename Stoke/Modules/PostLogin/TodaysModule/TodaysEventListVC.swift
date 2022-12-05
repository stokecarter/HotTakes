//
//  TodaysEventListVC.swift
//  Stoke
//
//  Created by Admin on 18/03/21.
//

import UIKit

class TodaysEventListVC: BaseVC {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshController = UIRefreshControl()
    var viewModel:DayEventsListVM!
    var type:EventType = .upcoming
    var sort:SortingBy = .time
    var category:Categories?
    var startDate:Double?
    var isTodays:Bool = true
    var dayString:String = ""
    var dataSource:[Event] = []
    var isFeatured:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(with: FeaturesTVCell.self)
        viewModel = DayEventsListVM(NetworkLayer(), isTodays: isTodays, sd: startDate)
        viewModel.category = category
        viewModel.sort = sort
        viewModel.type = type
        viewModel.isFeatured = isFeatured
        if isTodays{
            viewModel.hitTodaysEvents()
        }else{
            viewModel.hitForSpecificDay()
            
        }
        viewModel.notify = { [weak self] in
            self?.dataSource = self?.viewModel.dataSource ?? []
            self?.tableView.reloadData()
        }
    }
    
    override func initalSetup() {
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        var t = ""
        if isTodays{
            t = "Today’s Events"
        }else{
            t = dayString
        }
        setNavigationBar(title: t, backButton: true)
        addRightButtonToNavigation()
    }
    
    override func rightBarButtonTapped(_ sender: UIButton) {
        let vc = EventFilterVC.instantiate(fromAppStoryboard: .Home)
        vc.modalTransitionStyle = .coverVertical
        vc.sortedBy = sort
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }
    
    private func addPullToRefresh(){
        refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    @objc func refresh(){
        tableView.reloadData()
        refreshController.endRefreshing()
    }
    
}


extension TodaysEventListVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: FeaturesTVCell.self)
        cell.populateData(dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EventGroupListVC.instantiate(fromAppStoryboard: .Home)
        vc.event = dataSource[indexPath.row]
        AppRouter.pushViewController(self, vc)
    }
}

extension TodaysEventListVC : EventFilterDelegate{
    func getFilterType(_ type: SortingBy) {
        sort = type
        viewModel.sort = sort
        if isTodays{
            viewModel.hitTodaysEvents()
        }else{
            viewModel.hitForSpecificDay()
        }
    }
}
