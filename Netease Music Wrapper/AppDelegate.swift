//
//  AppDelegate.swift
//  Netease Music Wrapper
//
//  Created by Luo Sheng on 14-8-4.
//  Copyright (c) 2014年 Pop Tap. All rights reserved.
//

import Cocoa
import WebKit

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var webView: WebView!


    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "http://music.163.com")))
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

