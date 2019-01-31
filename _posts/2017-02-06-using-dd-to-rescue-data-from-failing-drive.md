---
layout: post
title: Using dd to rescue data from failing drive
date: '2017-02-06 14:36:17 -0600'
tags: dd, smart
---

So, you've ignored those [S.M.A.R.T.](https://en.wikipedia.org/wiki/S.M.A.R.T.)
errors for a while now, haven't you. Now you
realize that there might actually be something going wrong with your hard
drive. You try to naively copy data off, but it fails. But, no worries, there
is an option to `dd` that can help you get _most_ of the data off:

    dd if=/dev/sdc of=/home/me/sdc.dd conv=noerror,sync

or, if using `lvm`

    dd if=/dev/vg0/failing-lvm of=/dev/vg0/new-lvm conv=noerror,sync

The `conv` options specify that `dd` should ignore read errors, and to
synchronize the read position with the write position when those errors occur.
The file `sdd.dd` or new `lvm` volume could now be mounted:

    mount -o loop -t ntfs /home/me/sdd.dd /mnt/old

Hopefully you can recover (most of) the files now.
