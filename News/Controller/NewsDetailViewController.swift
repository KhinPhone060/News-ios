//
//  NewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 04/02/2023.
//

import UIKit
import ReadabilityKit

class NewsDetailViewController: UIViewController {
    
    var news: News?
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseContent()
        let url = URL(string: news?.imageURL ?? "")
        newsImage.kf.setImage(with: url)
        newsTitle.text = news?.title
    }
    
    func parseContent() {
        let articleUrl = URL(string: (self.news?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublished.text = data?.datePublished
            self.contentLabel.text = data?.text ?? "No Context"
        })
    }
}