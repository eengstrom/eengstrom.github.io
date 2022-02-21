---
layout: post
title:  Install MacFuse and `sshfs` on macOS Monterey
description:  Install MacFuse and `sshfs` on macOS Monterey
date:   2022-02-21 13:56:09 -0600
tags:   macfuse sshfs macos monterey
images: /images/2022-02-21-macfuse/
excerpt_separator: <!--more-->
---

MacFUSE, a FUSE module for macOS, has been around in various forms for quite some time.  It seems that each time Apple releases a new OS version, there are challenges in getting MacFuse installed.  This is simply the latest iteration with MacFUSE (4.2.4) on macOS Monterey (12.2.1) on an Apple M1 (Max) chipset, plus a bit on using it with `sshfs`.

<!--more-->

# Installing MacFuse

Even if you are used to using Homebrew (https://brew.sh/) or MacPorts (https://www.macports.org/), I suggest fetching the installer directly from https://macfuse.io/.  Also, because MacFuse is a kernel extension, Apple will require you to explicitly enable the use of kernel extensions, since they can pose a large security threat.

You will need MacFuse of at least version 4 on M1 Macs. This is because Rosetta 2 will not perform it's translation magic for kernel extensions, and therefore you need the Apple Silicon version.  Also, since MacFuse is properly signed, you do **NOT** need to disable SIP (System Integrity Protection).  If anyone says otherwise, they are wrong.

Once you have the installer, you **can** start with the MacFuse installer first, **however**, if you are starting from scratch, I believe the following order should avoid extra multiple reboots, and possible removal and re-installation of MacFuse.

## Enable System Extensions (Kernel Extensions)

For this, you will need to reboot into macOS Recovery Mode.

* Shutdown/Reboot
* Hold Power/Touch-ID to launch Startup Options.  Select "Options":

  ![Startup Options]({{ page.images }}1.boot-options.jpg){: height="250px" }

* Select "Startup Security Utility" from Utilities menu:

  ![Open Startup Utility]({{ page.images }}2.open-startup-utility.jpg){: height="150px" }

* Open "Security Policy..." for the startup disk:

  ![Open Security Policy]({{ page.images }}3.open-security-policy.jpg){: height="250px" }

* Enable Kernel Extensions:

  ![Enable Kernel Extensions]({{ page.images }}4.set-security-policy.jpg){: height="350px" }

* Reboot into macOS, under the "Apple" Menu.

## Install MacFuse

Follow the normal installation process.  At the end of installation, you should be prompted to enable the kernel extension:

  ![Kernel Extension Blocked]({{ page.images }}5.extension-blocked.png){: height="350px" }

* Open "System Preferences >> Security & Privacy":
* Click "Allow"

  ![Allow MacFuse Kernel Extension]({{ page.images }}6.allow-extension.png){: height="450px" }

* Restart your Mac one last time, to allow the kernel extension to load on boot.

## Install sshfs

My most common use for MacFuse is `sshfs`.  Since Homebrew has deprecated MacFuse, the recipe for installing `sshfs` also does not work.  Thankfully, it's trivial to install from source.

Note that I'm using [my personal fork](https://github.com/eengstrom/sshfs),
which is [a fork of OSXFuse's version](https://github.com/osxfuse/sshfs),
which is itself [a fork of the "true source" from libFUSE](https://github.com/libfuse/sshfs),
modified to compile macOS Monterey.

```
# Prereqs
#brew install glib automake
# Original
#git clone git@github.com:osxfuse/sshfs.git
# My fork and branch:
git clone --branch 2.9@monterey git@github.com:eengstrom/sshfs.git
cd sshfs
test -e Makefile.in || autoreconf -i
./configure
make
sudo make install
```

----

### Useful Refs:

 * [About System Integrity Protection on your Mac](https://support.apple.com/en-us/HT204899)
 * [About system extensions and macOS](https://support.apple.com/en-us/HT210999)
 * [Disabling and Enabling System Integrity Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection)

and others, if you read between the cruft:

 * https://apple.stackexchange.com/questions/412096/how-to-use-sshfs-on-apple-silicon-m1
 * https://github.com/osxfuse/osxfuse/issues/741
