//
//  EverythingNewsTableViewCell.swift
//  News
//
//  Created by Khin Phone Ei on 04/02/2023.
//

import UIKit

class EverythingNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var everythingNewsTitle: UILabel!
    @IBOutlet weak var everythingNewsDescription: UILabel!
    @IBOutlet weak var everytingNewsImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        contentView.layer.masksToBounds = true
        everytingNewsImage.layer.cornerRadius = 10
    }
    
    func configEverythingNewsCell(everythingNews: EverythingNews) {
        let url = URL(string: everythingNews.imageURL ?? "https://www.shutterstock.com/image-vector/no-image-available-icon-template-260nw-1036735678.jpg")
        everytingNewsImage.kf.setImage(with: url)
        everythingNewsTitle.text = everythingNews.title
        everythingNewsDescription.text = everythingNews.description
    }
    
}
