---
title: Containers for ESP Projects
linktitle: ESP Project Boxes
description: "A selection of random containers I've used for Home Automation projects"
date: 2025-06-11T19:07:03.814Z
preview: ""
draft: false
image: /wp-content/uploads/2025/03/image-12.png
author: Simon Avery
tags: 
    - home-automation
    - esp 
    - project
categories:     
    - home-automation
prev: /docs/esphome/    
---


What to use once you've worked out your project and want to actually use it?

Here's some containers that I've used for various projects. This isn't so much a demonstration of how you *should* do, more a hall of shame of how *I've* done it...

## Naked ESP dangling from its USB supply

![This one measured my classic car's battery voltage so has a little daughter board to step that down. And no, I'm not proud of that negative connection.](1.png)

## Electrical tape wound around the ESP and connecting wires  
![Terrible. Never do this.](2.png)


## A plastic bag taped closed 

![This was surprisingly effective for a zero effort container that didn't need any ongoing work. Keeps the dust off, stops short circuits. Might suffer from overheating if you run a very hot chip, but for my 8266's it was fine.](3.png)

## An Electrical Socket 

![Specifically, a deep backing box for surface mount. Lots of space, heat rated plastic, handy knockouts for wire entry and screw mounting. Top with a blanking plate (or even an actual light switch or socket) and it blends right in &#8211; until someone tries to use it.](4.png)

## An outside light switch

![I had an old one of these with a broken switch when I was looking for a container to use outside and it fit the bill. Handy grommits to run wires, totally waterproof &#8211; worked great!](5.png)

## A takeaway food container 

![With the lid on, it keeps dust out nicely. A little bubble wrap ensures it sleeps soundly.](6.png)

*This was actually my first "proper" ESP project! The 12v incoming supply to the breakaway board feeds power to the 12v PIRs. The cat5 brings wires connected to the zones of my old and broken home burglar alarm. Running Konnected, the esp8266 has been feeding house movement and door/window sensor information to Home Assistant for over half a decade like this!*

## Various "Project Boxes"

![These are perfectly useful, but probably my least favourite containers to use. They're quite expensive and *so* predictable!](7.png)

## The rugged aluminium speaker and electronics boxes from a heavy plant reversing system

![I was lucky enough to score a big box full of these things at a local auction for a quid. They're about 250x100mm by about 50mm deep - lots of space and made of aluminium so really strong.](8.png) 

*They did have a bunch of lights and buttons on the front, which is why I've rivetted some ally across the holes here.*

![A picture of the insides. The green things on the left are connector blocks, so I can just unplug the box and take it away without all the pain of reconnecting the sensor wires afterwards_. _Being able to replace the ESP from the breakaway board is a great thing too &#8211; I have had issues where I needed to remove it to reflash after a bodged over-the-air update and this layout made that easy.](9.png)
