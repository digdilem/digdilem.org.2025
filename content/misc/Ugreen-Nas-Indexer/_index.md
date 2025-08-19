---
date: '2025-08-19T21:03:01+01:00'
draft: false
title: 'Disabling the Ugreen Nas Indexer'
author: Simon Avery
categories: 
  - misc
  - ugreen
  - nas
  - homelab

---

I have a UGREEN NASync DXP2800 NAS. It's very good with some lovely design touches like the toolless caddies that are amongst the best I've ever used, including many enterprise systems. 

But one thing annoys me, and others too, is that it has an inbuilt indexer and thumbnail generator for photos that runs on the files you upload, regardless of whether you want it to, or are even using the bundled Photo software or indexer. Some of use a NAS just to store files for other programs.

The problem with this is if your NAS uses hard drives, then it will cause a lot of activity going on for many hours or days after changes. This causes unneccessary wear on the drives and wastes power when they could have spun down, as well as being annoyingly noisy as the drives click and whirr for ages.

The indexer cannot be disabled through the otherwise very useful web interface, but can be disabled via ssh. Fortunately these Nas's run Linux and the indexing service is a controlled by Systemctl, so can be turned off and disabled like any other linux service. 

> Credit to [/uZealousidealTax8340](https://www.reddit.com/r/UgreenNASync/comments/1dv6wv3/turn_off_indexing_thumbnails/lc0r7it/) for the original method. 

1. Enter the webui for your nas: `IP-ADDRESS:9999`
2. In Control Panel, under `Connections & Access`, select `Terminal`
3. Tick `Enable` under SSH with a `Shut Down automatically` of something like 30 minutes. 
4. Click Apply. 

![alt text](image.png)

5. Now connect to your NAS by SSH. This requires a SSH client like Putty (for Windows) or just "ssh" for linux. (And perhaps Windows CMD). 
6. Log in via SSH using the same username and password you use to log into its Webui

7. Once connected, enter this command. 


```
sudo systemctl disable --now index_serv 
sudo systemctl disable --now thumb_serv
```

*You will be prompted for a password, use the same one you logged in with*

This stops the two services, `index_serv` and `thumb_serv`, and stops them automatically restarting.

#### Note: After a system update, it is likely this service will be re-enabled, so you will need to repeat the above.

### Being more persistent

If you want a more permanent solution, you can also automatically repeat this command every hour. Because this is a linux computer, it comes with cron, the scheduler. 

To do this;

a) SSH into your nas as above. 
b) Become root (we need to run the command as the root user)

```
sudo su -
```

*Enter your password*

c) `crontab -e` 

*You may be prompted to choose an editor, either nano or vi. nano is generally considered easier to use if you're unfamiliar, choose whichever you like. If it doesn't prompt, then it will use Vi*

d) Enter a new line containing this;

```
0 * * * * systemctl disable --now index_serv thumb_serv
```

*This repeats the command at 0 minutes on every hour of every day*

e) Save and quit the editor. 

#### This may still get overwritten by a firmware update of the NAS, in which case you'll have to start over. 

### Being even more persistent

If that doesn't work, then you can mask the services instead. 

```
systemctl mask index_serv thumb_serv
```

This tells systemd to symlink the service's unit file to `/dev/null` and this makes it harder for it to be automatically re-enabled. An `enable` won't work on a masked service. 

However, you can reverse this with `systemctl unmask index_serv thumb_serv` and you will then be allowed to enable and start the services again if you wish.





