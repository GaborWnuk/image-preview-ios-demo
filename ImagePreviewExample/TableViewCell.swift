//
//  TableViewCell.swift
//  ImagePreviewExample
//
//  MIT License
//
//  Copyright (c) 2016 Gabor Wnuk
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
