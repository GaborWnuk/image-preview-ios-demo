//
//  MainViewController.swift
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

protocol MainViewControllerInput
{
  func displayFetchedArticles(viewModel: Main.FetchArticles.ViewModel)
}

protocol MainViewControllerOutput
{
  func fetchArticles(request: Main.FetchArticles.Request)
}

class MainViewController: UITableViewController, MainViewControllerInput {
  var output: MainViewControllerOutput!
  var router: MainRouter!

  var displayedArticles: [Article] = []

  // MARK: - Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    MainConfigurator.sharedInstance.configure(viewController: self)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.fetchArticlesOnLoad()
  }
  
  // MARK: - Event handling
  
  func fetchArticlesOnLoad()
  {
    let request = Main.FetchArticles.Request()
    self.output.fetchArticles(request: request)
  }
  
  // MARK: - Display logic
  func displayFetchedArticles(viewModel: Main.FetchArticles.ViewModel)
  {
    self.displayedArticles = viewModel.displayedArticles
    DispatchQueue.main.async() { () -> Void in
      self.tableView.reloadData()
    }
  }

  // MARK: Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.displayedArticles.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

    // Configure the cell...
    let article = self.displayedArticles[indexPath.row]
    cell.fillWithData(article: article)

    return cell
  }
}
