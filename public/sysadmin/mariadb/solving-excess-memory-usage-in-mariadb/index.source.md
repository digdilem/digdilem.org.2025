---
date: '2025-06-16T09:05:13+01:00'
draft: false
title: 'Solving Excess Memory Usage in Mariadb'
author: Simon Avery
categories:
  - mariadb
  - memory
  - sysadmin
  - linux
  - database
---


Users of MariaDb sometimes notice that the memory used by the process far exceeds what MariaDb is configured to use through its various configuration parameters and buffers. This is especially noticed in larger and busier database servers.

Often, despite looking like a memory leak in the application, this is actually a problem of fragmented memory not being aggressively cleaned by the malloc (memory allocation) library used.

Fortunately, it is a fairly easy thing to solve by installing one of two freely available libraries, jemalloc or tcmalloc, and telling mariadb to use it instead of the OS’s default. These more tightly monitor and defragmented memory pages. 

## Real life scenario

A company with a number of MariaDb servers running on Centos 7 and 8 often saw memory usage increasing beyond what it should have until oomkiller was activated which killed MariaDb as the biggest memory usage on the server. MariaDb restarted and all was well again until it happened again, some days later. Increasing memory on the server just delayed the inevitable – MariaDb would appear to keep using more and more memory until there was nothing left. They switched to jemalloc and the problem simply went away with no ill effects. Performance was unchanged and they made it a part of their standard database server build.

## Jemalloc or TCMalloc?

I’ve used jemalloc personally with a great amount of success. In all but one extremely busy server, it has completely solved the “memory leakage” effect. In that remaining server – which jemalloc did slow down the rate of growth, I’m planning to trial tcmalloc which has been performing well on a test machine for some months, and others have reported success with tcmalloc where jemalloc wasn’t much help. 

## Why is this needed?

Not all memory management operates in the same way, and as there are different needs for a database than a GUI or general use application on a computer, so there are different libraries that prioritise in different way. The two libraries we’re looking at are more aggressive at defragmenting memory pages in particular, which is one reason that leads to memory getting used up.

[ManagedServer has a good explanation with more detailed information here](https://www.managedserver.eu/Improve-mysql-and-mariadb-performance-with-memory-allocators-like-jemalloc-and-tcmalloc)

## Steps to enable jemalloc for MariaDb

1. Install the jemalloc library
* In EL (Rocky) distros, that may look something like 

    `yum install jemalloc`
* On Debian and alike, that may be:

    `apt install libjemalloc2`

2. Locate the actual library file

* In EL, this is currently `/usr/lib64/libjemalloc.so.2`

* In Debian, this is currently `/usr/lib/x86_64-linux-gnu/libjemalloc.so.2`

* *(If you can't find it, you could use `mlocate` with `updatedb&&locate libjemalloc` to find it)*

3. Create a drop-in systemd file for mariadb with an Environment statement to tell MariaDb it needs to load the library. Create a new text file called this containing two lines as below. Change the path to the library file after 'Environment=' to match the above.

* `/etc/systemd/system/mariadb.service.d/mariadb_tcmalloc.conf`

```
[Service]
Environment='LD_PRELOAD=/usr/lib64/libjemalloc.so.2'
```

4. Tell systemd to scan for that file, and then restart MariaDb

```
systemctl daemon-reload
systemctl restart mariadb
```
And that should be it!

## Steps to enable TCMalloc for MariaDb

The process is almost identical as for jemalloc, just change the package and library to tcmalloc.

* *For Debian, the package to install is currently libtcmalloc-minimal4 and that puts the library file at `/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4`*

## Verifying it worked

To see which malloc library MariaDb is using, just run the following SQL query in MariaDb:

```
SHOW GLOBAL VARIABLES LIKE 'version_malloc_library';
```

This should report something useful like, for TCMalloc;

> version_malloc_library tcmalloc gperftools 2.10

That's it. MariaDb is now running a more suitable alloc library!

