//
//  CategoryNewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 05/02/2023.
//

import UIKit
import ReadabilityKit

class CategoryNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryNewsImage: UIImageView!
    @IBOutlet weak var categoryNewsTitle: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var categoryNews: CategoryNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseContent()
        
        let url = URL(string: categoryNews?.imageURL ?? "")
        categoryNewsImage.kf.setImage(with: url)
        categoryNewsTitle.text = categoryNews?.title
        categoryNewsTitle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.layer.cornerRadius = 30
    }

    func parseContent() {
        let articleUrl = URL(string: (self.categoryNews?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublishedLabel.text = data?.datePublished
            self.contentLabel.text = data?.text ?? "No Context"
        })
    }
}
