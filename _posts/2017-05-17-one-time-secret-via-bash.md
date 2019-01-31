---
layout: post
title: Command-line or script access to One-Time-Secret
date: '2017-05-17 13:19:06 -0500'
tags: bash, security
---

I've been playing with
[OneTimeSecret][ots], and wanted `bash` scripted access to it.  I had to write it myself.

[OneTimeSecret][ots] is a nice little service that allows
you to share a secret with someone else and know that it can only be viewed
once. Additional features such as Time To Live (TTL) and Encrypted secrets,
plus direct email to the intended recipient are nice bonuses.

However, I was wanting to incorporate the sharing of secrets into a shell
script, and while the RESTful API is helpful, and I could have used `curl`, I
decided that I could easily provide a simpler interface with functions for
scripts and a command line interface.
[Check it out on GitHub](https://github.com/eengstrom/onetimesecret-bash).

[ots]: http://onetimesecret.com
