# Netease-Music-Wrapper

This is just a simple WebKit wrapper around [Netease Music](http://music.163.com).

## What it can do

* Capture the media keys to allow you control your music playlist with your keyboard. (Previous, Play / Pause, Next)
* Popup a notification showing which song is being played. (Code-signing required to present as banner.)
* Redirect you to the website upon click on the notification.

## What it can't do, yet

* Login with Sina Weibo or Tencent Weibo. However it does share the same cookies with Safari so you can login on your Safari first anyway.

This project is not related to Netease. I'm guessing from [this commit](https://github.com/nevyn/SPMediaKeyTap/commit/eba171809994ca09458c24c1356ece69d42c8b82) that Netease is making an OS X client of their own. You are welcome to pick up this while waiting for the official one.