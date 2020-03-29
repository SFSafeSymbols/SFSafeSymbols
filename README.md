<p align="center">
    <img src="https://raw.githubusercontent.com/piknotech/SFSafeSymbols/stable/Logo.png" width=600>
</p>

<p align="center">
	<a href="https://app.bitrise.io/app/f9e56287b4a18852#/builds">
		<img src="https://app.bitrise.io/app/f9e56287b4a18852/status.svg?token=PwV0AjHnLm32ht_GGzff3w&branch=stable" alt="Build Status">
	</a>
    <a href="#">
        <img src="https://img.shields.io/badge/swift-5-FFAC45.svg" alt="Swift: 5">
    </a>
    <a href="https://github.com/piknotech/SFSafeSymbols/releases">
    <img src="https://img.shields.io/badge/version-1.2.0-blue.svg"
    alt="Version: 1.2.0">
    </a>
    <a href="#">
    <img src="https://img.shields.io/badge/Platforms-iOS%20|%20tvOS%20|%20watchOS-FF69B4.svg"
        alt="Platforms: iOS – tvOS – watchOS">
    </a>
    <a href="https://github.com/piknotech/SFSafeSymbols/blob/stable/LICENSE.md">
        <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License: MIT">
    </a>
    <br />
    <a href="https://github.com/apple/swift-package-manager">
        <img src="https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg" alt="SwiftPM: Compatible">
    </a>
    <a href="https://github.com/JamitLabs/Accio">
        <img src="https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat" alt="Accio: Supported">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage: Compatible">
    </a>
    <a href="https://cocoapods.org/pods/SFSafeSymbols">
    <img src="https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat" alt="CocoaPods: Compatible">
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
UIImage(systemName: "circle.fill")
```

It didn't take long until [first ideas came up](https://twitter.com/simjp/status/1135642837322588161?s=12) to make these icons accessible in a safe way using a framework. And this is just what `SFSafeSymbols` does!

## Installation

`SFSafeSymbols` can be installed via Swift Package Manager, Accio, Carthage or CocoaPods.

Supported platforms are `iOS (11.0+)`, `tvOS (11.0+)` and `watchOS (6.0+)`, although the actual functionality is of course only accessible starting with `iOS 13.0`, `tvOS 13.0` and `watchOS 6.0`.

### Swift Package Manager

To integrate using Apple's Swift package manager, add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/piknotech/SFSafeSymbols.git", .upToNextMajor(from: "1.2.0"))
```

After specifying `"SFSafeSymbols"` as a dependency of the target in which you want to use it, run `swift package update`.

### Accio

Do the same configurations as for SwiftPM, then run `accio update` instead of `swift package update`.

### Carthage

Add the following entry to your Cartfile:

```
github "piknotech/SFSafeSymbols" ~> 1.2.0
```

Then run `carthage update`.

### CocoaPods

Add the following entry to your Podfile:

```rb
pod 'SFSafeSymbols', '~> 1.2.0'
```

Then run `pod install`.

## Usage

All the system icons are accessible via the `SFSymbol` enum. They are named similar to Apple's names, but use a lower camel case style and prefix names with leading numbers with a `_` character:

```
c.circle        ~> SFSymbol.cCircle
e.circle.fill   ~> SFSymbol.eCircleFill
11.circle.fill  ~> SFSymbol._11CircleFill
```

A SF Symbol `UIImage` can now be initialized using the `SFSymbol` enum. This image is already unwrapped, so you get a `UIImage` instead of a `UIImage?`:

```swift
UIImage(systemSymbol: .cCircle)
UIImage(systemSymbol: SFSymbol.eCircleFill)
UIImage(systemSymbol: ._11CircleFill, withConfiguration: /* Some UIImage.Configuration */)
```

A SF Symbol `SwiftUI.Image` can also be initialized using the `SFSymbol` enum. It's also unwrapped, so you get a `SwiftUI.Image` instead of a `SwiftUI.Image?`:

```swift
Image(systemSymbol: .cCircle)
Image(systemSymbol: SFSymbol.eCircleFill)
```

There also interfaces for `UIButton`:

```swift
let button = UIButton.systemButton(with: .cCircle, target: self, selector: #selector(testMethod))
button.setImage(.eCircleFill, for: .normal)
```

... and an initializer for `UIApplicationShortcutItem`:

```swift
UIApplicationShortcutIcon(systemSymbol: .cCircle)
UIApplicationShortcutIcon(systemSymbol: SFSymbol.eCircleFill)
```

## Testing

**All symbols are tested via a CI** (on the latest iOS & tvOS versions), so you can be sure your code won't crash because an image couldn't be found!

## Contributing

Contributions are very much welcome! See [CONTRIBUTING.md](https://github.com/piknotech/SFSafeSymbols/blob/stable/CONTRIBUTING.md) for more information.

## License
This library is released under the [MIT License](http://opensource.org/licenses/MIT). See [LICENSE.md](https://github.com/piknotech/SFSafeSymbols/blob/stable/LICENSE.md) for details.
