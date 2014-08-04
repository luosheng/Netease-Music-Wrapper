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
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
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
    
    // MARK: - SPMediaKeyTap delegate methods
    
    override func mediaKeyTap(keyTap: SPMediaKeyTap!, receivedMediaKeyEvent event: NSEvent!) {
        let keyCode = (event.data1 & 0xFFFF0000) >> 16
        let keyFlags = event.data1 & 0x0000FFFF
        let keyPressed = ((keyFlags & 0xFF00) >> 8) == 0xA
        let keyRepeat = keyFlags & 0x1
        
        if keyPressed {
            switch keyCode {
            case Int(NX_KEYTYPE_PLAY):
                webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.ply').click()")
                return
            case Int(NX_KEYTYPE_FAST):
                webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.nxt').click()")
                return
            case Int(NX_KEYTYPE_REWIND):
                webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.prv').click()")
                return
            default:
                return
            }
        }
    }
    
    // MARK: - Event handlers

    @IBAction func navigateBetweenPages(sender: AnyObject) {
        let segmentedControl = sender as NSSegmentedControl
        switch segmentedControl.selectedSegment {
        case 0:
            webView.goBack()
        case 1:
            webView.goForward()
        default:
            return
        }
    }
    
    // MARK: - WebFrameLoadDelegate
    
    override func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
//        segmentedControl.setEnabled(sender.canGoBack, forSegment: 0)
//        segmentedControl.setEnabled(sender.canGoForward, forSegment: 0)
    }
    
    override func webView(sender: WebView!, didReceiveTitle title: String!, forFrame frame: WebFrame!) {
        window.title = title
        
        let song = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.fc1').innerText")
        let artist = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.by span a').innerText")
        let image = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.head img').src")
        
        if !(song.isEmpty || artist.isEmpty) {
            println("Song: \(song) By: \(artist) Image: \(image)")
            let notification = NSUserNotification()
            notification.title = song
            notification.subtitle = artist
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        }
    }
}

