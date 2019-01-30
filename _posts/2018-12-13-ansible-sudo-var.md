---
layout: post
title:  Automatically retrieve password for Ansible's `become_pass` from external password store
description: Automatically retrieve password for Ansible's `become_pass` from external password store
date:   2018-12-13 13:00:00 -0600
tags:   ansible, password, keyring, 1password
---

Just learning Ansible, I quickly became tired of repeatedly typing my remote user password to allow `ansible[-playbook]` to become root on the remote system via `sudo`.  I toyed with the idea of using [`ansible_vault`](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html), as many have suggested (here: [1][1],[2][2],[3][3],[4][4]), which looks something like this snippet (e.g. from a `{host,group}_vars/*` file):

    {% raw %}
    ansible_user: USER
    ansible_become_pass: "{{ vault_ansible_become_pass }}"
    {% endraw %}

While that works, problem is that even if you pull the password out of a vault, you still have to supply the vault password - no improvement yet.  So, how about storing the vault password into a file and reference it from your `ansible.cfg` config file like this:

    vault_password_file = ./.vault_pass

Also works, and you don't have to type any password for each playbook execution.  However, now we have the vault password is in clear text in a file on the file system, and therefore have our sudo password effectively visible as well.  Not terribly secure, and certainly not wise for multi-user control node situations either.

Instead, I decided thought to use [`lookup()`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_lookups.html) and one of the various [lookup plugins](https://docs.ansible.com/ansible/latest/plugins/lookup.html) that target secure vault- or password-stores, including:
 * [HashiCorp Vault](https://docs.ansible.com/ansible/latest/plugins/lookup/hashi_vault.html)
 * [LastPass](https://docs.ansible.com/ansible/latest/plugins/lookup/lastpass.html)
 * [OSX Keyring](https://docs.ansible.com/ansible/latest/plugins/lookup/keyring.html)
 * [1Password](https://docs.ansible.com/ansible/2.6/plugins/lookup/onepassword.html)
 * [PasswordStore](https://docs.ansible.com/ansible/latest/plugins/lookup/passwordstore.html)

Using the 1Password as an example, put something like this into a file named `credentials`:

    {% raw %}
    ansible_ssh_user: USER
    ansible_become_pass: "{{ lookup('onepassword', 'KEYNAME|KEYUID', errors='warn') | d(omit) }}"
    {% endraw %}

... then sign-in to your 1Password vault:

    $ eval $(op signin my_team)

Finally, putting this into play, you run a playbook with one extra option referencing the credentials vars file:

    $ ansible-playbook playbook.yml -e @credentials [-other-options...]

Alternatively, using the OSX `keyring` lookup plugin:

    pip install keyring

Then, set your password in your keyring:

    keyring set ansible-sudo USER

Finally, modify the `credentials` file created earlier:

    {% raw %}
    ansible_ssh_user: USER
    ansible_become_pass: "{{ lookup('keyring, 'ansible-sudo USER') | d(omit) }}"
    {% endraw %}

Should work the same as the 1Password option on the command line:

    $ ansible-playbook playbook.yml -e @credentials [-other-options...]

## Caveats and Warnings:

 * IF you do this, you take all responsibility for keeping your passwords secure.  You are creating a risk path for someone to retrieve your password(s) from your control system.  This is **NOT** my problem.  This is for example only.

 * Setting the variable `ansible_become_pass` in a inventory, role, or play takes precedence over the `-K` (`--ask-become-pass`) provided value.  This is because during CLI argument parsing, Ansible can't know what inventory or plays are to be used.  (see [this](https://github.com/ansible/ansible/issues/42875))

 * Since you [can't yet unset variables](https://github.com/ansible/ansible/issues/24136), there is very little you can do to condititionalize the inclusion of these variables in any specific playbook, hence using external variables files that are referenced on the command line.

 * Using Ansible's -K doesn't actually set the value of the variable `ansible_become_pass`, so you can't check it in your plays and set it conditionally.  This I find surprising and frustrating, but I suppose if it were not this way, then variable handling would be different for some variables (like this one) than others.

For anyone digging further into the details of these ideas, I suggest these are required reading:

 * [Understanding Privilege Escalation](https://docs.ansible.com/ansible/latest/user_guide/become.html)
 * [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

[1]: https://www.cyberciti.biz/faq/how-to-set-and-use-sudo-password-for-ansible-vault/
[2]: https://serverfault.com/questions/686347/ansible-command-line-retriving-ssh-password-from-vault
[3]: https://stackoverflow.com/questions/37297249/how-to-store-ansible-become-pass-in-a-vault-and-how-to-use-it
[4]: http://samdoran.com/ansible-vault-and-macos-keychain-access/
