---
layout: post
title: Upgrade Ubiquiti UniFi AP-AC-Pro to mitigate KRACK
date: '2017-11-02 14:50:05 -0500'
tags: dns, security, pfSense, ubiquiti, firewall, ntp, krack
---

In the vein of *"this should be easy..."*, I thought I'd share a story of wasted time.

So, if you haven't heard, there's a [flaw in the WPA2 protocol][krack].

Since have a Ubiquiti UniFi WiFi AP, I figured
[they'd have an update quickly][update],
which they did.  However, I didn't anticipate trouble in updating to latest firmware.
It took a _**LONG**_ time to finally get it updated.
Essentially, the update via the controller would
[fail to update][fail], even though it would say it was going to
update to the right version.  The AP would blink happily, then reboot on the
same version of the firmware, over and over.  I tried other means, including
trying
[local and ssh/scp update methods][ssh].
Same result.
In then end,
[this](https://community.ubnt.com/t5/UniFi-Wireless/AP-won-t-upgrade/td-p/1555387)
and
[this](https://community.ubnt.com/t5/UniFi-Wireless/AP-AC-Pro-does-not-Upgrade-from-3-8-3-6587-to-3-9-3-7537/td-p/2108382)
and
[this](https://community.ubnt.com/t5/UniFi-Wireless/Unable-to-update-Unifi-AP-Pro-to-3-9-3-7537/td-p/2104494)
helped me diagnose a very odd situation:

  * Controller or other udpates failed because it was using https:// URLs to download the update
  * SSL verification built in fails because the time on the AP was not updated (was December, 1969)
  * Time on the AP was not synced (via NTP) because my local NTP server (on my router) was not functional.
  * my local NTP server was not functional because I had my DNS server pointing to non-standard (non-logging, private) DNS servers.
  * Those private DNS servers were failing to resolve some things, AFAICT, including pool.ntp.org

After updating my DNS servers (now using google again - not my first choice
since they log my queries), which fixed NTP server, which allowed me to
upgrade the firmware on my PFSense router (which wasn't getting updates
because of the DNS issues) which made NTP happier yet, which allowed the WiFi
AP to get the correct time, which allowed the upgrade to happen properly.

Whew.

[krack]: https://krebsonsecurity.com/2017/10/what-you-should-know-about-the-krack-wifi-security-weakness
[update]: https://help.ubnt.com/hc/en-us/articles/115013737328-Ubiquiti-Devices-KRACK-Vulnerability
[fail]: https://community.ubnt.com/t5/UniFi-Wireless/Unable-to-update-Unifi-AP-Pro-to-3-9-3-7537/td-p/2104494
[ssh]: https://help.ubnt.com/hc/en-us/articles/204910064-UniFi-Upgrading-firmware-image-via-SSH
