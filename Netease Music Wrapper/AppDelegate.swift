//
//  AppDelegate.swift
//  Netease Music Wrapper
//
//  Created by Luo Sheng on 14-8-4.
//  Copyright (c) 2014年 Pop Tap. All rights reserved.
//

import Cocoa
import WebKit

class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
                            
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var webView: WebView!
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    var mediaTap: SPMediaKeyTap!
    
    let albumSize = 200

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "http://music.163.com")))
        
        mediaTap = SPMediaKeyTap(delegate: self)
        mediaTap.startWatchingMediaKeys()
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
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
        segmentedControl.setEnabled(sender.canGoBack, forSegment: 0)
        segmentedControl.setEnabled(sender.canGoForward, forSegment: 1)
    }
    
    override func webView(sender: WebView!, didChangeLocationWithinPageForFrame frame: WebFrame!) {
        segmentedControl.setEnabled(sender.canGoBack, forSegment: 0)
        segmentedControl.setEnabled(sender.canGoForward, forSegment: 1)
    }
    
    override func webView(sender: WebView!, didReceiveTitle title: String!, forFrame frame: WebFrame!) {
        window.title = title
        
        let song = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.fc1').innerText")
        let artist = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.by span a').innerText")
        let imageURLString = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.head img').src")
        let songSrc = webView.stringByEvaluatingJavaScriptFromString("document.querySelector('.src').href")
        
        if !(song.isEmpty || artist.isEmpty) {
            println("Song: \(song) By: \(artist) Image: \(imageURLString)")
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                let imageURL = NSURL(string: imageURLString)
                let hdImageURL = NSURL(scheme: imageURL.scheme, host: imageURL.host, path: "\(imageURL.path)?param=\(self.albumSize)x\(self.albumSize)")
                let image = NSImage(contentsOfURL: hdImageURL)
                
                let displayScale = NSScreen.mainScreen().backingScaleFactor
                
                image.size = NSSize(width: CGFloat(self.albumSize) / displayScale, height: CGFloat(self.albumSize) / displayScale)
                
                let notification = NSUserNotification()
                notification.title = song
                notification.subtitle = artist
                notification.contentImage = image
                notification.userInfo = ["URL": songSrc]
                
                dispatch_async(dispatch_get_main_queue(), {
                    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
                })
            })
        }
    }
    
    // MARK: - NSUserNotificationCenterDelegate
    
    func userNotificationCenter(center: NSUserNotificationCenter!, didActivateNotification notification: NSUserNotification!) {
        if let URLString: AnyObject = notification.userInfo["URL"] {
            let URL = NSURL(string: URLString as? String)
            NSWorkspace.sharedWorkspace().openURL(URL)
        }
    }
}

