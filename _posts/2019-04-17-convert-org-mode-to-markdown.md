---
layout: post
title:  Convert org-mode to markdown
description:  Convert org-mode to markdown
date:   2019-04-17 14:12:14 -0500
tags:   org-mode markdown pandoc
excerpt_separator: <!--more-->
---

I'm sure this is going to seem trivial, but I spent way too much time looking for a way to convert my `emacs` `org-mode` notes into (github flavored) markdown.
<!--more-->
You see, I've been an `emacs` user for so long, that I assumed the only way to do it was from within `emacs`, but I finally found `pandoc`. So trivially:

    pandoc --from=org --to=gfm org-mode-file.org > markdown.md

For more options, check out the [Pandoc Manual](https://pandoc.org/MANUAL.html).

In case you are wondering, I've finally gotten off of `emacs` and switched to [`atom`](https://atom.io/).  I still use the `emacs` style keybindings, as my hands are faster that way.
