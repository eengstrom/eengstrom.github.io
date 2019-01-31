---
layout: post
title:  Remap MS Ergonomic Keyboard "Application/Submenu" Key on Mac OS X
description:  Remap Microsoft Ergonomic Keyboard "Application/Submenu" Key on Mac OS X
date:   2019-01-15 15:00:00 -0600
tags:   karabiner, keyboard, macos
excerpt_separator: <!--more-->
---

Some keyboards geared towards Windows have useless keys for a Mac.  Can they be remapped?
<!--more-->
Well, perhaps like me, say you have a pretty nice Microsoft Natural Ergonomic Keyboard attached to your Mac, but it's got this otherwise useless **`Application/Submenu`** key on the right side.  You want it to be something useful, perhaps mimicking the right **`Option/Alt`** key on the standard Apple keyboard.  Here's how you can remap that otherwise useless **`Application`** key to something useful under Mac OS using Karabiner (with thanks to [StackExchange] and [KeyChatter])

* Install Karabiner-Elements

      brew cask install karabiner-Elements

  or install by [downloading installer directly from their website](https://pqrs.org/osx/karabiner/)

* Open Karabiner-Elements application

   This will start karabiner and you should see a new icon in your Mac Menu Bar.

* Add new key-code to karabiner

  You'll need the Event Viewer, so from Mac Menu bar,
  **`Karabiner-Elements >> Launch Event Viewer`**.

  In the **`main`** tab, click on the key you want to be able to remap, e.g. the **`submenu/application`** key on the MS Ergonomic keyboard.  Then, in the upper right of the event-viewer window, you can click on **`add "application" to Karabiner-Elements`**

  That will add the key-code into the list of re-mappable keys via the karabiner preferences.

* Remap the key

  - Open the karabiner **`Preferences >> Simple Modifications`** tab.
  - Select **`target device`** (e.g. Microsoft Ergonomic Keyboard)
  - Click **`Add item`** in the lower left
  - Select **`Application`** as the **`from key`** and then **`right-option`** as the **`to key`**.

[StackExchange]: https://apple.stackexchange.com/questions/173898/repurposing-menu-button-on-windows-keyboards-used-in-os-x
[KeyChatter]: https://www.keychatter.com/2014/08/04/how-to-remap-keys-in-osx-using-keyremap4macbook-now-karabiner/
