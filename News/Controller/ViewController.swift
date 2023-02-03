//
//  ViewController.swift
//  News
//
//  Created by Khin Phone Ei on 02/02/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabBarView: SMTabbar!
    @IBOutlet weak var breakingNewsCollectionView: UICollectionView!
    @IBOutlet weak var categoryNewsTableView: UITableView!
    var newsList = [News]()
    var categoryNewsList = [CategoryNews]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getLatestNews()
        getCategorizedNews(category: "Business")
        
        //register collection view cell
        let cellNib = UINib(nibName: "BreakingNewsCollectionViewCell", bundle: nil)
        breakingNewsCollectionView.register(cellNib, forCellWithReuseIdentifier: "BreakingNewsCollectionViewCell")
        
        //tabbar view
        self.automaticallyAdjustsScrollViewInsets = false
        let categoryList: [String] = ["Business","Entertainment","Science","Health","Sports","Technology"]
        self.tabBarView.buttonWidth = 110
        self.tabBarView.moveDuration = 0.4
        self.tabBarView.fontSize = 16.0
        self.tabBarView.lineHeight = 3
        self.tabBarView.lineWidth = 50
        self.tabBarView.linePosition = .bottom
        self.tabBarView.configureSMTabbar(titleList: categoryList) { index -> (Void) in
            
            //chage the content inside pager
            self.getCategorizedNews(category: categoryList[index])
        }
        
        //register table view cell
        let tbcellNib = UINib(nibName: "CategoryNewsTableViewCell", bundle: nil)
        categoryNewsTableView.register(tbcellNib, forCellReuseIdentifier: "CategoryNewsTableViewCell")
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakingNewsCollectionViewCell", for: indexPath) as! BreakingNewsCollectionViewCell
        cell.configCell(news: self.newsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryNewsTableViewCell", for: indexPath) as! CategoryNewsTableViewCell
        cell.configCategoryNewsCell(categoryNews: self.categoryNewsList[indexPath.row])
        return cell
    }
    
    
    func getLatestNews() {
            let newsService = NewsService()
            newsService.fetchNews(completionHandler: {[weak self] newsList in
                self?.newsList = newsList
                self?.breakingNewsCollectionView.reloadData()
            })
    }
    
    func getCategorizedNews(category:String) {
        let categoryNewsService = CategoryNewsService()
        categoryNewsService.fetchCategoryNews(completionHandler: {[weak self] categoryNewsList in
            self?.categoryNewsList = categoryNewsList
            self?.categoryNewsTableView.reloadData()
        },category: category)
    }
    
}

