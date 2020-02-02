//
//  JobDetailViewController.swift
//  Jobs
//
//  Created by prafull kumar on 2/2/20.
//  Copyright © 2020 prafull kumar. All rights reserved.
//

import UIKit
import SafariServices

class JobDetailViewController: UIViewController {
    
    var viewModel: JobDetailViewViewModel!
    
    lazy var scrollableStackView: ScrollableStackView = {
        let scrollableStackView = ScrollableStackView.init(frame: CGRect.zero)
        self.view.addSubview(scrollableStackView)
        scrollableStackView.stackView.distribution = .fillProportionally
        scrollableStackView.stackView.alignment = .center
        scrollableStackView.scrollView.showsVerticalScrollIndicator = false
        scrollableStackView.scrollView.alwaysBounceVertical = false
        scrollableStackView.bindFrameTo(view: self.view)
        scrollableStackView.scrollView.contentInset = UIEdgeInsets(top: ScrollableStackView.Constants.topPadding, left: 0, bottom: 0, right: 0)
        return scrollableStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.title = viewModel.title
        
        scrollableStackView.loadLabel(withString: "Vacancy Count: \(viewModel.numberOfVac)",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        
        scrollableStackView.loadLabel(withString: "Qualification:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.qualifications)
            
        scrollableStackView.loadLabel(withString: "Salary:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.salary)
        
        scrollableStackView.loadLabel(withString: "Process:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.process)
        
        scrollableStackView.loadLabel(withString: "Detail:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.detail)
        
        scrollableStackView.loadLabel(withString: "About:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.about)
        
        
        scrollableStackView.loadLabel(withString: "Office Name:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.officeName)
        
        scrollableStackView.loadLabel(withString: "Address:",  font: UIFont.systemFont(ofSize: 24, weight: .bold))
        scrollableStackView.loadLabel(withString: viewModel.address)
        
        if viewModel.pageURL != nil {
            scrollableStackView.loadFloatingButton(buttonTitle: "Open WebPage", selector: #selector(openWebPage), target: self)
        }
    }
    
    @objc func openWebPage() {
        guard let urlString = viewModel.pageURL, let url = URL.init(string: urlString)  else {
            return
        }
        
        let webVC = SFSafariViewController(url: url)
        self.present(webVC, animated: true)
    }

}
