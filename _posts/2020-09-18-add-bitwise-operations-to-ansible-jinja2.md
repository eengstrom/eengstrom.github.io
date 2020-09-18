---
layout: post
title:  Add Bitwise Operations to Ansible/Jinja2
description:  Add Bitwise Operations to Ansible/Jinja2
date:   2020-09-18 16:54:57 -0500
tags:   Add Bitwise Operations to Ansible/Jinja2
excerpt_separator: <!--more-->
---

I just ran into a reason to have a bitwise shift in an Ansible / Jinja2 template.  No problem, this is a thing already, right?  Nope.  In fact, [bitwise operations in Jinja have been dismissed since 2013][bitwise-ops-request].  WTF?

[bitwise-ops-request]: https://github.com/pallets/jinja/issues/249

<!--more-->

Fine, let's do it ourselves.  It's actually quite trivial to define a custom filter for Ansible to accomplish this, putting this into a file called  `playbooks/filter_plugins/bitwise.py`:

```python
#!/usr/bin/python
# Add some bitwise filters to ansible / jinja2; deemed not essential:
#  - https://github.com/pallets/jinja/issues/249
# Basic filter intro example:
#  - https://dev.to/aaronktberry/creating-custom-ansible-filters-29kf

class FilterModule(object):
    def filters(self):
        return {
            'bitwise_and': self.bitwise_and,
            'bitwise_or': self.bitwise_or,
            'bitwise_xor': self.bitwise_xor,
            'bitwise_complement': self.bitwise_complement,
            'bitwise_shift_left': self.bitwise_shift_left,
            'bitwise_shift_right': self.bitwise_shift_right,
        }

    def bitwise_and(self, x, y):
        return x & y

    def bitwise_or(self, x, y):
        return x | y

    def bitwise_xor(self, y, x):
        return x ^ y

    def bitwise_complement(self, x):
        return ~ x

    def bitwise_shift_left(self, x, b):
        return x << b

    def bitwise_shift_right(self, x, b):
        return x >> b
```

... et voilà; you can now put something like this into Jinja expressions:

```
{% raw %}{{ id | bitwise_shift_left(16) }}:65536{% endraw %}
```
