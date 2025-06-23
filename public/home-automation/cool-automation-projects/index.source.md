---
date: '2025-06-15T22:18:04+01:00'
draft: false
title: 'Cool Automation Projects'
tags: 
    - home-automation
    - project
categories:     
    - home-automation
---

Just some cool ideas for automation if you're looking for inspiration, or justifying why Home Automation can be useful.

## Automatic Night Lights

**Problem:** Like many people into their middle age, I sometimes need to visit the toilet at night. Turning on lights and remembering to turn them off wasn't the biggest deal in the world, but I thought it woke my brain up just a little bit more than it needed. 

**Solution:** Create a system that detects movement and turns on lights to the most common areas.

**Method:** 

In Home Assistant:

1. Using various existing movement sensors (From the original Burglar Alarm, combined with a couple of Aqara Zigbee PIR sensors, and all the door sensors; detect movement
2. If the time is between Sunset and Sunrise, turn on some lights. Wait five minutes and then turn them back off. If more movement is detected, reset the timer. 

**Even Better:** 

* The automations work by time. After 10PM when we're more likely to be going to bed, the same automation applies but only sets the lights at 5%. This is just bright enough to see by. 
* These are better than standalone "movement lights" because:
    * They never run out of battery.
    * They can be linked in many creative ways depending where that movement is detected. For example: Front door opens? We probably want most lights on. But if it's bedroom movement at night, chances are it's just the hall and bathroom that are needed. 


## Monitoring Freezer Temperatures

**Problem:** What happens if a freezer is unplugged or breaks down when it's full of food, and you don't notice it immediately?

**History:** We used to feed our dogs on a raw meat diet. That meant buying a lot of meat, all packages in 500g plastic bags and kept in a half-sized freezer in the house. It was actually the overflow dog food freezer so had been left turned off before hand. We had a delivery that filled the primary freezer so I put the overflow in this one. 30kg of raw meat. What I didn't do, was turn the freezer back on...  A fortnight later, we noticed the dogs were sniffing at the freezer and licking it, and when I opened it, rotting meat fell out. Cleaning that up was not a fun game... (Fortunately we had a farmer friend who was able to dispose of the meat, but we still had to remove and bag it up to get it outside, then do a big cleanup job. Quite an incentive to prevent it re-occurring, right?

**Solution:** Monitor the internal temperature of each freezer (We had five at one point) and raise alerts if any of them went above -5'c

* I've written a [page about this project here](/home-automation/measuring-freezer-temperatures/)

