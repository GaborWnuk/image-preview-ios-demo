//
//  ArticleWebAsset.swift
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

import Foundation
import UIKit

struct ArticleWebAsset {
  var url: String?
  var b64: String?

  var thumbnail: UIImage? {
    get {
      guard let b64 = self.b64 else {
        return nil
      }

      guard let path = Bundle.main.path(forResource: "source_headers", ofType: "bin") else {
        return nil
      }

      guard let jpeg_header = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        return nil
      }

      let jpeg = NSMutableData(data: jpeg_header)
      let jpeg_body = Data(base64Encoded: b64)
      
      jpeg.append(jpeg_body!)

      return UIImage(data: jpeg as Data)
    }
  }
}
