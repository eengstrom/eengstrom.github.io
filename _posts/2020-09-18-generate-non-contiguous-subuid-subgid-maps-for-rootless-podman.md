---
layout: post
title:  Generate Non-contiguous subuid/subgid Maps for Rootless Podman
description:  Generate Non-contiguous subuid/subgid Maps for Rootless Podman
date:   2020-09-18 17:17:51 -0500
tags:   rootless, podman, subuid, ansible, idm
excerpt_separator: <!--more-->
---

We are migrating all our use of `docker` to `podman` for our shared servers, mostly to take advantage of the great support for rootless `podman`.  I recently wanted to find a way to stop adding individual users to the `/etc/subuid` and `/etc/subgid` maps, as well as make all the maps be the same across systems to be able to attribute ownership for residual files created in containers on a networked (distributed ceph) file system.  Also, we have a federated IdM setup, so no users are created locally each server, so it has to be globally maintained **and** handle non-contiguous user-id ranges.  Since we already use Ansible to do our configuration, this was easy.

<!--more-->

Ansible playbook fragment:

```yaml
  vars:
    podman_idmap_ranges:
      2000: 2099
      5000: 5299

  tasks:
    - name: podman | define subuid/subgid ranges
      template:
        src: etc/subXid.j2
        dest: "{%raw%}{{ item }}{%endraw%}"
        owner: root
        group: root
        mode: 0644
      with_items:
        - /etc/subuid
        - /etc/subgid
```

Jinja2 template:

```jinja
# {%raw%}{{ ansible_managed }}{%endraw%}
# Rather than create UID/GID maps by username:
#   eric:100000:65536
# this will create maps by UID:
#   1001:65601536:65536
# Moreover, we ensure the maps are non-overlapping regardless of
# login UID/GID by bitwise shifting login id to the left, 16 bits.
# This works since the size of each range is 2^16 == 65536.
# Where that convention comes from, I have no idea.  `useradd`?
# Note that the `bitwise_shift` function is a custom filter.

{%- raw -%}
{% for start, end in podman_idmap_ranges.items() %}
{%   for id in range(start | int, end + 1) %}
{{ id }}:{{ id | bitwise_shift_left(16) }}:65536
{%   endfor %}
{% endfor %}
{% endraw %}
```

Other notes:
  - The jinja template depends on [a custom filter plugin for bitwise operations][bitwise].
  - Someday, this whole file (locally) may be OBE if/when [this `shadow-utils` issue fixed][shadow-utils-issue].
  - Another idea I found would [create maps on login with a pam module][pam-module], but that would allow maps to diverge across multiple systems.

If you have a better solution, I'd love to hear it.

[bitwise]: add-bitwise-operations-to-ansible-jinja2
[shadow-utils-issue]: https://github.com/shadow-maint/shadow/issues/154
[pam-module]: https://lists.fedorahosted.org/archives/list/freeipa-users@lists.fedorahosted.org/thread/5SVWA5UQ7SM3YEHRNMXCIW4HBBS4QVYV/
