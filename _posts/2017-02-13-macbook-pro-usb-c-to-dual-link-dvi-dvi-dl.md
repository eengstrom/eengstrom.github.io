---
layout: post
title: MacBook Pro USB-C to Dual-Link DVI (DVI-DL)
date: '2017-02-13 14:14:33 -0600'
tags: mac, usb-c, dvi
---

So, you've got a nice large 30" display (e.g.
[Apple 30" Cinema Display][acd30]
or
[Dell 3007WFP][dell30]
)
that can
render 2560x1600 @ 60 Hz, but it has a Dual-Link DVI connector. And, you have
a nice new MacBook Pro 2016 with only USB-C connectors. You might think it
would be easy to connect, but this might turn out as a total PITA, because any
straightforward solutions (involving simple adapters with physical
compatibility) won't cut it - it's more complicated...

In theory, it should be possible to drive a Dual-Link DVI display from a USB-C
port, and even get the power from the USB-C for the power for the _active_
adapter (that's the key word: active), but I haven't yet found one. Moreover,
as of now, I know of _NO_ Apple branded product that does the right thing.

The problem is that to "support higher-resolution display devices, the DVI
specification contains a provision for dual link. Dual-link DVI doubles the
number of TMDS pairs, effectively doubling the video bandwidth"
(*[wikipedia][dvi-dl]),
but (AFAIK), it does so by encoding a _second_ set of signals on the
additional set of pins. That is, it's not one signal at a higher
resolution/refresh, but two that are combined at the monitor to a single image
again. That's what gets you higher resolutions, up to 2560  × 1600 at 60 Hz.
_Sometimes_ the connector is called "DVI-DL (dual-link)" but not always, often
the name is conflated with simply DVI-D (digital only, an not at all the same
thing), and moreover some adapters have the extra dual-link pins, and even
claim to be dual-link, but the extra pins aren't even connected to anything!
Finally, dual-Link is not the same as dual-head, though my head starts
spinning when I think about this for too long.

Modern HDMI cables can carry resolutions (and refresh) that exceed DVI-DL, but
they do it in a _single_ signal path. Adapters from HDMI to Dual-Link DVI
simply do not exist, but even if one did, it would need to be an
[HDMI Type B connector][hdmi-b]
which is not the typical Type A connector you see around.

Display Port is a different beast altogether, and some passive adapters exist,
but it too complicates the nomenclature with
"[Dual-Mode Display Port][dp-dual]",
but that's not
the same as Dual-Link DVI, and is not simply electrically (passively)
compatible.

In other words, you can't do go from any physical form factor to Dual-Link DVI
with only a _passive_ (physical/electrical wired) adapter. What you need is an
_active_ adapter which takes a single-link signal and splits it into two
signals on the different sets of Dual-Link DVI pins. Apple does have these for
[Mini Display Port to Dual-Link DVI][minidp-dvidl],
and others exist, but AFAIK, all are Display Port related
and all require external power to drive internal chips to split the signal.

So, the solution I have come up with is to use my existing Mini Display Port
to Dual-Link DVI adapter from Apple, and then use a USB-C to Display Port
adapter. An obvious first choice might be
[Apple's USB-C (Thunderbolt 3) to Thunderbolt 2 adapter][tb3-tb2],
but it's not quite right as it's *NOT* a Display Port
adapter. Don't try it. Instead, the solution I'm using an
[Itanda USB C to Mini-DP Adapter][itanda].2

Note that you still need external power for the mini-DP to DVI-DL adapter,
which can be provided by *ANY* USB power port (on your Mac, or powered hub, or
even an Apple iPhone or iPad power plug. Depending upon your monitor, you
_might_ be able to plug in the USB power to the monitor itself, as I do with
my Dell 3007WFP.

**Other references that I found helpful:**

  * [http://superuser.com/questions/332099/does-a-hdmi-to-dvi-dual-link-adapter-exist](http://superuser.com/questions/332099/does-a-hdmi-to-dvi-dual-link-adapter-exist)
  * [http://www.tomshardware.com/answers/id-2287249/hdmi-dual-link-dvi-conversion](http://www.tomshardware.com/answers/id-2287249/hdmi-dual-link-dvi-conversion-adaption.html)
  * <https://www.macworld.com/article/3162242/macs/connecting-an-apple-display-via-usb-c>
  * <https://en.wikipedia.org/wiki/USB-C#Alternate_Mode_partner_specifications>
  * <https://support.apple.com/en-us/HT204360>
  * <https://discussions.apple.com/message/30512711#30512711>

Other things which might work, some of which have pass-through USB-C power,
but I didn't try:

  * <https://www.amazon.com/UPTab-USB-C-Type-DisplayPort-Adapter/dp/B01N4FQNYW>
  * <https://www.hypershop.com/collections/usb-type-c/products/hyperdrive-usb-type-c-hub-with-mini-displayport>


[acd30]: https://en.wikipedia.org/wiki/Apple_Cinema_Display#30-inch_model_compatibility
[dell30]: https://en.wikipedia.org/wiki/Dell_monitors
[dvi-dl]: https://en.wikipedia.org/wiki/Digital_Visual_Interface#Connector
[hdim-b]: https://en.wikipedia.org/wiki/HDMI#Connectors
[dp-dual]: https://en.wikipedia.org/wiki/DisplayPort#Dual-mode
[minidp-dvidl]: http://www.apple.com/shop/product/MB571LL/A/mini-displayport-to-dual-link-dvi-adapter
[tb3-tb2]: http://www.apple.com/shop/product/MMEL2AM/A/thunderbolt-3-usb-c-to-thunderbolt-2-adapter
[itanda]: https://www.amazon.com/gp/product/B01N2ORP84
