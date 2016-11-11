//
//  ArticlesAPI.swift
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

class ArticlesAPI: ArticlesStoreProtocol
{
  // MARK: - CRUD operations - Optional error
  func fetchArticles(completionHandler: @escaping ([Article], ArticlesStoreError?) -> Void) {
    //

    let body = ["query" : "{ articles: articles(cid: 0, t:[Article], offset: 0 ) { title url img { url b64 } } }"]

    let url = URL(string: "https://mobileapi.wp.pl/v1/graphql")!
    let request = NSMutableURLRequest(url: url)

    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
      do {
        var articles: [Article] = []
        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! Dictionary<String, AnyObject>

        if let graph_data = json["data"] as? Dictionary<String, AnyObject>, let graph_articles = graph_data["articles"] as? Array<Dictionary<String, AnyObject>> {
          for graph_article in graph_articles {

            var img: ArticleWebAsset? = nil

            if let graph_img = graph_article["img"] as? Dictionary<String, AnyObject> {
              img = ArticleWebAsset(url: graph_img["url"] as? String, b64: graph_img["b64"] as? String)
            }

            articles.append(Article(title: graph_article["title"] as? String, img: img))
          }

          completionHandler(articles, nil)
        }

      } catch {
        completionHandler([], ArticlesStoreError.CannotFetch("Incorrect structure."))
      }
    }
    task.resume()

  }

}
