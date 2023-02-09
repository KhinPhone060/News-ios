//
//  ViewController.swift
//  News
//
//  Created by Khin Phone Ei on 02/02/2023.
//

import UIKit
import SkeletonView

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tabBarView: SMTabbar!
    @IBOutlet weak var breakingNewsCollectionView: UICollectionView!
    @IBOutlet weak var categoryNewsTableView: UITableView!
    
    var newsList = [BreakingNews]()
    var categoryNewsList = [CategoryNews]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let targetVC = segue.destination as? BreakingNewsDetailViewController,
           let news = sender as? BreakingNews {
            targetVC.news = news
        }
        
        if let categoryNewsDetailVC = segue.destination as? CategoryNewsDetailViewController,
           let categoryNews = sender as? CategoryNews {
            categoryNewsDetailVC.categoryNews = categoryNews
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCategorizedNews(category: "Business")

        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.getLatestNews()
            self.breakingNewsCollectionView.stopSkeletonAnimation()
            self.breakingNewsCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            self.breakingNewsCollectionView.reloadData()
        }
        
        //register collection view cell
        let cellNib = UINib(nibName: "BreakingNewsCollectionViewCell", bundle: nil)
        breakingNewsCollectionView.register(cellNib, forCellWithReuseIdentifier: "BreakingNewsCollectionViewCell")
        
        //register table view cell
        let tbcellNib = UINib(nibName: "CategoryNewsTableViewCell", bundle: nil)
        categoryNewsTableView.register(tbcellNib, forCellReuseIdentifier: "CategoryNewsTableViewCell")
        
        //tabbar view configuration
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        breakingNewsCollectionView.showAnimatedGradientSkeleton()
    }
}

//MARK: - UICollectionView delegate and datasource
extension HomeViewController: UICollectionViewDelegate,SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "BreakingNewsCollectionViewCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakingNewsCollectionViewCell", for: indexPath) as! BreakingNewsCollectionViewCell
        cell.configCell(news: self.newsList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if newsList.count > 0 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "showNewsDetail") as? BreakingNewsDetailViewController {
                vc.news = newsList[indexPath.row]
                tabBarController?.showDetailViewController(vc, sender: self)
            }
        }
    }
}

//MARK: - UITableView delegate and datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryNewsTableViewCell", for: indexPath) as! CategoryNewsTableViewCell
        cell.configCategoryNewsCell(categoryNews: self.categoryNewsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newsList.count > 0 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "showCategoryNewsDetail") as? CategoryNewsDetailViewController {
                vc.categoryNews = categoryNewsList[indexPath.row]
                tabBarController?.showDetailViewController(vc, sender: self)
            }
        }
    }
}

//MARK: - Data manipulation
extension HomeViewController {
    
    func getLatestNews() {
            let newsService = NewsService()
            newsService.fetchNews(completionHandler: {[weak self] newsList in
                self?.newsList = newsList
                self?.breakingNewsCollectionView.reloadData()
            })
    }

    func getCategorizedNews(category:String) {
        self.categoryNewsList = []
        let categoryNewsService = CategoryNewsService()
        categoryNewsService.fetchCategoryNews(completionHandler: {[weak self] categoryNewsList in
            self?.categoryNewsList = categoryNewsList
            self?.categoryNewsTableView.reloadData()
        },category: category)
    }
}

