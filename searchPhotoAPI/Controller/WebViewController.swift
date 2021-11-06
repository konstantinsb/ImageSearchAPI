//
//  WebViewController.swift
//  searchPhotoAPI
//
//  Created by admin on 11/1/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var labelOutlet: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    var outletLabel = ""
    var textOpenSource = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

        guard let url = URL(string: textOpenSource) else { return }
        webView.load(URLRequest( url: url))
        
        }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         webView.evaluateJavaScript("logItems()") { _, _ in
         webView.evaluateJavaScript("document.body.innerHTML") { result, _ in
            self.outletLabel = result as! String
            self.labelOutlet.text = self.outletLabel
            print(result!)
              }
         }
    }
}
        
       



