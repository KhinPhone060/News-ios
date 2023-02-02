//
//  ViewController.swift
//  News
//
//  Created by Khin Phone Ei on 02/02/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var breakingNewsCollectionView: UICollectionView!
    var newsList = [News]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getLatestNews()
        
        //register cell
        let cellNib = UINib(nibName: "BreakingNewsCollectionViewCell", bundle: nil)
        breakingNewsCollectionView.register(cellNib, forCellWithReuseIdentifier: "BreakingNewsCollectionViewCell")
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakingNewsCollectionViewCell", for: indexPath) as! BreakingNewsCollectionViewCell
        cell.configCell(news: self.newsList[indexPath.row])
        return cell
    }
    
    func getLatestNews() {
            let newsService = NewsService()
            newsService.fetchNews(completionHandler: {[weak self] newsList in
                self?.newsList = newsList
                self?.breakingNewsCollectionView.reloadData()
            })
    }
    
}

