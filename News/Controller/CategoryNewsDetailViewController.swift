//
//  CategoryNewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 05/02/2023.
//

import UIKit
import ReadabilityKit

class CategoryNewsDetailViewController: UIViewController {
    
    var categoryNews: CategoryNews?
    
    @IBOutlet weak var categoryNewsImage: UIImageView!
    @IBOutlet weak var categoryNewsTitle: UILabel!
    @IBOutlet weak var datePublishedLable: UILabel!
    @IBOutlet weak var contentLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseContent()
        let url = URL(string: categoryNews?.imageURL ?? "")
        categoryNewsImage.kf.setImage(with: url)
        categoryNewsTitle.text = categoryNews?.title
    }

    func parseContent() {
        let articleUrl = URL(string: (self.categoryNews?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublishedLable.text = data?.datePublished
            self.contentLable.text = data?.text ?? "No Context"
        })
    }
}
