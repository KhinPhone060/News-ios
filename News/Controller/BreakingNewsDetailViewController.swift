//
//  NewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 04/02/2023.
//

import UIKit
import ReadabilityKit

class BreakingNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var news: BreakingNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseContent()
        
        let url = URL(string: news?.imageURL ?? "")
        newsImage.kf.setImage(with: url)
        newsTitle.text = news?.title
        newsTitle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 30
    }
    
    func parseContent() {
        let articleUrl = URL(string: (self.news?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublished.text = data?.datePublished
            self.contentLabel.text = data?.text ?? "No Context"
        })
    }
}
