//
//  BookmarkViewController.swift
//  News
//
//  Created by Khin Phone Ei on 07/02/2023.
//

import UIKit
import FirebaseFirestore
import ReadabilityKit

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    var bookmarkedNewsList = [BookmarkNews]()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBookmarkedNews()

        // register table view cell
        let tbcellNib = UINib(nibName: "BookmarkTableViewCell", bundle: nil)
        bookmarkTableView.register(tbcellNib, forCellReuseIdentifier: "BookmarkTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as! BookmarkTableViewCell
        
        cell.configBookmarkNewsCell(bookmarkNews: bookmarkedNewsList[indexPath.row])
        
        return cell
    }
    
    func loadBookmarkedNews() {
        db.collection("bookmark")
            .order(by: Constant.FStore.dateField ,descending: true)
            .addSnapshotListener() { (querySnapshot, err) in
                
                self.bookmarkedNewsList = []
                
                if let e = err {
                    print("There was problem retrieving data from the firestore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let title = data["title"] as? String,
                               let imageURL = data["imageURL"] as? String,
                               let url = data["url"] as? String,
                               let description = data["description"] as? String,
                               let content = data["content"] as? String,
                               let publishedDate = data["publishedDate"] as? String
                            {
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
