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

    func fillWithData(data: Dictionary<String, AnyObject>) {
        let jpeg = NSMutableData(data: (UIApplication.shared.delegate as! AppDelegate).jpeg_header! as Data)

        //print(jpeg_header;)
        if let title = data["title"] as? String {
            self.articleTitle.text = title
        }

        if let img = data["img"] as? Dictionary<String, AnyObject>, let b64 = img["b64"] as? String, let url = img["url"] as? String {

            self.articleImageViewBlur.alpha = 1

            let jpeg_body = Data(base64Encoded: b64)
            jpeg.append(jpeg_body!)

            let image = UIImage(data: jpeg as Data)

            self.articleImageView.image = image

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
