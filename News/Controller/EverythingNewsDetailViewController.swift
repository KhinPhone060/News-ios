//
//  EverythingNewsDetailViewController.swift
//  News
//
//  Created by Khin Phone Ei on 05/02/2023.
//

import UIKit
import ReadabilityKit

class EverythingNewsDetailViewController: UIViewController {
    
    @IBOutlet weak var everythingNewsImage: UIImageView!
    @IBOutlet weak var everythingNewsTitle: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var everythingNews: EverythingNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseContent()
        let url = URL(string: everythingNews?.imageURL ?? "")
        everythingNewsImage.kf.setImage(with: url)
        everythingNewsTitle.text = everythingNews?.title
    }
    
    func parseContent() {
        let articleUrl = URL(string: (self.everythingNews?.url)!)!
        Readability.parse(url: articleUrl, completion: { data in
            self.datePublishedLabel.text = data?.datePublished
            self.contentLabel.text = data?.text ?? "No Context"
        })
    }

}
