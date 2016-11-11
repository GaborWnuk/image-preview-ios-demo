//
//  TableViewController.swift
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

class TableViewController: UITableViewController {

    var articles: Array<Dictionary<String, AnyObject>> = []

    var current_page: Int = 0
    var is_fetching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: "refresh", for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.fetch(page: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - API Communication
    func refresh() {
        self.articles = []
        self.fetch(page: 0)
    }

    func fetch(page: Int) {
        if self.is_fetching {
            return
        }

        self.is_fetching = true

        let body = ["query" : "{ articles(cid: 0, t:[Article], offset: \(page * 25) ) { title url img { url b64 } } }"]

        print(body)

        let url = URL(string: "https://mobileapi.wp.pl/v1/graphql")!
        let request = NSMutableURLRequest(url: url)

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! Dictionary<String, AnyObject>

                if let graph_data = json["data"] as? Dictionary<String, AnyObject> {
                    self.articles += graph_data["articles"] as! Array<Dictionary<String, AnyObject>>
                }

                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                self.current_page = page
                self.refreshControl?.endRefreshing()

                DispatchQueue.main.async() { () -> Void in
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }

            self.is_fetching = false
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        let data = self.articles[indexPath.row]
        cell.fillWithData(data: data)

        return cell
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - 2*scrollView.frame.height {
            self.fetch(page: self.current_page + 1)
        }
    }

    // MARK: - Scroll view delegate


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
