---
layout: post
title:  Self-Signed TLS Certs v. Chrome on MacOS Catalina
description:  Self-Signed TLS Certs v. Chrome on MacOS Catalina
date:   2020-02-11 11:06:10 -0600
tags:   TLS openssl certificate chrome MacOS Catalina
excerpt_separator: <!--more-->
---

Chrome on MacOS Catalina is especially persnickety when it comes to (self-signed) certificates, due in part, I believe, to [Apple's new certificate requirements for macOS 10.15 (Catalina) and iOS 13][apple-cert-requirements].

[apple-cert-requirements]: https://support.apple.com/en-us/HT210176

<!--more-->

Having recently upgraded to MacOS Catalina, things seemed fine.  Then, I was recreating a local testing server self-signed TLS certificate, and Chrome was *NOT* happy.  Where I would have normally expected an warning about a self-signed certificate, and an option to "*Proceed to test.DOMAIN*", I was instead faced with a very different warning:

> NET::ERR_CERT_INVALID
>
> `host.domain` normally uses encryption to protect your information. When Google Chrome tried to connect to `host.domain` this time, the website sent back unusual and incorrect credentials. This may happen when an attacker is trying to pretend to be `host.domain`, or a Wi-Fi sign-in screen has interrupted the connection. Your information is still secure because Google Chrome stopped the connection before any data was exchanged.
>
> You cannot visit `host.domain` right now because the website sent scrambled credentials that Google Chrome cannot process. Network errors and attacks are usually temporary, so this page will probably work later.

"Scrambled credentials"?  Really?  Someone was having fun with words, but that is untrue, and very unhelpful.  In fact the certificate was a perfectly valid, albeit self-signed, certificate.  Though, as it turns out, [Apple instituted some new requirements on all TLS certificates for macOS 10.15 and iOS 13][apple-cert-requirements], the upshot of which is that even self-signed certificates issued after July 1st, 2019 must have the *Subject Alternative Name* (`=DNS:<CN>`) and *Extended Key Usage* (`=id-kp-serverAuth`) extensions.  A more detailed read of some of this is also [available from Daniel Nashed][nashed].

[nashed]: http://blog.nashcom.de/nashcomblog.nsf/dx/more-strict-server-certificate-handling-in-ios-13-macos-10.15.htm?opendocument&comments


I was able to test certificates without those two extensions under Chrome, Firefox, and Safari on macOS Catalina (10.15), Mojave (10.14), Ubunutu 18.04, and Windows 10.  The really interesting part is of all those combinations, **only** Chrome on Catalina gives an error that **cannot be bypassed** by a typical "Proceed anyway/I accept the risks" button.    That's despite the apparent use by Chrome of Apple's certificate validation and storage (via the macOS KeyChain) of certificates and exceptions.   Safari on Catalina still gives the "self-signed" error with a "proceed anyway" option; Chrome does not.

---
**Aside:** [Chrome includes an secret bypass keyword if you type `thisisnotsafe`][thisisnotsafe] (previously `badidea`) into the browser error window.   That bypasses the certificate error, adding the typical exception which can be reset using the "reenable warnings" by viewing the certificate for a given webserver.

[thisisnotsafe]: https://stackoverflow.com/questions/35274659/does-using-badidea-or-thisisunsafe-to-bypass-a-chrome-certificate-hsts-error

---

If you still can't get a real signed certificate (such as free ones via [LetsEncrypt](https://letsencrypt.org/)), then this snippet will generate a "properly configured" certificate, albeit still self-signed, that complies to Apple's new restrictions:

```bash
hostname="host.domain.com"
subject="/C=US/ST=State/L=City/O=Organization/CN=${hostname}"
filename=server
openssl req \
    -newkey rsa:2048  -nodes  -keyout ${filename}.key \
    -new -x509 -sha256 -days 365 -out ${filename}.pem \
    -subj "${subject}" \
    -addext "subjectAltName = DNS:${hostname}" \
    -addext "extendedKeyUsage = serverAuth"
```

Or, with a older OpenSSL/LibreSSL (such as default version on macOS), replace with with:

```bash
confdir=$(openssl version -d | awk -F'"' '{print $2}')
openssl req \
    -newkey rsa:2048  -nodes  -keyout ${filename}.key \
    -new -x509 -sha256 -days 365 -out ${filename}.pem \
    -subj "${subject}" \
    -extensions SAN -reqexts SAN \
    -config <(cat ${confdir}/openssl.cnf;
              printf "[SAN]\nsubjectAltName=DNS:${hostname}\nextendedKeyUsage=serverAuth")
```

---
**NOTE**: Security of your certificate (and key) are your responsibility.  The above example is for illustration purposes and generates a key with **no** passphrase.  **YOU take all responsibility** for any use or mis-use of that code-fragment or the certificate/key-pair it generates.

---

You can see the additional extensions in the generated certificate:

```
$ openssl x509 -in server.pem -text -noout
[...]
        X509v3 extensions:
            X509v3 Subject Alternative Name:
                DNS:`host.domain`
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
```

When loaded, Chrome now gives it's typical "self-signed certificate" warning, which states:

> NET::ERR_CERT_AUTHORITY_INVALID
>
> This server could not prove that it is `host.domain`; its security certificate is not trusted by your computer's operating system. This may be caused by a misconfiguration or an attacker intercepting your connection.
>
> "Proceed to `host.domain` (unsafe)"

If, instead, you get a slightly different variant complaining about **HSTS**:

> NET::ERR_CERT_AUTHORITY_INVALID
>
> You cannot visit `host.domain` right now because the website uses HSTS. Network errors and attacks are usually temporary, so this page will probably work later.

... that's because you probably have an older, or just different, certificate cached by Chrome.  Use the `chrome://net-internals/#hsts` page to query/delete entries for your `host.domain`.  In Safari, you may have to simply clear all history, or [get into the weeds with Jeff Geering][hsts-safari]  See also [this for Firefox][hsts-firefox].

[hsts-firefox]: https://www.thesslstore.com/blog/clear-hsts-settings-chrome-firefox/
[hsts-safari]: https://www.jeffgeerling.com/blog/2018/fixing-safaris-cant-establish-secure-connection-when-updating-self-signed-certificate


---

With thanks to other posts as well:

- https://serverfault.com/questions/845766/generating-a-self-signed-cert-with-openssl-that-works-in-chrome-58
- https://security.stackexchange.com/questions/74345/provide-subjectaltname-to-openssl-directly-on-the-command-line
- https://stackoverflow.com/questions/37035300/how-to-determine-the-default-location-for-openssl-cnf
