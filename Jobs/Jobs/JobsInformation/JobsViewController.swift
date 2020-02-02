//
//  ViewController.swift
//  Jobs
//
//  Created by prafull kumar on 1/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit

class JobsViewController: UITableViewController {
    struct Constants {
        static let cellIdentifire = "BaseCell"
        static let footerHeight = 50
        static let footerWidth = 50
    }
    
    lazy var viewModel: JobsInfoViewModel = {
        let viewModel = JobsInfoViewModel()
        viewModel.delegate = self
        return viewModel
    }()
        
    var paginationIndicatorView = UIActivityIndicatorView(frame:CGRect(x: 0,
                                                                       y: 0,
                                                                       width: Constants.footerWidth,
                                                                       height: Constants.footerHeight))

    lazy var activityView: UIActivityIndicatorView = {
       let activityView = UIActivityIndicatorView(style: .large)
       activityView.center = self.view.center
       activityView.startAnimating()
       self.view.addSubview(activityView)
       activityView.isHidden = true
       return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.title = "Jobs"
        self.refreshControl = {
              let control = UIRefreshControl()
              control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
              return control
        }()
        
        self.tableView.tableFooterView = paginationIndicatorView
        viewModel.refreshData(isForceFetch: false)
    }
    
    @objc private func refreshData() {
        viewModel.refreshData(isForceFetch: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifire, for: indexPath)
        let cellViewModel = viewModel.cellViewModel(row: indexPath.row)
        cell.textLabel?.text = cellViewModel.job
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = cellViewModel.salary
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   viewModel.cellCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = JobDetailViewController()
        vc.viewModel = JobDetailViewViewModel(jobDetail: viewModel.jobDataObject(row: indexPath.row))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
           guard viewModel.hasData else { return }
           let height = scrollView.frame.size.height
           let contentYoffset = scrollView.contentOffset.y
           let distanceFromBottom = scrollView.contentSize.height - contentYoffset
           if distanceFromBottom < height {
            paginationIndicatorView.isHidden = false
            paginationIndicatorView.startAnimating()
            self.viewModel.fetchPagination()
           }
    }
    
    private func showLoading() {
        activityView.isHidden = false
    }
    
    private func hideLoading() {
        activityView.isHidden = true
        paginationIndicatorView.isHidden = true
        paginationIndicatorView.startAnimating()
        refreshControl?.endRefreshing()
    }
    
}

extension JobsViewController: JobsViewControllerUpdateDelegate {
    func viewModel(didUpdateState state: ViewModelState) {
        switch state {
        case .loading:
            if !viewModel.hasData { showLoading() }
        case .loadSuccess:
            hideLoading()
            self.tableView.reloadData()
        case .loadFail(let error):
            hideLoading()
            let alert = UIAlertController(title: "Error!",
                                          message: error.errorDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .unknown:
            break 
        }
    }
}
