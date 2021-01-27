//
//  ViewController.swift
//  Dely
//
//  Created by Ovidiu Lazurca on 10/09/2018.
//  Copyright © 2018 comknow. All rights reserved.
//

import UIKit
import WebKit
import MaterialComponents.MaterialActivityIndicator

class ViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: MDCActivityIndicator!
    @IBOutlet weak var errorView: UIView!
    private var lastLoadedUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor().hexStringToUIColor(hex: "#d05e4b")
        
        activityIndicator.sizeThatFits(activityIndicator.frame.size)
        activityIndicator.cycleColors = [UIColor().hexStringToUIColor(hex: "#d05e4b")]
        activityIndicator.startAnimating()
        
        webView.delegate = self
        webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.dely.ro/?mobile=true")!))
//        webView.loadRequest(URLRequest.init(url: URL.init(string: "https://dev.comknow.com/delywebsite/?mobile=true")!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        lastLoadedUrl = request.url?.absoluteString as String?
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.showLoadingViewAndAnimation()
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.removeViewAndAnimation()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.removeViewAndAnimation()
        
        if let loadedUrl = lastLoadedUrl, loadedUrl.contains("dely.ro") {
            self.showErrorView()
        }
    }
    
    private func showLoadingViewAndAnimation() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.loadingView.alpha = 1.0
        }
    }
    
    private func removeViewAndAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0.0
        }) { (success) in
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func showErrorView() {
        UIView.animate(withDuration: 0.5) {
            self.errorView.alpha = 1.0
        }
    }
    
    private func removeErrorView() {
        UIView.animate(withDuration: 0.5) {
            self.errorView.alpha = 0.0
        }
    }
    
    @IBAction func reloadButton(_ sender: UIButton) {
        if webView.canGoBack || webView.canGoForward {
            webView.reload()
        } else {
            webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.dely.ro/?mobile=true")!))
        }
        self.removeErrorView()
    }
}
