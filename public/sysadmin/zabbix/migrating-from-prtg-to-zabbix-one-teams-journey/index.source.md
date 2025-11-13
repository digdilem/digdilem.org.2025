---
title: Migrating from PRTG to Zabbix – one team's journey.
description: We turned off PRTG this week after migrating to Zabbix. Here's what we learned along the way.
categories:
  - sysadmin
  - zabbix
tags: 
  - linux
  - zabbix
  - sysadmin
keywords: 
  - linux
  - zabbix
  - sysadmin 
comments: true
draft: false
author: Simon Avery
date: '2025-06-13T20:27:37+01:00'
---

We turned off PRTG this week after migrating to Zabbix. Here's what we learned along the way.

*(These are the personal views and findings of a sysadmin tasked with finding something to replace PRTG as our main monitoring system. They do not necessarily reflect the views of my employer.)*

We're a tech based SME with some 500 vm and physical servers. Some linux, some windows, plus the usual assortment of network and edge case devices. Nothing particularly unusual about us.

We first started using PRTG some seven or so years ago. At the time it was the best choice by far, and we thought the licence costs reasonable. It's been a faithful servant in that time, and we consider it a critical system, especially when our other critical systems had failure. We liked the ability to run user scripts, and got used to the sometimes strange UI and all of our team were, by and large, able to use it well.

Ongoing problems with PRTG were the 2,500 sensor cap – we always had to keep an eye on that and had regular housekeeping sessions removing things we didn't need or PRTG would start disabling monitors if the number exceeded our cap. The WMI sensors would sometimes fail, and – especially in the last year – the PRTG server itself has been prone to instability. Sometimes it would stop sending network traffic to its clients and put everything into alarm, notifying dozens of people out of hours – which was obviously not popular and undermined confidence in it a lot. We'd also not seen much in the way of improvements in PRTG over the time we used it. Granted, we weren't crying out for change, but it felt like it was under-developed.

But none of the problems were big enough to consider changing, until Paessler were sold to the capital fund group, Turn/River, who quickly raised the prices. Paessler quoted us a revised fee on renewal which equated to around a 400% increase in cost. On the heels of the Broadcom acquisition of VMWare, we were quite sensitive to vendor lock-in and the squeezes being applied to customers in the industry, and myself and a colleague were given the task of considering alternatives to PRTG.

We quickly thought of Zabbix – after all, it has been around for ages and has a pretty good reputation. We set up a new linux vm, installed Zabbix and started to figured out how to automatically add most of our machines and quickly had a few hundred machines added.

*(The process we used was: Linux machines – add the zabbix repo for our EL and Debian machines. Install zabbix-agent2. Change two lines in the zabbix-agent2.conf to tell it to use its own hostname and the address of the Zabbix server.  For Windows – much the same, just using PDQ to deploy the package and conf. With some auto-add subnet rules on Zabbix server, each new client would connect and be added with the right basic settings.)*

And.. We're happy. We turned off PRTG's vm on Tuesday feeling confident we had everything monitored that needed to be, and had a whole lot more covered on top.

# Here's some takeaways if you're thinking of doing the same thing

* **Zabbix is good.** Everything we did in PRTG is also doable in Zabbix.

* **Start from scratch.** There's no “Press this button and migrate” option available to migrate from PRTG to Zabbix and even if there were, something like this is a good chance not to repeat previous design mistakes. You can export a list of devices from PRTG that may be a useful reference, but we have well defined subnet and were able to automatically discover most of our devices from the originating IP and have them appear in the correct host groups and have the right default templates assigned to them.

* **We can see more of our estate.** We've increased our sensors from 2,500 to 43,000 and no longer have to spend time housekeeping to keep them within licence, or risk things going unmonitored because PRTG has turned sensors off because we exceeded our allowance.

* **Zabbix uses fewer resources.** Despite handling almost twenty times the datapoints, at the server end, we've reduced ram from 16g to 8g and cpus from 4 to 2 and are keeping sysload consistently low. The disk sizes (2nd disk for a local mysql server exclusively for zabbix) is 110gb for Zabbix, vs 130gb used by prtg. On the clients, the lack of LDAP/SSH connections from PRTG every minute has been noticable – we monitor these for intrusion detection so there is a secondary interpretive load on ssh connections that we can bypass with Zabbix's direct port connection. There is obviously some increased memory usage by having an agent running all the time with Zabbix but we think it's remarkably meager. A glance at some clients now shows 16mb ram used by the windows agent and 27mb by the linux one. Disk footprint is less than 100mb for each.

* **Quids in.** We're saving around $9,000 per year in licencing. As a company, we like FOSS and try to give back in some way. My employers are happy for us to submit bug reports, help in forums and sometimes submit PRs to resolve bugs directly. Sometimes we buy support or training from the company. Everyone wins with FOSS.

* **Zabbix is more stable.** We haven't had a single crash from either server or agent in six months. Meanwhile, PRTG had crashed up to twice a week, usually needing manual intervention to reboot the vm and get it going again. (It didn't used to do this, so we think it's a problem with the latest version)

* **Changing at scale is fun!**  Do everything with templates and try to get this right the first time. We can now change settings for templates, apply new templates, and essentially change how every sensor operates with a few clicks. Templates can be linked and values are inheritied with default macros controlling specific things. Want to change the default warning for a low disk space alert? Just change the macro once in the template and suddenly everything is the same. Want that, but also have some servers that need different thresholds? Local Macros override the template, so you can do that too – nice! Having previously had to work through dozens or hundreds of sensors with PRTG to change values was quite tiresome. There may have been a better way that we never found.

* **Making bespoke sensors is easy – once you know how.** We all have “those” pet machines which need something special monitoring. Adding UserParameter checks and monitors allows us to consume anything that can be generated on the command line and alert based on its value. (In fairness, bespoke sensors work quite well in PRTG too, no shade to be cast there) Because Zabbix supports .d/ config fragments, we can easily add these at scale to target host groups by deploying a new file just with the relevant UserParameter, and then a new template to import that Item and a Trigger.

* **There *is* a learning curve.** Zabbix is a complicated piece of software and it's not reasonable to expect to pick it up within a few days. However, the documentation is fairly good. Sometimes I found the official docs sparse – examples would be nice, or an explanation of what that feature was actually doing.The engineering decisions do make sense once you understand them, and it's obvious that the core development team are not only passionate about the project, but technically very skilled too.
*Is the learning curve steeper than PRTG's?* Hard to say as it's a subjective thing, but maybe a little, but not so much that too much time was spent on any one problem.

* **Zabbix is compatible.** Not only does the Zabbix website provide regularly updated installers for all of our OS choices and linux repositories for automatic updating, we're also sending alerts to Mattermost, email and Teams with varying levels of intentional delay and logic. It also talks to all our equipment in more ways than PRTG did, and more types of equipment than PRTG did. Adding monitoring via SNMP is never fun, but we found it easier with Zabbix than PRTG.

* **The Grafana Plugin actually works!** PRTG has never had an official plugin for grafana, and the community created plugin by neuralfraud was abandoned years ago. The angular framework that it uses is now deprecated by Grafana and will stop working soon, if it hasn't already. Additionally, the PRTG plugin was bugged and we found that it often randomly reported latency instead of values which made the graphs rather useless.
By contrast, Grafana has a native, modern and fast plugin for Zabbix that “Just works”. It's been a genuine pleasure to migrate our extensive dashboards over to Zabbix.

* **Support.** As a free user, we obviously have no guaranteed SLA with Zabbix like with did with PRTG, but support contracts are available if that is important to your business. We did use PRTG's support a few times and they were fine. Community support is important to both, but Zabbix's community is very large, and in particular, there are far more templates available for different types of kit than for PRTG. We have had to write a few bespoke things, but we've also saved time by using those already available for Zabbix. The community forums are the usual mixed bag, with outdated or incorrect advice often given, and I wouldn't exactly call them friendly to the novice - a few people prefer to criticise than be helpful - but sadly this is  the case with public support. But when I posted about a specific question relating to device id's, I did get two useful responses within 24 hours.

* **Training.** We were aware of the professional training courses available for Zabbix users but we opted not to avail ourselves of it. Perhaps those with less free time may find it saves them time in getting to grips. We didn't use training from PRTG when we set that up, either.

* **Timescale.** We allowed six months of low priority project time for this migration, and it was a fairly comfortable timespan for us.

## Conclusion

As you can tell, I'm a bit of a convert to Zabbix!

Monitoring systems aren't easily changed for companies, and that's probably why PRTG's new owners ramped up the pricing so much – “vendor lock-in” is real. Some customers will undoubtedly accept the new pricing because they will find it difficult to move to something else, don't have the time or skill to set something else up, or consider it cheaper than migration costs. Fair enough and I wish them well.

My purpose of writing this is to try and give a fairly balanced view of someone who has taken that step and to help inform others of what's involved.

I am not a part of the Zabbix project and don't represent them in any way. We did research some alternatives, both commercial and FOSS, but Zabbix is so large in the sector that we did lean that way from the start.

Thank you, and good luck in whatever monitoring path you choose. May your alerts never be false.

## Six months on

As I copy this article across to Hugo for yet another new version of my site, have my feelings changed?

No, they haven't. I'm even more impressed with Zabbix than I was. We've had no problems with it and have gained a fair bit of admin time that was spent tending to PRTG's increasingly delicate reliability. We've had no more worried employees concerned about what turned out to be false alarms, to the point we've forced problems to ensure the alerting does actually work!

Zabbix server has been faultless. Not a single crash. 

We *have* had the Zabbix agent stop a few times on Windows clients. That shows up within 5 minutes, and we only noticed because it was set not to automatically restart. Changing the service entry to restart on failure means that's a problem we've only had to solve once.

Otherwise, it's brilliant. We're up to around 30,000 items being monitored across some 500 devices on a low spec vm (2x vcpus, 8gb ram) PRTG simply cannot compete at any level with Zabbix - except perhaps the UI, which may be slightly nicer. But not worth the cost, either financially or in terms of upkeep.
