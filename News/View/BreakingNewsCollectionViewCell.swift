//
//  BreakingNewsCollectionViewCell.swift
//  News
//
//  Created by Khin Phone Ei on 02/02/2023.
//

import UIKit
import Kingfisher

final class BreakingNewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var breakingNewsTitle: UILabel!
    @IBOutlet weak var breakingNewsImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.masksToBounds = true
        breakingNewsImage.layer.cornerRadius = 10
    }
    
    func configCell(news: BreakingNews) {
        let url = URL(string: news.imageURL ?? "")
        breakingNewsImage.kf.setImage(with: url)
        breakingNewsTitle.text = news.title
    }
}
