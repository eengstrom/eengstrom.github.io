---
layout: post
title: SSH Auto-Proxy Script
date: '2004-01-31 13:51:37 -0600'
tags: ssh, proxy
excerpt_separator: <!--more-->
---

If you've ever added a `ProxyCommand` directive to your `ssh` config file,
but you are on a portable computer only need that directive sometimes.
 <!--more-->
Other times you might be behind that nasty corporate firewall or on
the network with the proxy server? Since the `ProxyCommand` configuration item
can be just about anything you like, as long as it reads from standard-input
and writes to standard-output, we can use that fact and write a wrapper around
to only invoke a proxy connection when needed. I've written such a script and
use it regularly to tunnel through HTTP Proxy servers or to jump through
intermediate hosts.

See [my github hosted `ssh-proxy` script][github]
and place it in your `~/.ssh `directory.

## Enable use of `ssh-proxy`

Change your `~/.ssh/config` file to include the following:

    Host *
      ProxyCommand $HOME/.ssh/ssh-proxy _http-proxy.example.com_ 8080 %h %p

The relevant line is of course the `ProxyCommand` line and it looks darn
similar to the previous version. All that this script does is attempt to
connect _directly_ to the destination host first, falling back to using the
proxy server specified if a direct connection is not possible.

Note that the script uses another program called `netcat`(sometimes just `nc`)
to test and make direct connections. If you don't have `netcat`, you can [look
here](http://netcat.sourceforge.net/), but any decent system, including
Cygwin, should have it installed by default.

## Shorten the proxy timeout

The `ssh-proxy` script defines a default timeout (8 seconds) for testing direct connections to the remote host. If that timeout seems too long to you, you can shorten it by adding a `-w ` flag in the `ProxyCommand` line of your `~/.ssh/config` file, like this:

    Host *
      ProxyCommand $HOME/.ssh/ssh-proxy -w 2 _http-proxy.example.com_ 8080 %h %p

If on the other hand, 2 seconds is too short, you can make it longer too.

## Alternative proxy commands

Just like you can specify a alternate timeout, you can use two other options to specify the name and/or location of the `netcat` and `corkscrew` programs:

    -n path-to-netcat/direct-connect-program
    -t path-to-corkscrew/http-tunnel-program

One could even specify a completely different direct-connect or proxy-tunnel
programs, but then you are probably going to have to modify the source as the
arguments are not likely to be the same. Just look at the source.

There are a lot more options documented in the markdown hosted alongside the
[script on github][github].

[github]: https://github.com/eengstrom/ssh-proxy
