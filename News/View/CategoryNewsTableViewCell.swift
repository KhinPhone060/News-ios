//
//  CategoryNewsTableViewCell.swift
//  News
//
//  Created by Khin Phone Ei on 03/02/2023.
//

import UIKit

class CategoryNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNewsImage: UIImageView!
    @IBOutlet weak var categoryNewsTitle: UILabel!
    @IBOutlet weak var categoryNewsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.layer.masksToBounds = true
        categoryNewsImage.layer.cornerRadius = 10
    }
    
    func configCategoryNewsCell(categoryNews: CategoryNews) {
        let url = URL(string: categoryNews.imageURL ?? "https://www.shutterstock.com/image-vector/no-image-available-icon-template-260nw-1036735678.jpg")
        categoryNewsImage.kf.setImage(with: url)
        categoryNewsTitle.text = categoryNews.title
        categoryNewsDescription.text = categoryNews.description
    }
    
}
