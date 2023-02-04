//
//  SearchViewController.swift
//  News
//
//  Created by Khin Phone Ei on 04/02/2023.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var everythingNewsList = [EverythingNews]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register cell
        let tbcellNib = UINib(nibName: "EverythingNewsTableViewCell", bundle: nil)
        searchTableView.register(tbcellNib, forCellReuseIdentifier: "EverythingNewsTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return everythingNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EverythingNewsTableViewCell", for: indexPath) as! EverythingNewsTableViewCell
        cell.configEverythingNewsCell(everythingNews: self.everythingNewsList[indexPath.row])
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        getEverythingNews(searchKeyword: searchBar.text!)
    }
    
    func getEverythingNews(searchKeyword: String) {
            let everythingNewsService = EverythingNewsService()
            everythingNewsService.fetchEverythingNews(completionHandler: {[weak self] everytingNewsList in
                self?.everythingNewsList = everytingNewsList
                self?.searchTableView.reloadData()
            },keyword: searchKeyword)
    }
    
}
