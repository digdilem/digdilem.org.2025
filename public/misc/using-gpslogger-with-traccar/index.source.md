---
date: '2025-06-20T14:37:18+01:00'
draft: false
title: 'Using Gpslogger With Traccar'
author: Simon Avery
categories:
  - misc
  - linux
  - gps
weight: 26
---

*Making two excellent pieces of free software talk to each other*

* [Traccar](https://www.traccar.org/) is an amazing piece of free, open source software to track GPS devices and people.
* [GPSLogger](https://gpslogger.app/) is an amazing piece of free software that records GPS tracks on Android very well.

Wouldn't it be nice if you could use GPSLogger to send your position to Traccar? Well, you can, and it's not hard.

#### Why not just use Traccar's Android client? 

A good question, and there's no reason why not. It (usually) works fine. however, I did have a few issues with it that, whilsts not serious, were enough to steer me towards GPSlogger. 

* GPSLogger has more settings for granularity, and those are well documented. 
* One of the devices I was using kept on turning off Traccar-Client and nothing I tried would keep it running for more than an hour.
* I found GPSLogger was better at dropping GPS Jitter reports from the devices. 
* GPSLogger used less battery for me. 
* Traccar has huge support for a great many devices and software. Whilst it doesn't support GPSLogger natively, it does provide a simple webhook for OSMand which is easily used.
* And - critically - I was already using GPSLogger to record GPS tracks whenever I walked or biked somewhere. 

*Please don't think I'm criticising Traccar or Traccar-Client - I'm sure it works great for many people and I love the project*

And one reason not to use GPSLogger: It's no longer published via Google's Play store. So you will need to visit the [website](https://gpslogger.app/) and download the APK to install it. Some people are understandably nervous about doing this, and some phones won't let you do so without a lot of fiddling. Fair enough, and Traccar Client is on Play store.

#### How to get GPSLogger reporting your position to Traccar

*I've been using this method for almost a year with a very good success)

*References:*

* [Traccar documentation for OSMAN type URL paramaters](https://www.traccar.org/osmand/)
* [GPSLogger's parameter reference ](https://gpslogger.app/images/17b.png) [(Parent)](https://gpslogger.app/#morescreenshots)

#### Before you begin

Go to your Traccar website, into `Settings` then `Devices` and make a note of the `Identifier` number for the device you're configuring. This is your `USER-ID` and you'll need it later.  

*If you haven't set up a new Device in Traccar yet, please do so first*

*Steps:*

1. Have a publically accessible URL for your Traccar server.
    *I host Traccar on my private server behind a CGNat, and use a free Cloudflare tunnel to allow remote access to it. Eg: `https://tracserver.domain.com`*

2. Install GPSLogger onto your phone  [Website](https://gpslogger.app/)
    *You can either use FDroid, which also keeps it up to date, or just install the latest APK from the [GPSLogger website]()

    ***Note:** GPSLogger is not on Google's Play store, so you'll need to use FDroid or install manually via APK – see the [GPSLogger site](https://gpslogger.app/) for details*

3. In GPSLogger, tap the 3-line menu top-left to enter settings.

    - Set your **Logging Details** up as you want and then navigate to `Auto Send, email and upload`

    This section should be left unset for Traccar, but if you’re also sending a GPX file to GDrive or elsewhere, you may already have settings here. Just ensure “Custom URL” in this section is *NOT ticked*

    - Return to the GPSLogger settings menu and select `Custom URL`

    - Tick `Log to custom URL`

    - **UNTICK** `Allow Auto Sending`  *(Otherwise it will repeatedly send the same coords to Traccar until it floods out a few hours later)*

    - Also leave `Discard offline locations` *unticked*. This way if your connection fails, GPSlogger will keep recording and send those logs to Traccar once network is restored, so you can a decent history log even offline.

    - In `URL`, put the following, but change two items

        1. **TRACCAR_URL** to the public URL of your Traccar server. If you have a specific port you need to use, specify that after the URL and BEFORE the following slash. Eg: `https://my-traccar-server-mydomain.com:5505/`

        2. The **USER-ID** for your device, as noted earlier. *(Change YOUR_ID to that number)*

```
https://TRACCAR_URL/?id=YOUR_ID&lat=%LAT&lon=%LON&hdop=1&altitude=%ALT&speed=%SPD&batt=%BATT&timestamp=%TIMESTAMP&charge=%ISCHARGING&bearing=%DIR
```
*I find it easiest to copy and paste these to my email client to get them on the phone, then copy and paste into GPSLogger. You can play around with the parameters as per the Parameter guide on GPSLogger and Traccar's sites to change what it sends above, but these are quite comprehensive.*

4. **Important!** Under `HTTP Method` in GPSLogger's Custom URL settings page, **change** this from `GET` to `POST`

5. Back out of the menus and click `Start Logging` in GPSLogger's main page. If everything is good, then you should see your device start to update on the page.

#### Notes and Problems

* GPSLogger shows a small blue circle at the top right of its menu when it’s sending and the device should be updated a few seconds after that, at whatever upload frequency you set.

* Opening GPSLogger's `Log View` page will show you what it's doing. If you see any red lines, something broke. Green lines denote a successful send of coordinates. 

* Traccar's logs are quite useful in debugging any problems - `tail -f /opt/traccar/logs/tracker-server.log`

#### Fine Tuning Things

In GPSLogger's Settings menu, under `Performance` you can make a big difference to battery usage by tuning a few items. These are my suggestions;

* **Logging interval** *(How often GPSLogger sends coordinates to Traccar)* - No less than 10 seconds. 30-60 is a more normal balance for good battery life.

* **Distance filter** *(If GPSLogger detects you've moved less than this distance since it last sent your location to Traccar, it won't send this time - very useful to save it sending pointless updates and wearing down the battery, and it explains that in the Log View.)*  I use `4 meters`.

* **Accuracy filter** *(If GPSLogger has a weak GPS signal that gives a certainty less than this value, it won't send a reading to Traccar this time)*  I set this to `50meters`

* **Duration to match accuracy)** *(How long it takes to get a GPS reading should take less than this)* I set this to `10 seconds` as a good balance to save using too much battery trying to get a fix in a poor signal area.

* Options ON: `Log GPS/GNSS Locations`, `Choose best accuracy in duration`.  Every other option left off, apart from those mentioned.

That's it!  GPSLogger should be sending your device's position every `Logging interval` seconds with a reasonably balance of accuracy and battery life.


