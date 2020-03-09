//
//  HomeDetailViewController.swift
//  WeedmapsChallenge
//
//  Created by Perez Willie-Nwobu on 3/7/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class HomeDetailViewController: UIViewController {
    
    var urlToOpen: URL? {
        didSet {
            loadViewIfNeeded()
            guard let url = urlToOpen else { return }
            webView.load(URLRequest(url: url))
        }
    }
    @IBOutlet weak var webView: WKWebView!
}
