---
layout: post
title:  Enable SSH Key Authentication for Dell CMC or iDRAC
description:  Enable SSH Key Authentication for Dell CMC or iDRAC
date:   2020-02-06 21:47:10 -0600
tags:   ssh dell cmc
excerpt_separator: <!--more-->
---

Dell's embedded systems controllers, both the iDRAC and CMC (chassis management controller), are very useful, if utterly cryptic, tools for remote management.  Life with them can become slightly easier if you know how to import your `ssh` public keys for authentication, thus avoiding yet-another-password-prompt.

<!--more-->

Assuming you've already configured your CMC or iDRAC for `ssh` access, you can already login to the using `ssh root@cmc` (default password: `calvin`), or your user-defined username/password.  When using key-based authentication, you will use the service account (aka `svcacct`) username, which defaults to `service`.  The examples below work to view and configure `ssh`-key authentication for Dell M1000E CMCs, but should be adaptable directly to any iDRAC as well.

Note that I am not describing how to create keys, but note that you will need to use an RSA key.  You can technically use DSA keys, but those are insecure and should **not** be used.  Newer key types, such as elliptic curve keys, are not supported by the CMC.  For security, I recommend making RSA keys that are at least 2048 bits and have a good passphrase.

## Managing CMC SSH Public Keys

Ensure you have the latest version `racadm` on your machine, or use `ssh` access by username (`ssh root@cmc`).   For each of the command examples below, if you are using `racadm` from your local control node, you will need to add options to specify the remote device (`-r CMC`), username (`-u USER`), and password (`-p PASS`). e.g.:

```bash
# via CMC directly
racadm sshpkauth -i svcacct -k all -v

# or on your control node, via `racadm`:
racadm -r CMC -u root -p calvin sshpkauth –i svcacct –k all –v
```

I will leave off the three extra parameters for control node usage in most examples below.

### View Current Configuration

To view all keys on your CMC:

```bash
CMC $ racadm sshpkauth -i svcacct -k all -v
Key 1=UNDEFINED
Key 2=UNDEFINED
Key 3=UNDEFINED
Key 4=UNDEFINED
Key 5=UNDEFINED
Key 6=UNDEFINED
Privilege 1=0x0
Privilege 2=0x0
Privilege 3=0x0
Privilege 4=0x0
Privilege 5=0x0
Privilege 6=0x0
```

Note that there are 6 key slots for the `svcacct`.  To view only one key at a time, replace `all` with a number (1 – 6):
```bash
CMC $ racadm sshpkauth -i svacct -k 1 -v
Key=UNDEFINED
Privilege=0x0
```
### Add or Update a Key

To add or change an existing public key in slot `ID`:
```
```bash
CMC $ racadm sshpkauth -i svcacct -k ID -p 0xfff -t 'PUBLIC KEY TEXT`
# or if via the `racadm` on a control node directly from a file:
HOST $ racadm -r CMC -u USER -p PASSWORD sshpkauth –i svcacct –k ID –p 0xfff –f ~/.ssh/id_rsa.pub
PK SSH Authentication Key file successfully uploaded to the RAC

```

Note that the `-p 0xfff` option is granting users of that public key **full** privileges for subsequent commands (e.g. `connect`).

### Delete a Key

```bash
CMC $ racadm sshpkauth -i svcacct -k ID -d
# or
CMC $ racadm sshpkauth -i svcacct -k all -d
```

### Test SSH Key-Authentication

With a key uploaded to at least one slot in the CMC, you should be able to test your `ssh` connection using the service account:

```bash
HOST $ ssh service@CMC
Welcome to PowerEdge M1000e CMC firmware version 6.21
```

Reminder, the only account that uses public key authentication is the `svcacct` (i.e. `service`).  You can continue to `ssh` as any other user, providing that user's password.


### Troubleshooting

I have noted that if you have multiple ssh-keys loaded into your `ssh-agent`, if `ssh` **ever** offers a key that does not successfully authenticate, e.g. a newer elliptic curve key, but then does offer the correct (RSA) key, you will be given a shell and logged in, but then subsequent commands will fail with a message such as:

    ... insufficient user privileges for console redirection

In this case, tell `ssh` to prefer a specific key via the `IdentityFile` option, either on the command line:

    ssh -i ~/.ssh/id_rsa service@CMC

or via options in your `~/.ssh/config` file:

    Host *-cmc *-drac
      User service
      # workaround for multiple keys causing permissions issues:
      IdentityFile ~/.ssh/id_rsa
      # offer **only** that key:
      IdentitiesOnly yes

Depending on your version of `ssh`, the `IdentitiesOnly` option is not required, but does ensure that **only** the provided key is ever offered.
