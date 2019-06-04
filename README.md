<p align="center">
    <img src="https://raw.githubusercontent.com/piknotech/SFSafeSymbols/stable/Logo.png" width=600>
</p>

<p align="center">
    <a href="https://travis-ci.org/piknotech/SFSafeSymbols">
        <img src="https://travis-ci.org/piknotech/SFSafeSymbols.svg?branch=stable" alt="Build Status">
    </a>
    <a href="#">
        <img src="https://img.shields.io/badge/swift-5.1-FFAC45.svg" alt="Swift: 5.1">
    </a>
    <a href="https://github.com/piknotech/SFSafeSymbols/releases">
        <img src="https://img.shields.io/badge/version-0.1-blue.svg"
        alt="Version: 0.1">
    </a>
    <a href="#">
    <img src="https://img.shields.io/badge/Platforms-iOS-FF69B4.svg"
        alt="Platforms: iOS">
    </a>
    <a href="https://github.com/piknotech/SFSafeSymbols/blob/stable/LICENSE.md">
        <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License: MIT">
    </a>
    <a href="https://github.com/apple/swift-package-manager">
        <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="Swift Package Manager: Compatible">
    </a>
    <a href="https://github.com/JamitLabs/Accio">
        <img src="https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat" alt="Accio: supported">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage: compatible">
    </a>
</p>

<p align="center">
    <a href="#documentation">Documentation</a>
  • <a href="https://github.com/piknotech/SFSafeSymbols/issues">Issues</a>
  • <a href="https://github.com/piknotech/SFSafeSymbols/pulls">Pull Requests</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
</p>

## Motivation

At WWDC 2019, Apple announced a new library of icons that come included with iOS 13. To browse them, there's even a [dedicated Mac app](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/) called SF Symbols. However, developers still have to copy the name of an icon and reference it unsafely, resulting in code like this:

```swift
let image = UIImage(systemName: "circle.fill")
```

Just a little bit later, first [ideas came up](https://twitter.com/simjp/status/1135642837322588161?s=12) to make these icons accessible in a safe way using a framework. And this is just what this framework does!

## Installation

SFSafeSymbols can be installed via Swift Package Manager, Accio or Carthage:

### Swift Package Manager

To integrate using Apple's Swift package manager, add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/piknotech/SFSafeSymbols.git", .upToNextMajor(from: "0.1"))
```

After specifying `"SFSafeSymbols"` as a dependency of the target in which you want to use it, run `swift package update`.

### Accio

Do the same configurations as for Swift PM, then run `accio update` instead of `swift package update`.

### Carthage

Make the following entry in your Cartfile:

```
github "piknotech/SFSafeSymbols" ~> 0.1
```

Then run `carthage update`.

## Contributing

See the file [CONTRIBUTING.md](https://github.com/piknotech/SFSafeSymbols/blob/stable/CONTRIBUTING.md).

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See [LICENSE.md](https://github.com/piknotech/SFSafeSymbols/blob/stable/LICENSE.md) for details.
