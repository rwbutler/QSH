![QSH](https://github.com/rwbutler/QSH/raw/master/docs/images/qsh.png)

[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
[![Twitter](https://img.shields.io/badge/twitter-@ross_w_butler-blue.svg?style=flat)](https://twitter.com/ross_w_butler)

QSH is the interactive shell for playing quizzes through the macOS Terminal.

## ⚠️ Work In Progress

This package is considered work in progress until reaching version 1.0.0.

Table of contents:

- [Quickstart](#quickstart)
- [Features](#features)
	- [Supported Features](#supported-features)
	- [Upcoming Features](#upcoming-features)
- [Installation](#installation)
- [Usage](#usage)
	- [Packaging a Quiz](#packaging-a-quiz)
	- [Play a Quiz](#play-a-quiz)
	- [Help](#help)
- [Author](#author)
- [Additional Software](#additional-software)
	- [Frameworks](#frameworks)
	- [Tools](#tools)

## Quickstart

To play an example quiz:

```bash
qsh --url "https://raw.githubusercontent.com/rwbutler/QSH/master/examples/example.quiz" --key "A%D*F-JaNdRgUkXp2s5v8y/B?E(H+KbP"
```

To package an example quiz:

```bash
 qsh package-quiz --input "https://raw.githubusercontent.com/rwbutler/QSH/master/examples/quiz.json" --encrypt-package --key "A%D*F-JaNdRgUkXp2s5v8y/B?E(H+KbP" --output "file://<output path>"
```

## Features

### Supported Features

- [x] Package quizzes for distribution
- [x] Short answer questions
- [x] Picture round questions
- [x] Manual marking via sending answers to Slack via a web hook URL

### Upcoming Features

- [ ] Automatic marking
- [ ] Multiple answer questions
- [ ] Multiple choice questions

## Installation

To install via [Homebrew](https://brew.sh) run the following command from the Terminal:

```bash
brew install rwbutler/tools/qsh
```

## Usage

### Packaging a Quiz

```bash
qsh package-quiz --input file://<path to quiz JSON> --encrypt-package --key <encryption key> --output file://<path to quiz package>
```

### Play a Quiz

```bash
qsh play-quiz --url <quiz package URL> --key <encryption key>  
```

### Help

```bash
qsh --help
```

Or to get help on a specific subcommand:

```bash
qsh package-quiz --help
```

```bash
qsh play-quiz --help
```

## Author

[Ross Butler](https://github.com/rwbutler)

## Additional Software

### Controls

* [AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) - Powerful gradient animations made simple for iOS.

|[AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) |
|:-------------------------:|
|[![AnimatedGradientView](https://raw.githubusercontent.com/rwbutler/AnimatedGradientView/master/docs/images/animated-gradient-view-logo.png)](https://github.com/rwbutler/AnimatedGradientView) 

### Frameworks

* [Cheats](https://github.com/rwbutler/Cheats) - Retro cheat codes for modern iOS apps.
* [Connectivity](https://github.com/rwbutler/Connectivity) - Improves on Reachability for determining Internet connectivity in your iOS application.
* [FeatureFlags](https://github.com/rwbutler/FeatureFlags) - Allows developers to configure feature flags, run multiple A/B or MVT tests using a bundled / remotely-hosted JSON configuration file.
* [FlexibleRowHeightGridLayout](https://github.com/rwbutler/FlexibleRowHeightGridLayout) - A UICollectionView grid layout designed to support Dynamic Type by allowing the height of each row to size to fit content.
* [Hyperconnectivity](https://github.com/rwbutler/Hyperconnectivity) - Modern replacement for Apple's Reachability written in Swift and made elegant using Combine. An offshoot of the [Connectivity](https://github.com/rwbutler/Connectivity) framework.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Cheats](https://github.com/rwbutler/Cheats) |[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Hyperconnectivity](https://github.com/rwbutler/Hyperconnectivity) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Cheats](https://raw.githubusercontent.com/rwbutler/Cheats/master/docs/images/cheats-logo.png)](https://github.com/rwbutler/Cheats) |[![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Hyperconnectivity](https://raw.githubusercontent.com/rwbutler/Hyperconnectivity/master/docs/images/hyperconnectivity-logo.png)](https://github.com/rwbutler/Hyperconnectivity) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-logo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Clear DerivedData](https://github.com/rwbutler/ClearDerivedData) - Utility to quickly clear your DerivedData directory simply by typing `cdd` from the Terminal.
* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)
