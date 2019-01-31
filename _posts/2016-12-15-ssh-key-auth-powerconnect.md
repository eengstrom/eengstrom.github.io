---
layout: post
title: SSH Key Auth on Dell PowerConnect Switches
date: '2016-12-15 09:08:19 -0600'
tags: admin, ssh, fallor-ergo-sum
---

Today, I tried to setup `ssh` public keys on my Dell PowerConnect Switches,
figuring that good key authentication should be more secure and easier than
simple password auth, right? Clearly someone is in the camp of
[_fallor ergo sum_][fallor]
on this one, and I suppose it might be me.

Sure, it's possible to configure the ssh server on the switch to require
public-key authentication (can't you just hear that *"However"* hovering?):

    sw# conf
    sw(config)# ip ssh server
    sw(config)# ip ssh pubkey-auth
    sw(config)# username bob password xxxxxxxxxxxxx
    sw(config)# crypto key pubkey-chain ssh
    sw(config-pubkey-chain)# user-key bob rsa
    sw(config-pubkey-key)# key-string
    sw(config-pubkey-key)# exit
    sw(config-pubkey-chain)# exit
    sw(config)# exit

That's about it. Unfortunately, it turns out that to Dell, this form of
public-key authentication is akin to two-factor auth.  That is, it's a layer on top of
password auth. You need the key to get the login prompt, at which point you
can login with any set of credentials. **HOWEVER**, you can't bypass the password
based login completely.  Sure, one could use empty password accounts, but that
wasn't the point of this experiment.

If by chance you still feel the need to experiment with this, make sure you
don't let all your active connections time out while in some inconsistent or
intermediate state, e.g. requiring keys, but not have any keys setup,
otherwise you could easily find yourself locked out via ssh and have to resort
to console/line access.

**References that (sort of) helped:**

  * <http://en.community.dell.com/support-forums/network-switches/f/866/t/19458096>
  * <http://en.community.dell.com/support-forums/network-switches/f/866/t/19485199>
  * <http://www.admlife.de/2013/02/06/dell-about-ssh-key-authentication-on-powerconnect-m6220>

That's in addition to the normal command reference manual for the PowerConnect
switches, which is terrible by the way - longer separate discussion there.

[fallor]: https://en.wikipedia.org/wiki/Cogito,_ergo_sum#Predecessors
