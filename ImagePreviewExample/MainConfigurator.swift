//
//  MainConfigurator.swift
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

// MARK: - Connect View, Interactor, and Presenter

extension MainViewController: MainPresenterOutput {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }
}

extension MainInteractor: MainViewControllerOutput {
}

extension MainPresenter: MainInteractorOutput {
}

class MainConfigurator {
  // MARK: - Object lifecycle
  
  static let sharedInstance = MainConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: MainViewController)
  {
    let router = MainRouter()
    router.viewController = viewController
    
    let presenter = MainPresenter()
    presenter.output = viewController
    
    let interactor = MainInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
