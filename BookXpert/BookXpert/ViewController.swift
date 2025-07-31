//
//  ViewController.swift
//  BookXpert
//
//  Created by Shubham  Yerne on 29/07/25.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    var viewModel = NewsViewModel()
    
    private let refreshControl = UIRefreshControl()
    private let searchVC = UISearchController(searchResultsController: nil)

    
    private let newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup() {
        title = "News"
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        configureTableView()
        viewModel.fetchTopBusinessNews()
        createSearchBar()
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    @objc private func didPullToRefresh() {
        viewModel.fetchTopBusinessNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsTableView.frame = view.bounds
    }
    
    private func configureTableView() {
        view.addSubview(newsTableView)
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { fatalError() }
        cell.configure(with: viewModel.newsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension ViewController: NewsViewModelProtocol {
    func reloadData() {
        self.newsTableView.reloadData()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if NetworkMonitor.shared.isConnected {
            viewModel.searchNews(with: text)
        } else {
            viewModel.filterArticlesLocally(by: text)
        }
        searchVC.dismiss(animated: true)
    }
}
