//
//  NewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 04/02/2023.
//

import UIKit
import ReadabilityKit
import FirebaseAuth
import FirebaseFirestore
import Toast

class BreakingNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var news: BreakingNews?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseContent()
        loadBookmarkIcon()
        
        let url = URL(string: news?.imageURL ?? "")
        newsImage.kf.setImage(with: url)
        newsTitle.text = news?.title
        newsTitle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 30
    }
    
    func parseContent() {
        let articleUrl = URL(string: (self.news?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublished.text = data?.datePublished ?? "No Date Published"
            self.contentLabel.text = data?.text ?? "No Context"
        })
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if Auth.auth().currentUser?.uid != nil{
                        
            db.collection(Constant.FStore.collectionName)
                .whereField(Constant.FStore.newsURL, isEqualTo: news?.url)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if querySnapshot!.documents.count == 0 {
                        
                        //when url is new url added to the firestore
                        if let url = self.news?.url, let user = Auth.auth().currentUser?.email {
                            self.db.collection(Constant.FStore.collectionName).addDocument(data: [
                                Constant.FStore.user: user,
                                Constant.FStore.newsURL: url,
                                Constant.FStore.newsTitle: self.news?.title,
                                Constant.FStore.imageURL: self.news?.imageURL,
                                Constant.FStore.description: self.news?.description,
                                Constant.FStore.content: self.contentLabel.text,
                                Constant.FStore.publishedDate: self.datePublished.text,
                                Constant.FStore.dateField: Date().timeIntervalSince1970
                            ]) { (error) in
                                if let e = error {
                                    print("There was an issue saving data to the firestore, \(e)")
                                } else{
                                    self.saveBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                                    self.view.makeToast("Saved to bookmark list")
                                }
                            }
                        }
                    } else {
                        //remove news from bookmark
                        self.db.collection(Constant.FStore.collectionName)
                            .whereField(Constant.FStore.newsURL, isEqualTo: self.news?.url)
                            .getDocuments() { (querySnapshot, err) in
                                if let e = err {
                                    print("There was problem retrieving data from the firestore \(e)")
                                } else {
                                    for doc in querySnapshot!.documents {
                                        doc.reference.delete()
                                        self.saveBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
                                        self.view.makeToast("Removed from bookmark list")
                                        
                                    }
                                }
                        }

                    }
            }
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: Constant.loginNavigationVC)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        }
    }
    
    func loadBookmarkIcon() {
        db.collection(Constant.FStore.collectionName)
            .whereField(Constant.FStore.newsURL, isEqualTo: news?.url)
            .getDocuments() { querySnapshot, error in
            
            if let e = error {
                print("There was problem retrieving data from the firestore \(e)")
            } else if querySnapshot!.documents.count == 0 {
                print("No documents")
            } else {
                
                DispatchQueue.main.async {
                    self.saveBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
            }
        }
    }
    
}
