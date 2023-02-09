//
//  BookmarkViewController.swift
//  News
//
//  Created by Khin Phone Ei on 07/02/2023.
//

import UIKit
import FirebaseFirestore
import ReadabilityKit
import FirebaseAuth

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    var bookmarkedNewsList = [BookmarkNews]()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBookmarkedNews()

        // register table view cell
        let tbcellNib = UINib(nibName: Constant.bookmarkTableViewCell, bundle: nil)
        bookmarkTableView.register(tbcellNib, forCellReuseIdentifier: Constant.bookmarkTableViewCell)
        
    }
}

//MARK: - UITableView delegate and datasource
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.bookmarkTableViewCell, for: indexPath) as! BookmarkTableViewCell
        
        cell.configBookmarkNewsCell(bookmarkNews: bookmarkedNewsList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if bookmarkedNewsList.count > 0 {
            if let vc = storyboard?.instantiateViewController(withIdentifier: Constant.bookmarkNewsDetailVC) as? BookmarkNewsDetailViewController {
                vc.bookmarkNews = bookmarkedNewsList[indexPath.row]
                tabBarController?.showDetailViewController(vc, sender: self)
            }
        }
    }
}

//MARK: - Data manipulation
extension BookmarkViewController {
    
    func loadBookmarkedNews() {
        db.collection(Constant.FStore.collectionName)
            .order(by: Constant.FStore.dateField ,descending: true)
            .addSnapshotListener() { (querySnapshot, err) in
                
                self.bookmarkedNewsList = []
                
                if let e = err {
                    print("There was problem retrieving data from the firestore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let title = data[Constant.FStore.newsTitle] as? String,
                               let imageURL = data[Constant.FStore.imageURL] as? String,
                               let url = data[Constant.FStore.newsURL] as? String,
                               let description = data[Constant.FStore.description] as? String,
                               let content = data[Constant.FStore.content] as? String,
                               let publishedDate = data[Constant.FStore.content] as? String,
                               let user = data[Constant.FStore.user] as? String
                            {
                                if Auth.auth().currentUser?.email == user {
                                    let newBookmark = BookmarkNews(title: title, imageURL: imageURL, url: url, description: description, content: content, publishedDate: publishedDate)
                                    self.bookmarkedNewsList.append(newBookmark)
                                    
                                    DispatchQueue.main.async {
                                        self.bookmarkTableView.reloadData()
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
    }
}
