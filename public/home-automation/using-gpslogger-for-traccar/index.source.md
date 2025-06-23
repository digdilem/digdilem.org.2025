---
date: '2025-06-16T13:37:52+01:00'
draft: false
title: 'Using Gpslogger for Traccar'
author: Simon Avery
categories:
  - traccar
  - home automation
  

---

[Traccar](https://www.traccar.org/) is an amazing piece of free, open source software to track GPS devices and people.

However, I had trouble getting accurate results through its Traccar Client Android app – it would report positions miles away from where I was, and a journey was logged with very strange results indeed. However, GPSLogger already running on the same device was extremely accurate.

* *I've since learned that changing Traccar's client to 'High Sensitivity' does fix most of the inaccuracies, but I still preferred GPSLogger which could also record a local GPX and upload to Gdrive at the same time*

I decided to use GPSLogger's Custom URL feature to use that to update Traccar, and skip using the dedicated client entirely. This also meant one less app running on my phone, as I use GPSLogger to automatically create GPX files of my journeys.

So – how to use GPSLogger to report your position to your own Traccar server. I found this to be very accurate and well behaved.

### References:

* [Traccar documentation for OSMAN type URL paramaters](https://www.traccar.org/osmand/)
* [GPSLogger's parameter reference (Parent)](https://gpslogger.app/images/17b.png)

### Steps:

1. Have a publically accessible URL for your Traccar server.
    *I host Traccar on my private server behind a CGNat, and use a free Cloudflare tunnel to allow remote access to it. 
    Eg: `https://tracserver.domain.com`*

2. Install GPSLogger onto your phone
    Note: It's not on play.com, so you'll need to use [FDroid](https://f-droid.org/packages/com.mendhak.gpslogger/) or [install manually via APK](https://github.com/mendhak/gpslogger/) – see the [GPSLogger site](https://gpslogger.app/) for details

3. In GPSLogger, Set your Logging Details up as you want and then navigate to `Auto Send, email and upload`

4. This section should be left unset for Traccar, but if you're also sending a GPX file to GDrive or elsewhere, you may already have settings here. Just ensure `Custom URL` in this section is NOT ticked.

5. Return to the GPSLogger setting menu and select `Custom URL`

6. Tick `Log to custom URL`

7. UNTICK `Allow Auto Sending` (otherwise it will repeatedly send the same coords to traccar until it floods out a few hours later)

8. Also leave `Discard offline locations` unticked. This way if your connection fails, GPSlogger will keep recording and send those logs to Traccar once network is restored, so you can a decent history log even offline.

9. In `URL`, put the following, but change

    a) **TRACCAR_URL** to your public URL. If you have a specific port you need to use, specify that after the URL and BEFORE the following slash. Eg: `…COM:5505/`
    
    b) The **ID** to match the ID of your user in Traccar. (Change YOUR_ID to that number)

    `https://TRACCAR_URL/?id=YOUR_ID&lat=%LAT&lon=%LON&hdop=1&altitude=%ALT&speed=%SPD&batt=%BATT&timestamp=%TIMESTAMP&charge=%ISCHARGING&bearing=%DIR`

    You can play around with the parameters as per the references above.

10. Important! Under `HTTP Method`, set this from `GET` to `POST`

11. Back out and click `Start Logging`. If everything is good, then you should see GPSLogger issuing http requests in its Logging page. Soon after, you'll see your device start to update on the Traccar map.

* GPSLogger shows a small blue circle at the top right of its menu when it's sending and the device should be updated a few seconds after that, at whatever upload frequency you set.
* You can also watch the logs in Traccar on the server by doing something like: `tail -f /opt/traccar/logs/tracker-server.log`

