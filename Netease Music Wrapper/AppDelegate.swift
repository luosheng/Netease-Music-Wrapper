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
    
    var mediaTap: SPMediaKeyTap!

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "http://music.163.com")))
        
        mediaTap = SPMediaKeyTap(delegate: self)
        mediaTap.startWatchingMediaKeys()
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
        mediaTap.stopWatchingMediaKeys()
    }
    
    override func mediaKeyTap(keyTap: SPMediaKeyTap!, receivedMediaKeyEvent event: NSEvent!) {
        let keyCode = (event.data1 & 0xFFFF0000) >> 16
        let keyFlags = event.data1 & 0x0000FFFF
        let keyPressed = ((keyFlags & 0xFF00) >> 8) == 0xA
        let keyRepeat = keyFlags & 0x1
        
        if keyPressed {
            switch keyCode {
            case Int(NX_KEYTYPE_PLAY):
                webView.windowScriptObject.evaluateWebScript("document.querySelector('.ply').click()")
                return
            case Int(NX_KEYTYPE_FAST):
                webView.windowScriptObject.evaluateWebScript("document.querySelector('.nxt').click()")
                return
            case Int(NX_KEYTYPE_REWIND):
                webView.windowScriptObject.evaluateWebScript("document.querySelector('.prv').click()")
                return
            default:
                return
            }
        }
    }


}

