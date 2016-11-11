//
//  TableViewCell.swift
//  ImagePreviewExample
//
//  Created by Gabor Wnuk on 27/10/2016.
//  Copyright © 2016 Gabor Wnuk. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!

    @IBOutlet weak var articleImageViewBlur: UIVisualEffectView!
    var task: URLSessionTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillWithData(article: Article) {
        self.articleTitle.text = article.title

        if let img = article.img, let url = img.url {

            self.articleImageViewBlur.alpha = 1

            self.articleImageView.image = article.img?.thumbnail

            self.task?.cancel()

            self.task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else { return }

                DispatchQueue.main.async() { () -> Void in
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.articleImageView.image = image
                        self.articleImageViewBlur.alpha = 0
                    })
                }
            }

            self.task?.resume()
        }

    }

}
