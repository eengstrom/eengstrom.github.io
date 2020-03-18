---
layout: post
title:  Serial Console under FreeBSD
description:  Serial Console under FreeBSD
date:   2019-12-16 12:50:28 -0600
tags:   serial console freebsd
excerpt_separator: <!--more-->
---

Having previously setup serial console access for Linux systems, here's a recipe to do this for FreeBSD as well.

<!--more-->

In my case, I needed it for a OOB (out of band) BMC (Baseboard Management Controller) from Dell (iDRAC), but it should apply to any system.

Create or add to (in a **SINGLE LINE**) `/boot.config`:
```
-Dh
```

That will setup a "dual console" for the boot loader, mirroring i/o for the boot loader to both standard video console and the serial console.  See also `boot(8)` and `boot.config(5)` man pages.

Add to `/boot/loader.conf` (or `/boot/loader.conf.local`):
```bash
boot_multicons="YES"
boot_serial="YES"
comconsole_speed="57600"
comconsole_port="0x2f8"
console="comconsole,vidconsole"
```

That completes the setup, providing sufficient hints to the loader to provide to the kernel to again mirror i/o to both serial and video consoles. See also `loader(8)` and `loader.conf(5)` man pages.

Note two potentially unique options that may not map directly to your configuration:

 * `comconsole_speed="57600"` - for a slower, older machine.
 * `comconsole_port="0x2f8"` - `ttyu1` (`com2`), rather than default `ttyu0`.

In my case (Dell iDRAC), I needed to set the console interface to a different UART, hence the `comconsole_port=` option, otherwise the default UART would be used.  You should be able to find the address of the serial console via `dmesg`, as in:

```bash
# dmesg | grep uart
uart0: <16550 or compatible> port 0x3f8-0x3ff irq 4 flags 0x10 on acpi0
uart1: <16550 or compatible> port 0x2f8-0x2ff irq 3 on acpi0
uart1: console (57600,n,8,1)
```
For your case, best to confirm both com port and speed via the documentation for your BMC/DRAC/CMC/whatever.

---

Useful references:
 - [FreeBSD Handbook](https://www.freebsd.org/doc/handbook/serialconsole-setup.html)
 - [UART selection for FreeBSD <= 10.x](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=210903)
 - [Serial Port Console under FreeBSD](http://kb.unixservertech.com/unix/freebsd/ipmi_sol)
