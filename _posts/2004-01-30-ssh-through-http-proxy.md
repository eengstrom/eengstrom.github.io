---
layout: post
title: SSH through HTTP Proxy
date: '2004-01-30 17:16:15 -0600'
tags: ssh, proxy, http, firewall
---

 * Can't use SSH on the standard port 22?
 * Need to tunnel through a proxy server?
 * Work behind a draconian firewall and can't SSH directly?

No problem. Here's a hack showing how to tunnel through an http-proxy server
without any server-side modifications.

> _Note to the reader: This post is a verbatim copy of a static page I wrote
> back in 2004 or so, which, largely because it's been so referenced by Google
> and routinely accessed even now, I'm keeping the content around. But much of
> what I wrote is dated at least, and some might be just wrong now.  In
> particular, use of `corkscrew` might be better replaced by `desproxy` or
> similar TCP tunnels._

#  Build and Configure an HTTP-Proxy Application

1. Get Corkscrew:

    Available from [this updated corkscrew github repo](https://github.com/bryanpkc/corkscrew).

    I've tried other http-tunnel programs, but this is truly the easiest one I've found and it doesn't require server-side applications (such as are required by [`httptunnel`](http://www.nocrew.org/software/httptunnel.html), which is a good program otherwise). Furthermore, `corkscrew` works on every UNIX platform I've tried and even compiles and runs flawlessly under [Cygwin](http://www.cygwin.com/) on Windows.

2. Unpack and Compile`corkscrew`:

       tar -xzvf corkscrew.tar.gz
       cd corkscrew
       ./configure
       make install

    Presuming no errors, `corkscrew` is now installed in `/usr/local/bin` on your
    machine. If you want to put it somewhere else, use the `--prefix= _path_` flag
    to the `configure` script.

3. Add `ProxyCommand` to your SSH config file:

    You may or may not have a configuration file for SSH already. It should be located in `$HOME/.ssh/config` and is a simple text file. Create one if it does not exist and add lines such as these to it:

        Host *
          ProxyCommand corkscrew _http-proxy.example.com_ 8080 %h %p

    ... replacing `_http-proxy.example.com_` with the name or address of your http
    proxy and possibly replacing `8080` with the port on which the proxy listens,
    which may be 80 or even some other port. The `%h` and `%p` will be replaced
    automatically by SSH with the actual destination host and port.

    These two lines tell the SSH client to start another program (`corkscrew`) to
    make the actual connection to the SSH server. The `Host *` line says that this
    will be done for **ALL** hosts. If you wish to restrict the hosts for which
    this will be done, you can put a limited form of regular expression there. See
    the `ssh_config(5)` man page for more information. If you don't have
    `corkscrew` in your path or have put it in a non-standard location, you may
    specify an absolute path to `corkscrew` in that file as well.

  4. Try it out...

          ssh _example.net_

      ... replacing `_example.net_` with the name of a host to which you can connect
      using SSH. Presumably this host will be outside your local network and
      therefore require the use of the proxy server. If it is not outside your local
      network, then the connection may fail as the proxy-server or some firewall may
      be configured to **not** redirect proxy connections back into your local
      network.

      Either of the following two errors probably indicate an error in your
      `~/.ssh/config` file, most likely the name or port of the proxy server.

         ssh_exchange_identification: Connection closed by remote host
         _[ OR ]_
         ssh: connection to host example.net port 22: Connection timed out

**Congratulations** \- you are using an http-proxy server with SSH. Anything
you can do with SSH you should now be able to do through the proxy server,
including tunneling of other ports or even ppp.

# Authenticated proxy connections

Some proxy servers require authentication. In this case, you can add
authentication credentials to the `ProxyCommand` line:

    Host *
      ProxyCommand corkscrew _http-proxy.example.com_ 8080 %h %p
~/.ssh/proxyauth

In the `~/.ssh/proxyauth` file, put your proxy login and password like this:

    <username>:<password>

`Corkscrew` should now happily use that authentication information and tunnel
your connection through the proxy.

## Auto-Proxy detection and usage

See [this other post for how to automatically detect proxy-server availability and necessity]({% post_url 2004-01-31-ssh-auto-proxy-script %})
