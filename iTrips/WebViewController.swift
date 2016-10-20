//
//  WebViewController.swift
//  Pulse
//
//  Created by Pavan Gopal on 22/09/16.
//  Copyright © 2016 Pavan Gopal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController ,UIWebViewDelegate{
    @IBOutlet weak var webVIew: UIWebView!
    
    var url : NSURL?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedUrl = url {
            let request = NSURLRequest.init(URL: unwrappedUrl)
            webVIew?.loadRequest(request)
        }
        webVIew.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func dismissController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        LoadingController.instance.showLoadingForSender(self)
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        LoadingController.instance.hideLoadingView()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        let alertController = UIAlertController.init(title: kEmptyString, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
