![QSH](https://github.com/rwbutler/QSH/raw/master/docs/images/qsh-banner.png)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frwbutler%2FQSH%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/rwbutler/QSH)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frwbutler%2FQSH%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/rwbutler/QSH)
[![Twitter](https://img.shields.io/badge/twitter-@ross_w_butler-blue.svg?style=flat)](https://twitter.com/ross_w_butler)

QSH is the interactive shell for playing quizzes through the macOS Terminal.

It is built on top of [SwiftQuiz](https://github.com/rwbutler/swift-quiz) which provides the core functionality for making and playing quizzes in Swift. QSH provides the UI for accessing all of that functionality using the macOS Terminal.

<br/>
<div align="center">
    <img src="https://github.com/rwbutler/QSH/raw/master/docs/images/screenshot.png" alt="QSH screenshot" width="80%">
</div>

## ⚠️ Work In Progress

This package is considered work in progress until reaching version 1.0.0.

Table of contents:

- [Quickstart](#quickstart)
- [Features](#features)
	- [Supported Features](#supported-features)
	- [Upcoming Features](#upcoming-features)
- [Installation](#installation)
	- [Homebrew](#homebrew)
	- [Mint](#mint)
	- [Swift Package Manager](#swift-package-manager)
- [Usage](#usage)
	- [Packaging a Quiz](#packaging-a-quiz)
		- [Encrypted / Unencrypted Quiz Packages](#encrypted-unencrypted-quiz-packages)
		- [Picture Rounds](#picture-round)
	- [Play a Quiz](#play-a-quiz)
	- [Help](#help)
- [Developing a Quiz Client](#developing-a-quiz-client)
- [Author](#author)
- [Additional Software](#additional-software)
	- [Frameworks](#frameworks)
	- [Tools](#tools)

## Quickstart

### To play an example quiz:

```bash
qsh --url https://github.com/rwbutler/QSH/raw/master/examples/example-playable-quiz.quiz --key A%D*F-JaNdRgUkXp2s5v8y/B?E(H+KbP
```

Or:

```bash
qsh --url https://github.com/rwbutler/QSH/raw/master/examples/example-playable-quiz2.quiz --key A%D*F-JaNdRgUkXp2s5v8y/B?E(H+KbP
```

Note: Accepts both HTTP and file URLs which must be proceeded by `file://` e.g. `qsh --url file:///Users/username/Documents/example-playable-quiz.quiz`.

### To package an example quiz:

```bash
 qsh package-quiz --input "https://raw.githubusercontent.com/rwbutler/QSH/master/examples/example-quiz-input.json" --encrypt-package --key "A%D*F-JaNdRgUkXp2s5v8y/B?E(H+KbP" --output "file://<output path>"
```

Note: Accepts both HTTP and file URLs which must be proceeded by `file://` e.g. `qsh package-quiz --url file:///Users/username/Documents/quiz-input.json`.

## Features

### Supported Features

- [x] Package quizzes for distribution
- [x] Short answer questions, multiple answer questions and multiple choice questions
- [x] Picture rounds
- [x] Encrypts quiz packages making it harder to cheat.
- [x] Manual marking via sending answers to Slack via a web hook URL
- [x] Automatic marking

### Upcoming Features
- [ ] Keep participants in sync without the need for a server

## Installation

### Homebrew

To install via [Homebrew](https://brew.sh) run the following command from the Terminal:

```bash
brew install rwbutler/tools/qsh
```

### Mint

To install using [Mint](https://github.com/yonaskolb/Mint) run the following command:

```bash
mint install rwbutler/qsh 
```

### Swift Package Manager

Build using [Swift Package Manager](https://github.com/apple/swift-package-manager) as follows:

```bash
swift build -c release --disable-sandbox 
```

Then run using:

```bash
swift run qsh --help 
```

## Usage

### Packaging a Quiz

```bash
qsh package-quiz --input file://<path to quiz JSON> --encrypt-package --key <encryption key> --output file://<path to quiz package>
```

Note: To generate an AES-256 encryption key use a site such as this [one](https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx).
 
#### Encrypted / Unencrypted Quiz Packages

QSH allows quizzes to be encrypted so that the answers contained within the quiz package cannot be readily be accessed preventing cheating. Use of this feature is optional as quiz packages may be encrypted or unencrypted. In order to encrypt a quiz during packaging, supply a AES-256 key generated using a site such as the one [here](https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx) using the `--key` parameter. If the `--key` parameter is omitted then an unencrypted quiz package will be generated.

#### Picture Rounds

To include a picture round as part of a quiz, include the parameter `image` as part of a short answer, multiple choice or multiple answer question. The value of the `image` parameter should be the URL (either a file URL or HTTP URL) of the image file. When the quiz is packaged, the image data will be included as part of the quiz package so that the images do not need to be downloaded separately at runtime.

#### Automatic Marking

In order to enable automatic marking for a quiz, add the following to your quiz JSON file:

```json
"marking-occurs": "at-end",
```

Take a look [here](https://github.com/rwbutler/QSH/blob/master/examples/quiz.json) for an example.

Alternatively, if you want to mark the old-fashioned way by swapping answers then simply set the `marking-occurs` property to `never`:

```json
"marking-occurs": "never",
```

### Play a Quiz

```bash
qsh play-quiz --url <quiz package URL> --key <encryption key>  
```

Note: The `key` parameter is only required for encrypted packages. 

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

## Developing a Quiz Client
The core functionality for packaging and playing quizzes is implemented by the [Swift Quiz](https://github.com/rwbutler/swift-quiz) package with QSH providing the UI for the macOS Terminal. Should you wish to build your own client for playing quizzes e.g. using Linux, in theory you could do so using [Swift Quiz](https://github.com/rwbutler/swift-quiz).

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
