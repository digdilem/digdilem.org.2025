---
date: '2025-06-16T09:09:50+01:00'
draft: false
title: '3 Quick Ways to Improve Mariadb Memory Handling'
author: Simon Avery
description: These are quick and easy and can make a big difference
categories: 
  - mariadb
  - memory
  - sysadmin
  - linux
  - database
---


Something that can surprise users of MariaDb is that it *can* use a lot more memory than it’s configured for. When I first encountered this I brushed it aside somewhat, thinking this was another example of a software memory leak, but it is controllable with three basic steps that MariaDb recommend and it's worth spending a short amount of time making these changes.

These changes are intended for servers where MariaDb is the primary application. They may not suit performance for multi-role servers where Maria is a small part. 

1. **Ensure the host has swappiness turned right down.**

    MariaDb recommend this is set to 1 and we’ve found that works well. This mostly helps performance rather than memory, but it’s so basic I thought it worth including here

* Here’s [MariaDb’s reference piece](https://mariadb.com/kb/en/configuring-swappiness/) showing how to do this.

2. **Ensure the host has Transparent Huge Pages disabled.**

    For us, this made maria’s memory requirements a lot more stable. The gradual increase in memory used we’d seen was entirely gone.

* [MariaDb’s guide on disabling THPs](https://mariadb.com/kb/en/transparent-huge-pages/)

3. **Use a more suitable memory manager than most distros ship with.**

    Most distros ship with a memory allocation library that has to compromise to suit a wide range of uses. MariaDb, like other databases, uses memory quite aggressively in that it's constantly changing what's stored. Fortunately there's at least two more suitable libraries freely available to use.

    We use jemalloc most commonly, but also had some success with tcmalloc. Both ship with Rocky Linux and Debian and are quick and easy to install and then enable via systemd.

* [MariaDb’s guide to using tcmalloc or jemalloc](https://mariadb.com/kb/en/using-mariadb-with-tcmalloc-or-jemalloc/)
* I've also written about this in [another post here](/p/solving-excess-memory-usage-in-mariadb/)

## Conclusion 

All of these changes are part of our basic **New Database Server** build profile now and we’ve been using them for a long time. We no longer over-commit on memory to ensure stability, as the usages can be controlled via MariaDb’s configuration settings (notably innodb_buffer_pool_size ) and monitoring shows some nicely flat memory graphs after they've initially populated.
