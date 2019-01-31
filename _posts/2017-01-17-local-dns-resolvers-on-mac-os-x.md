---
layout: post
title: Local / domain-specific DNS resolvers on Mac OS X
date: '2017-01-17 13:46:30 -0600'
tags: admin, dns, MacOS
---

Got VMs? Have local servers at home? Connecting to a VPN? Want to do ALL at
the same time **and**  still be able to use typical DNS name resolution to
reach the local domain hosts and your VMs? Doing this from a Mac?

To solve the problem of having different, local-only DNS/resolver lookups on
Mac, e.g. for a set of local VMs for experimentation, you could encode the
hosts into the `/etc/hosts` file, but you could also run a local instance of
`dnsmasq`. But then how do you tell your Mac to get addresses from that local
server or any other (local network) server.

An answer I discovered a while ago (and just today discovered) lies in a
[StackExchange post](http://serverfault.com/questions/22419/set-dns-server-on-os-x-even-when-without-internet-connection),
but boils down to adding files in `/etc/resolver/` of the form:

>     $ cat /etc/resolver/mydomain
>     nameserver 192.168.50.1
>     search_order 500
>     $ ping -q -c 1 somelocalhostname.mydomain
>     PING somelocalhostname.mydomain (192.168.50.10): 56 data bytes
>     1 packets transmitted, 1 packets received, 0.0% packet loss
>     round-trip min/avg/max/stddev = 4.169/4.169/4.169/0.000 ms

HOWEVER, just because the resolver libraries are doing the right thing, some
applications, notably `dig`, `nslookup`, `host`, etc, will not query anything
but the **FIRST**  resolver, and therefore will not respond with a useful
answer.
