---
layout: post
title:  Booting XEN on Ubuntu via Grub with UEFI
description:  Booting XEN on Ubuntu via Grub with UEFI
date:   2019-07-15 18:35:49 -0500
tags:   Booting XEN on Ubuntu via Grub with UEFI
excerpt_separator: <!--more-->
---

If you have Ubuntu 18.04 (or possibly even 16.x or earlier) and are trying to boot a XEN kernel using GRUB2[.efi] on a UEFI system, you will likely run into "blank screen/hanging" problems as others have found (e.g. [here][issue-ubuntuforums] and [here][issue-nabble]).
<!--more-->

A fix for the issue is in Grub 2.04, but current stable releases of Debian and Ubuntu are still using Grub 2.02 - specifically, Debian (as of version 10, aka Buster) therefore downstream Ubuntu (18.4/Bionic, and 19.04/Disco, at the moment).  I see that Grub 2.04 is in Debian Testing (11 / Bullseye), so hopefully it will make it into Ubuntu soon.  Until then, there are some, IMO, overly complicated solutions are to get [XEN to boot directly via EFI][XenProject-EFI-Boot] or [building GRUB from source][XenProject-grub-boot].

Simpler, and working for me on Ubuntu 18.04[.02] and Grub 2.02 (specifically 2.02-2ubuntu8.13), I was able to make use of [a first-draft patch][grub-patch-v1] and [modify it to directly patch `/etc/grub.d/20_linux_xen`.][modified-patch]

```
{% include_relative content/20_linux_xen.patch %}
```

Apply this patch with:

```
cd /etc/grub.d
patch -c -i 20_linux_xen.patch
```

I think for the short term, or until Grub 2.04 (with [this "official" patch][grub-patch-git]) becomes mainline in Debian/Ubuntu, I think this is a much simpler solution than booting directly via EFI and does not require rebuilding Grub from source.

[issue-ubuntuforums]: https://ubuntuforums.org/showthread.php?t=2413434
[issue-nabble]: http://xen.1045712.n5.nabble.com/EFI-boot-unsuccessful-with-Ubuntu-18-04-dom0-tp5744870p5744905.html
[XenProject-EFI-Boot]: https://wiki.xenproject.org/wiki/Xen_EFI#Xen_as_EFI_binary_.28loading.29
[XenProject-grub-boot]: https://wiki.xenproject.org/wiki/Xen_EFI#Xen_as_gz_binary
[grub-patch-v1]: https://lists.xen.org/archives/html/xen-devel/2017-03/txtCeHTNmz1hZ.txt
[grub-patch-git]: http://git.savannah.gnu.org/cgit/grub.git/commit/?id=b4d709b6ee789cdaf3fa7a80fd90c721a16f48c2
[modified-patch]: ../files/20_linux_xen.patch
