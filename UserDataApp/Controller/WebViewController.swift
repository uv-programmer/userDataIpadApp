//
//  WebViewController.swift
//  UserDataApp
//
//  Created by Ajay on 23/02/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    var mobileNumber : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPDF(filename: "")

        // Do any additional setup after loading the view.
    }
    

    func loadPDF(filename: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent("\(mobileNumber!)").appendingPathExtension("pdf")
        let urlRequest = URLRequest(url: url)
        webview.load(urlRequest)
    }

}
