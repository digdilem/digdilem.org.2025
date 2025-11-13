---
date: '2025-06-16T12:53:19+01:00'
draft: false
title: 'Backing Up Important Data'
author: Simon Avery
categories:
  - sysadmin  
  - backups

---

Backing up your important data is essential. I've built many systems over the years, and this is one system that I'm currently using, having thought a great deal about it. It may not be what you need, but this may be worth reading as the core concepts are pretty sound, I think.

**What to back up?* This is a core question to ask when you start planning. I think it's quite simply answered by asking the secondary question: “Can I get the data again?” Don't back up stuff you downloaded from the public internet unless it's particularly rare. No TV, no Movies, no software installers. Don't hoard data you can replace.

**Do** back up stuff you've personally created and that doesn't exist elsewhere, or stuff that would cause you a lot of effort or upset if it wasn't available. Letters you've written, pictures you've taken, code you authored, configurations and systems that took you a lot of time to set up and fine tune.

If you want to be able to restore a full system, that's something else and generally dealt best with *disk imaging* – I'm talking about individual file backups here!

**Backup Scenario** Multiple household computers. Home linux servers. Many services running natively and in docker. A couple of windows computers.

**Daily backups** Once a day, automate backups of your important files.

On my linux machines, that's things like some directories like /etc, /root, /docker-data, some shared files.

On my windows machines, then that's some mapping data, word documents, pictures, geocaching files, generated backups and so on.

You work out the files and get an idea of how much space you need to set aside.

Then, with automated methods, have these files copied or zipped up to a common directory on an always-available server. Let's call that /backup.

These should be versioned, so that older ones get expired automatically. You can do that with bash scripts, or automated backup software (I use backup-manager for local machines, and backuppc or robocopy for windows ones)

How many copies you keep depends on your preferences – 3 is a sound number, but choose what you want and what disk space you have. More than 1 is a good idea since you may not notice the next day if something is missing or broken.

**Monthly Backups – Make them Offline if possible**

I puzzled a long time over the best way to do offline backups. For years I would manually copy the contents of /backup to large HDDs once a month. That took an hour or two for a few terabytes.

Now, I attach an external USB hard drive to my server, with a smart power socket controlled by Home Assistant.

This means it's “cold storage”. The computer can't access it unless the switch is turned on – something no ransomware knows about. But I can write a script that turns on the power, waits a minute for it to spin up, then mounts the drive and copies the data. When it's finished, it'll then unmount the drive and turn off the switch, and lastly, email me to say “Oi, change the drives, human”.

Once I get that email, I open my safe (fireproof and in a different physical building) and take out the oldest of three usb Caddies. Swap that with the one on the server and put that away. Classic Grandfather/Father/Son backups.

Once a year, I change the oldest of those caddies to “Annual backup, 2024” and buy a new one. That way no monthly drive will be older than three years, and I have a (probably still viable) backup by year.

BTW – I use USB3 HDD caddies (and do test for speed – they vary hugely) because I keep a fair bit of data. But you can also use one of the large capacity USB Thumbdrives or MicroSD cards for this. It doesn't really matter how slowly it writes, since you'll be asleep when it's backing up. But you do really want it to be reasonably fast to read data from, and also large enough for your data – the above system gets considerably less simple if you need multiple disks.

**Error Check:** Of course with automated systems, you need additional automated systems to ensure they're working! When you complete a backup, touch a file to give you a timestamp of when it was done – online and offline. I find using `tree` to catalogue the files to a text file is worthwhile too, so you know what's on there.

Lastly – test your backups. Once or twice a year, pick a backup at random and ensure you can copy and unpack the files. Ensure they are what you expect and free from errors.

