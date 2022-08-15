# flappy-fly-bird [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Language](https://img.shields.io/badge/Language-Swift_5.7-orange.svg)]()
[![Framework](https://img.shields.io/badge/Framework-SpriteKit-red.svg)]()
[![Framework](https://img.shields.io/badge/Framework-GameplayKit-purple.svg)]()
[![Shaders](https://img.shields.io/badge/Shaders-GLSL-green.svg)]()
[![Last Commit](https://img.shields.io/github/last-commit/jvirus/flappy-fly-bird)]()
[![NLOC](https://img.shields.io/tokei/lines/github/jvirus/flappy-fly-bird)]()
[![Contributors](https://img.shields.io/github/contributors/jvirus/flappy-fly-bird)]()
[![Repo Size](https://img.shields.io/github/repo-size/jvirus/flappy-fly-bird)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

![](logo-flappy_fly_bird.png)

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About 
🐦 `Flappy Fly-Bird` is an `iOS/SpriteKit` game written using the latest verion of `Swift` programming language and `GameplayKit`. 

# 📺 Demo 

## Gifs
Please wait while the `.gif` files are loading...

|  |  |
:-------------------------:|:-------------------------:
![](/resources/intro.gif) | ![](/resources/gameplay.gif)
![](/resources/characters.gif) | ![](/resources/cat-gameplay.gif) 


## Screens
<img src="/resources/img-01.PNG" width="49%"> <img src="/resources/img-05.PNG" width="49%">


# ☢️ Caution 
There were used graphical resources such as `audio`, `music` and `images`. Those resources are for non commercial use. If you want to reuse the developments in your projects you **must remove all the assets**.

# 👻 Features
- Supports both `iPhone` & `iPad` devices
- Multiple, animated, selectable characters
- Minimum deployment target is `iOS 11.3`
- `Swift 5.0`
- Uses `GameplayKit` for in-game states: `Playing`, `Deatch`, `Paused` states
- Supports multiple `pipe` types
- Difficulty setting
- `Tile-Based` pipes: uses the mixture of `CoreGraphics` and `SpriteKit` frameworks
- Property list based persistence for `Scores` & `Settings`
- Protocol-Oriented desing in mind

# 📝 Changelog 

## v 1.0
- `Infinite` side-scrolling game 
- `Haptic feedback` on supported devides
- Uses `state machines`
- Utilizes `SpriteKit` editor 
- Uses `CoreGraphics` to construct `tile-based` pipes
- Suported both `iPhone` and `iPad`screens
- Uses simple technique for `persistence` (for `Scores` and `Settings`)

## v 1.3
- `6` playable characters
- `2` pipe types that make gameplay more unpredictable and enjoying

## v 1.4
-  Support for `Difficulty` setting

## v 1.4.5
- Fixed issue that caused the player node to stuck after the death. The issue was caused by multiple death hander calls and jumbing between `Playing` and `Death` states, where some time-dependent actions were run at the same time
- Added full support for `iPhone` `X`, `Xs`, `Xs Max`

## v 1.4.6
- Migration to `Swift 5.0`
- Minor changes

## v 1.4.7
- Minor updated that includes the support for the latest changes in the language and SDK

## v 1.4.8
- Updated to the latest Swift version and lifted the minimum deplayment target to `iOS/iPadOS 12.0` 

## v 1.4.9
- Minor technical updates 

# 🗺 Roadmap
- [x] New playable characters 
- [ ] Unique visual effects for playable characters
- [ ] Achievement system: will be used to unlock new playable characters and visual effects
- [ ] Addition of custom effects when player starts new run and dies
- [ ] Custom scene transitions
- [ ] Game bonuses: another good example of `GameplayKit`usage
- [x] New pipe types
- [ ] Level opening animation
- [x] Setting for game `Difficulty` 

# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence
The project is availabe under the [BSD 3-Clause "New" or "Revised" License](https://github.com/jVirus/ios-spritekit-flappy-flying-bird/blob/master/LICENSE). Remember: you must not use any of the `assets` in commercial purposes.
