//
//  BookmarkTableViewCell.swift
//  News
//
//  Created by Khin Phone Ei on 07/02/2023.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookmarkNewsTitle: UILabel!
    @IBOutlet weak var bookmarkNewsImage: UIImageView!
    @IBOutlet weak var bookmarkNewsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.layer.masksToBounds = true
        bookmarkNewsImage.layer.cornerRadius = 10
    }
    
    func configBookmarkNewsCell(bookmarkNews: BookmarkNews) {
        let url = URL(string: bookmarkNews.imageURL)
        bookmarkNewsImage.kf.setImage(with: url)
        bookmarkNewsTitle.text = bookmarkNews.title
        bookmarkNewsDescription.text = bookmarkNews.description
    }
    
}
