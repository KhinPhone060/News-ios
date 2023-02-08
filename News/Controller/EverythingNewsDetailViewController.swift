//
//  EverythingNewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 05/02/2023.
//

import UIKit
import ReadabilityKit
import FirebaseAuth
import FirebaseFirestore
import Toast

class EverythingNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var everythingNewsImage: UIImageView!
    @IBOutlet weak var everythingNewsTitle: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var everythingNews: EverythingNews?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseContent()
        loadBookmarkIcon()
        
        let url = URL(string: everythingNews?.imageURL ?? "")
        everythingNewsImage.kf.setImage(with: url)
        everythingNewsTitle.text = everythingNews?.title
        everythingNewsTitle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 30
    }
    
    func parseContent() {
        let articleUrl = URL(string: (self.everythingNews?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublishedLabel.text = data?.datePublished ?? "No published date"
            self.contentLabel.text = data?.text ?? "No Context"
        })
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if Auth.auth().currentUser?.uid != nil{
                        
            db.collection("bookmark").whereField("url", isEqualTo: everythingNews?.url)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if querySnapshot!.documents.count == 0 {
                        
                        //when url is new url added to the firestore
                        if let url = self.everythingNews?.url, let user = Auth.auth().currentUser?.email {
                            self.db.collection(Constant.FStore.collectionName).addDocument(data: [
                                Constant.FStore.user: user,
                                Constant.FStore.newsURL: url,
                                Constant.FStore.newsTitle: self.everythingNews?.title,
                                Constant.FStore.imageURL: self.everythingNews?.imageURL,
                                Constant.FStore.description: self.everythingNews?.description,
                                Constant.FStore.content: self.contentLabel.text,
                                Constant.FStore.publishedDate: self.datePublishedLabel.text,
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
                        self.db.collection("bookmark")
                            .whereField("url", isEqualTo: self.everythingNews?.url)
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
                let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        }
    }
    
    func loadBookmarkIcon() {
        db.collection("bookmark")
            .whereField("url", isEqualTo: everythingNews?.url)
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
