<p align="center">
    <img src="https://raw.githubusercontent.com/SFSafeSymbols/SFSafeSymbols/stable/Logo.png" width=600>
</p>

<p align="center">
	<a href="https://app.bitrise.io/app/f9e56287b4a18852#/builds">
		<img src="https://app.bitrise.io/app/f9e56287b4a18852/status.svg?token=PwV0AjHnLm32ht_GGzff3w&branch=stable" alt="Build Status">
	</a>
    <a href="#">
        <img src="https://img.shields.io/badge/swift-5-FFAC45.svg" alt="Swift: 5">
    </a>
    <a href="https://github.com/SFSafeSymbols/SFSafeSymbols/releases">
    <img src="https://img.shields.io/badge/version-4.1.1-blue.svg"
    alt="Version: 4.1.1">
    </a>
    <a href="#">
    <img src="https://img.shields.io/badge/Platforms-iOS%20|%20tvOS%20|%20watchOS%20|%20macOS-FF69B4.svg"
        alt="Platforms: iOS – tvOS – watchOS – macOS">
    </a>
    <a href="https://github.com/SFSafeSymbols/SFSafeSymbols/blob/stable/LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-lightgrey.svg" alt="License: MIT">
    </a>
    <br />
    <a href="https://github.com/apple/swift-package-manager">
        <img src="https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg" alt="SwiftPM: Compatible">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage: Compatible">
    </a>
    <a href="https://cocoapods.org/pods/SFSafeSymbols">
    <img src="https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat" alt="CocoaPods: Compatible">
    </a>
</p>

<p align="center">
    <a href="#idea--features">Idea & Features</a>
  • <a href="#supported-versions">Supported Versions</a>
  • <a href="#installation">Installation</a>
  • <a href="#usage">Usage</a>
  • <a href="#contributing">Contributing</a>
  • <a href="#license">License</a>
  • <a href="https://github.com/SFSafeSymbols/SFSafeSymbols/issues">Issues</a>
  • <a href="https://github.com/SFSafeSymbols/SFSafeSymbols/pulls">Pull Requests</a>
</p>

## Idea & Features

At WWDC 2019, Apple announced a new library of icons that came included with that year's new operating system versions. To browse them, there's a [dedicated Mac app](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/) called SF Symbols. However, developers still have to copy the name of a symbol and reference it unsafely, resulting in code like this:

```swift
UIImage(systemName: "circle.fill")
```

It didn't take long until [first ideas came up](https://twitter.com/simjp/status/1135642837322588161?s=12) to make these icons **accessible in a safe way** using a framework. And this is just the basic idea behind `SFSafeSymbols`!

Furthermore, with `SFSafeSymbols`...

- ... you can be sure your symbol code won't crash due to typos or symbol availability issues. This is because **all symbols are tested via a CI** (on the latest iOS & tvOS versions and also some earlier OS versions).
- ... lookups in the SF Symbols app (e. g. about available **layersets**, available **localizations** & the **look of the symbol**) are no longer needed because every symbol is **documented in code**.
- ... **multiple SF Symbols versions** are supported at the same time (via utilization of the `@availability` flag). Each symbol is only made available on those platform versions where Apple says it's available.
- ... **renamed symbols can be detected easily** (via a deprecation notice which suggests the use of the new name at the same time).

## Supported Versions

The following SF Symbols versions are currently supported:

| SF Symbols Version | iOS Version | macOS Version | tvOS Version | watchOS Version |
| ------------------ | ----------- | ------------- | ------------ | --------------- |
| 1.0 | 13.0 | 11.0 | 13.0 | 6.0 |
| 1.1 | 13.1 | 11.0 | 13.0 | 6.1 |
| 2.0 | 14.0 | 11.0 | 14.0 | 7.0 |
| 2.1 | 14.2 | 11.0 | 14.2 | 7.1 |
| 2.2 | 14.5 | 11.3 | 14.5 | 7.4 |
| 3.0 | 15.0 | 12.0 | 15.0 | 8.0 |
| 3.1 | 15.1 | 12.0 | 15.1 | 8.1 |
| 3.2 | 15.2 | 12.1 | 15.2 | 8.3 |
| 3.3 | 15.4 | 12.3 | 15.4 | 8.5 |
| 4.0 | 16.0 | 13.0 | 16.0 | 9.0 |
| 4.1 | 16.1 | 13.0 | 16.1 | 9.1 |

## Installation

`SFSafeSymbols` can be installed via the **Swift Package Manager (recommended)**, Carthage or CocoaPods.

Supported platforms are `iOS (11.0+)`, `macOS (10.13+)`, `tvOS (11.0+)` and `watchOS (4.0+)`, although the actual functionality is of course only accessible starting with `iOS 13.0`, `macOS 11.0`, `tvOS 13.0` and `watchOS 6.0`.

### Swift Package Manager (Xcode-integrated)

To integrate SFSafeSymbols using the Xcode-built-in SPM, choose `File` → `Swift Packages` → `Add Package Dependency`. Enter the following url: `https://github.com/SFSafeSymbols/SFSafeSymbols` and click `Next`. When asked about the version, leave the preselection and click `Next`. In the following step, select `SFSafeSymbols` as the package product and click `Finish`.

### Swift Package Manager (standalone)

To integrate using the standalone version of Apple's Swift Package Manager, add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "4.1.1"))
```

After specifying `"SFSafeSymbols"` as a dependency of the target in which you want to use it, run `swift package update`.

### Carthage

Add the following entry to your Cartfile:

```
github "SFSafeSymbols/SFSafeSymbols" ~> 4.1.1
```

Then run `carthage update`.

### CocoaPods

Add the following entry to your Podfile:

```rb
pod 'SFSafeSymbols', '~> 4.1.1'
```

Then run `pod install`.

## Usage

All the system symbols are accessible via the `SFSymbol` type. They are named similar to Apple's names, but use a lower camel case style and prefix names with leading numbers with a `_` character:

```
c.circle        ~> SFSymbol.cCircle
e.circle.fill   ~> SFSymbol.eCircleFill
11.circle.fill  ~> SFSymbol._11CircleFill
```

A SF Symbol `UIImage` can now be initialized using the `SFSymbol` type. This image is already unwrapped, so you get a `UIImage` instead of a `UIImage?`:

```swift
UIImage(systemSymbol: .cCircle)
UIImage(systemSymbol: SFSymbol.eCircleFill)
UIImage(systemSymbol: ._11CircleFill, withConfiguration: /* Some UIImage.Configuration */)
```

A SF Symbol `SwiftUI.Image` can also be initialized using the `SFSymbol` type:

```swift
Image(systemSymbol: .cCircle)
Image(systemSymbol: SFSymbol.eCircleFill)
```

There are also `SwiftUI.Label` initializers:

```swift
Label("MyText", systemSymbol: .cCircle)
Label(LocalizedStringKey("my.text"), systemSymbol: SFSymbol.eCircleFill)
```

... and an initializer for `UIApplicationShortcutItem`:

```swift
UIApplicationShortcutIcon(systemSymbol: .cCircle)
UIApplicationShortcutIcon(systemSymbol: SFSymbol.eCircleFill)
```

... and finally also an initializer for AppKit's `NSImage`:

```swift
NSImage(systemSymbol: .cCircle)
NSImage(systemSymbol: SFSymbol.eCircleFill, accessibilityDescription: "some.description")
```

### Localization

SF Symbols can come with multiple different localizations. `SFSafeSymbols` exposes localization the following way:

- Implicit localization: When using an `SFSymbol`, it gets automatically localized to the user's current locale - nothing to do on your part. This behavior is managed by Apple's system implementation of SF Symbols.

- Explicit localization: `SFSafeSymbols` lets you access a symbol's localized versions as follows:

  ```swift
  // 1. Static localization:
  let a = SFSymbol.character.ar // corresponds to "character.ar"
  let b = SFSymbol.character.zh // corresponds to "character.zh"
  let c = SFSymbol.character.rtl // doesn't compile: "character.rtl" doesn't exist
  // a, b have type SFSymbol
  
  // 2. Dynamic localization:
  SFSymbol.character.availableLocalizations // [.ar, .he, .hi, .ja, .ko, .th, .zh, .zhTraditional]
  let a = SFSymbol.character.localized(to: .ar)
  let b = SFSymbol.character.localized(to: .rtl)
  // a, b have type SFSymbol?
  ```

  Static localization only exposes the localizations which are actually available, so you cannot accidentally localize a non-localizable symbol.

  Dynamic localization, in contrast, is useful when dealing with an array of `SFSymbol`s which all have different available localizations.

Attention: Serializing and deserializing `SFSymbol`s currently makes them lose their _explicit_ static localization information. Dynamic localization information will still be retained.

### Swiftlint

You may want to leverage [SwiftLint](https://github.com/realm/SwiftLint) to ensure that `SFSafeSymbols` is used when appropriate. In your `.swiftlint.yml` file, you can add a custom rule like this:
```yml
custom_rules:
  sf_safe_symbol:
    name: "Safe SFSymbol"
    message: "Use `SFSafeSymbols` via `systemSymbol` parameters for type safety."
    regex: "(Image\\(systemName:)|(NSImage\\(symbolName:)|(Label.*?systemImage:)|(UIApplicationShortcutIcon\\(systemImageName:)"
    severity: warning
```

## Contributing

Contributions are very much welcome! See [CONTRIBUTING.md](https://github.com/SFSafeSymbols/SFSafeSymbols/blob/stable/CONTRIBUTING.md) for more information.

## License

This library is released under the [MIT License](http://opensource.org/licenses/MIT). See [LICENSE](https://github.com/SFSafeSymbols/SFSafeSymbols/blob/stable/LICENSE) for details.
