<p align="center">
    <img src="https://raw.githubusercontent.com/piknotech/SFSafeSymbols/stable/Logo.png" width=600>
</p>

<p align="center">
    <a href="#">
        <img src="https://img.shields.io/badge/swift-5.1-FFAC45.svg" alt="Swift: 5.1">
    </a>
    <a href="https://github.com/piknotech/SFSafeSymbols/releases">
        <img src="https://img.shields.io/badge/version-0.1.1-blue.svg"
        alt="Version: 0.1.1">
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
    <a href="#motivation">Motivation</a>
  • <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
  • <a href="https://github.com/piknotech/SFSafeSymbols/issues">Issues</a>
  • <a href="https://github.com/piknotech/SFSafeSymbols/pulls">Pull Requests</a>
</p>

## Motivation

At WWDC 2019, Apple announced a new library of icons that come included with iOS 13. To browse them, there's even a [dedicated Mac app](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/) called SF Symbols. However, developers still have to copy the name of an icon and reference it unsafely, resulting in code like this:

```swift
let image = UIImage(systemName: "circle.fill")
```

It didn't took long until [first ideas came up](https://twitter.com/simjp/status/1135642837322588161?s=12) to make these icons accessible in a safe way using a framework. And this is just what this framework does!

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

## Usage

All the system icons are accessible via the `SFSymbol` enum. They are named similar to Apple's naming, but use a lower camel case style and prefix names with leading numbers with a `_` character:

```
c.circle        ==> SFSymbol.cCircle
e.circle.fill   ==> SFSymbol.eCircleFill
11.circle.fill  ==> SFSymbol._11CircleFill
```

You can now either create the corresponding `UIImage` by initializing it using the `SFSymbol`...

```swift
let image = UIImage(systemSymbol: .cCircle)
let image2 = UIImage(systemSymbol: .eCircleFill, withConfiguration: /* Some UIImage.Configuration */)
let image3 = UIImage(systemSymbol: ._11CircleFill, compatibleWith: /* Some UITraitCollection */)
```

... or by calling a function on your  `SFSymbol` instance:

```swift
let image = SFSymbol.cCircle.toImage
let image2 = SFSymbol.eCircleFill.toImage(withConfiguration: /* Some UIImage.Configuration */)
let image3 = SFSymbol._11CircleFill.toImage(compatibleWith: /* Some UITraitCollection */)
```

... or create a `SwiftUI.Image` by initializing it using the `SFSymbol`...

```swift
Image(systemSymbol: .cCircle)
```

All symbols are tested so you can be sure your code won't crash because an image couldn't be found!

## Contributing

Contributions are very much welcomed! See [CONTRIBUTING.md](https://github.com/piknotech/SFSafeSymbols/blob/stable/CONTRIBUTING.md) for more information.

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See [LICENSE.md](https://github.com/piknotech/SFSafeSymbols/blob/stable/LICENSE.md) for details.
