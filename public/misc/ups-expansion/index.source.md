---
date: '2025-10-30T11:25:20Z'
draft: false
title: 'Extending UPS runtimes'
author: Simon Avery
categories:
  - pc
  - server
weight: 19
---

# Expanding UPS runtimes on the cheap

Despite what some manufacturers would have you believe, the battery packs for nearly all Uninterruptable Power Supplies are not magical, they're just 12 volt Sealed Lead Acid batteries.

This means that, if you don't mind a little bit of basic wiring, you can use any 12v lead acid type battery with them. If you happen to have an old car or tractor battery lying around that's no longer quite good enough to turn an engine over in a cold winter, it would still have enough capacity to run a UPS. 

I've done this several times and it's always worked out well for almost no money. 

Note: Car batteries emit more hydrogen when charging than SLAs, so only do this in a well ventilated space.

## What do you need?

* A UPS.  *We'll restrict ourselves to lower powered consumer UPS' that use a single 12v SLA battery, although the principles work just as well for larger packs that have 2 or more in serial - just use the equivalent number of 12v batteries, but do make sure they're close to each other in terms of their own capacity and starting voltage.*
* A 12v lead acid battery. *This can be almost anything. The larger the better, and you could add a similar bunch together in parallel to further increase capacity*
* 2x battery clamps or crocodile clips to connect to the car battery.
* Some thick-guage wire to extend the wiring outside of the UPS to the car battery.

## Connecting

![How it goes together](ups-diagram1.png)

1. Ensure your car battery is charged up to at least 12.2v. Resting voltage for a fully charged 12v battery is around 12.6 to 12.8v.
2. Disconnect the UPS from the mains and open it up. Stay away from the circuitry - there'll be some capacitors in there that can still give a painful and dangerous shock. 
3. Disconnect and remove the old SLA battery
4. Extend the positive lead that used to go to the positive terminal on the old battery. This should be of a similar guaged wire and be long enough to reach the positive terminal of the car battery. You may wish to fit an in-line fuse to this, although the UPS will probably already have one.  
5. Repeat for the negative lead. 
6. Replace UPS covers.  You may need to cut a hole in the UPS case, or tail the leads out of the front. 

When connected, the UPS should go into mains-lost mode and perhaps start beeping. 

At this point, it should be safe to connect the UPS back into the mains and it should behave exactly as it did with an internal battery.

![It might look something like this](benchtest.jpg)

## Voltage

The voltages should be identical to SLA and any diagnostics the UPS may have should look the same for this, once the battery has recharged.

## Runtimes

The UPS will probably report disappointing runtimes at first. Once the battery is charged, it's worth triggering a full calibration. On most UPS', this disconnects the mains supply and runs the load off the battery until the voltage drops to a specific figure. Then it calculates the load and the duration this took and establishes a new estimated runtime figure. This is something most UPS' do anyway to remain accurate as the original batteries deteriorate with age. Once that's complete, the new runtime figure it reports should be longer if the larger battery is in good condition.

## Recharging

After being depleted, UPS' will recharge their battery and this will obviously take longer than a smaller one. They often condition the battery also, so it's not unusual to see fluctuations of the battery's voltage as it floats a small charge. Again, this voltage should be similar to the original battery.

## Considerations

* Lead acid batteries emit more hydrogen when charging than SLA batteries do, which is explosive. Ensure your space is well ventilated. (I run my server in a garage, which was perfect)
* If the wiring extension is long, increase guage to avoid voltage drop. (There are various formulas for this)




