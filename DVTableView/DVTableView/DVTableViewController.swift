//
//  DVTableViewController.swift
//  DVTableView
//
//  Created by Nam Vu on 11/15/18.
//  Copyright © 2018 Nam Vu. All rights reserved.
//

import UIKit

#if canImport(Alamofire)
import Alamofire
#endif

/// Change UITableView load more type to choose how to load more in DVTableView
///
/// - automatic: Trigger loadMore function when reach last item
/// - required: Trigger loadMore function when user swipe up at DVTableView bottom
enum LoadMoreType {
    case automatic
    case required
}

class DVTableViewController<T: DVGenericCell<U>, U>: UITableViewController {
    /// Change UITableView load more type to choose how to load more in DVTableView.
    /// Default is `automatic`.
    var loadMoreType = LoadMoreType.automatic
    
    private(set) var items = [U]()
    private(set) var noDataView: UIView!
    
    private var errorLabel: UILabel!
    private var alertView: UIView!
    private var alertLabel: UILabel!
    private var alertViewTopConstraint: NSLayoutConstraint!
    
    private let reuseIdentifier = "cell"
    
    #if canImport(Alamofire)
    /// Determine if user want to show reachability status in this view controller.
    /// Default value is `true`.
    var enableReachability = true
    
    /// Show connection available when load view the first time.
    /// Default value is `false`
    var alwaysShowReachabilityAlert = false
    private let noInternetText = "No internet connection."
    private let internetAvailableText = "Internet is now available."
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        #if canImport(Alamofire)
        if enableReachability {
            ReachableManager.sharedInstance.startListening()
            NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkAvailable), name: Notification.Name("networkReachable"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkUnavailable), name: Notification.Name("networkNotReachable"), object: nil)
        }
        #endif
        
        reloadData()
    }
    
    deinit {
        #if canImport(Alamofire)
        ReachableManager.sharedInstance.stopListening()
        NotificationCenter.default.removeObserver(self)
        #endif
        print("Deinit DVTableViewController")
    }
    
    // MARK: - Public functions
    
    /// Reset all datasource.
    ///
    /// - Parameter data: New data
    func setData(_ data: [U]) {
        items = data
        reloadData()
    }
    
    /// Append more data to current datasource
    ///
    /// - Parameter data: New data
    func appendData(_ data: [U]) {
        items.append(contentsOf: data)
        reloadData()
    }
    
    /// Custom noDataView (view will be shown when datasource is empty)
    ///
    /// - Parameter view: Customized view
    func setNoDataView(_ view: UIView) {
        noDataView = view
        //Set tag to seperate from case noDataView is manually generated.
        noDataView.tag = 2
        addNoDataView()
    }
    
    func setRefreshControl(_ view: UIView) {
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
        }
        view.frame = refreshControl!.bounds
        refreshControl?.addSubview(view)
    }
    
    // MARK: - UI
    private func initUI() {
        view.backgroundColor = .white
        
        if refreshControl == nil {
            refreshControl = UIRefreshControl()
        }
        refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(T.self, forCellReuseIdentifier: reuseIdentifier)
        
        addNoDataView()
        
        #if canImport(Alamofire)
        addAlertView()
        #endif
    }
    
    private func addNoDataView() {
        if noDataView == nil || noDataView.tag != 2 {
            noDataView = UIView()
            //Set tag to seperate from case noDataView is set.
            noDataView.tag = 1
        }
        constraintsNoDataView()
        
        // Check if noDataView is manually generated
        if noDataView.tag == 1 {
            addDefautNoDataView()
        }
    }
    
    private func constraintsNoDataView() {
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataView)
        
        let centerVertical = noDataView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        let leading = noDataView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailing = noDataView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        NSLayoutConstraint.activate([centerVertical, leading, trailing])
    }
    
    private func addDefautNoDataView() {
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "No Data."
        errorLabel.textColor = .red
        errorLabel.font = UIFont.boldSystemFont(ofSize: 17)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        noDataView.addSubview(errorLabel)
        
        let leading = errorLabel.leadingAnchor.constraint(equalTo: noDataView.leadingAnchor, constant: 8)
        let trailing = errorLabel.trailingAnchor.constraint(equalTo: noDataView.trailingAnchor, constant: 8)
        let top = errorLabel.topAnchor.constraint(equalTo: noDataView.topAnchor, constant: 0)
        let bottom = errorLabel.bottomAnchor.constraint(equalTo: noDataView.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    private func reloadData() {
        noDataView.isHidden = items.count > 0
        tableView.tableFooterView?.isHidden = true
        tableView.reloadData()
    }
    
    // MARK: - Reachability
    #if canImport(Alamofire)
    @objc private func handleNetworkAvailable() {
        showInternetAvailableAlert()
    }
    
    @objc private func handleNetworkUnavailable() {
        showInternetErrorAlert()
    }
    
    private func addAlertView() {
        alertView = UIView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = .gray
        alertView.layer.zPosition += 1
        view.addSubview(alertView)
        
        alertViewTopConstraint = alertView.topAnchor.constraint(equalTo: view.topAnchor, constant: -40)
        let leading = alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        let height = alertView.heightAnchor.constraint(equalToConstant: 40)
        
        alertLabel = UILabel()
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(alertLabel)
        
        let centerY = alertLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
        let centerX = alertLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor)
        
        NSLayoutConstraint.activate([alertViewTopConstraint, leading, trailing, height,
                                     centerX, centerY])
    }
    
    private func showInternetErrorAlert() {
        alertLabel.text = noInternetText
        alertLabel.textColor = .red
        
        showAlertView()
    }
    
    private func showInternetAvailableAlert() {
        if alertLabel.text == nil && !alwaysShowReachabilityAlert {
            return
        }
        
        alertLabel.text = internetAvailableText
        alertLabel.textColor = .green
        
        showAlertView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hideAlertView()
        }
    }
    
    private func showAlertView() {
        if alertViewTopConstraint.constant == 0 {
            alertViewTopConstraint.constant = -40
        }
        alertViewTopConstraint.constant = 0
        updateConstraints()
    }
    
    private func hideAlertView() {
        self.alertViewTopConstraint.constant = -40
        updateConstraints()
    }
    
    private func updateConstraints() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    #endif
    
    // MARK: - Refresh/Load more
    @objc func onRefresh() {
        tableView.refreshControl?.endRefreshing()
    }
    
    func loadMore() {
        
    }
    
    private func addLoadMoreSpinner(inputView: UIView? = nil) {
        if let inputView = inputView {
            tableView.tableFooterView = inputView
            tableView.tableFooterView?.isHidden = false
            return
        }
        
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    //MARK: - UITableViewDatasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DVGenericCell<U>
        let row = indexPath.row
        cell.item = items[row]
        
        if loadMoreType == .automatic {
            if row == items.count - 1 {
                addLoadMoreSpinner()
                loadMore()
            }
        }
        return cell
    }
    
    // MARK: - ScrollView Delegate
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if loadMoreType == .required {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0 {
                loadMore()
            }
        }
    }
    
    // MARK: - Header Footer
    private(set) var headerView: UITableViewHeaderFooterView!
    private(set) var footerView: UITableViewHeaderFooterView!
    private var headerHeight: CGFloat = 0
    private var footerHeight: CGFloat = 0
    
    /// Set custom headerView with height.
    ///
    /// - Parameters:
    ///   - view: Custom View
    ///   - height: Desired headerView height. Default is 30.
    func setHeaderView<T: UITableViewHeaderFooterView>(withView view: T, height: CGFloat = 30) {
        guard let identifier = view.reuseIdentifier else { return }
        headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T ?? view
        headerHeight = height
    }
    
    /// Set custom footerView with height.
    ///
    /// - Parameters:
    ///   - view: Custom View
    ///   - height: Desired footerView height. Default is 30.
    func setFooterView<T: UITableViewHeaderFooterView>(withView view: T, height: CGFloat = 30) {
        guard let identifier = view.reuseIdentifier else { return }
        footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T ?? view
        footerHeight = height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView == nil ? 0 : headerHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerView == nil ? 0 : footerHeight
    }
}

class DVGenericCell<U>: UITableViewCell {
    var item: U!
}
