# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- None

### Changed

- None

### Fixed

- None

## [5.2.0] - 2024-01-27

### Added

- Add support for SF Symbols 4.2, 5.0, 5.1, and 5.2 (By [Steven Sorial](https://github.com/StevenSorial))
- Add new localizations languages (Central Khmer and Burmese) (By [Steven Sorial](https://github.com/StevenSorial))
- Add support for visionOS (By [Steven Sorial](https://github.com/StevenSorial))

### Changed

- Remove Traditional Chinese localization option which was removed by Apple (By [Steven Sorial](https://github.com/StevenSorial))
- Raise minimum platforms to iOS 12.0 / tvOS 12.0 / macOS 10.14 / watchOS 5.0  (By [Steven Sorial](https://github.com/StevenSorial))
- Remove deprecated methods and properties  (By [Steven Sorial](https://github.com/StevenSorial))

### Fixed

- None

## [4.1.1] - 2023-01-31

### Added

- None

### Changed

- Changed SwiftUI's `Label` initializer to take an optional `SFSymbol` (By [Steven Sorial](https://github.com/StevenSorial))

### Fixed

- None

## [4.1.0] - 2023-01-01

### Added

- Add support for SF Symbols 4.1 (By [Steven Sorial](https://github.com/StevenSorial))
- Add SwiftLint suggestion to `README.md` (By [David Furman](https://github.com/dafurman))

### Changed

- None

### Fixed

- None

## [4.0.0] - 2022-09-16

### Added

- Add support for SF Symbols 4.0 (By [Frederick Pietschmann](https://github.com/fredpi))
- Add new `UIImage.init(systemSymbol:variableValue:configuration:)`, `NSImage.init(systemSymbol:variableValue:accessibilityDescription:)` and `SwiftUI.Image.init(systemSymbol:variableValue:)` interfaces. (By [Steven Sorial](https://github.com/StevenSorial))
- Add new `UIImage.init(systemSymbol:compatibleWith:)` interface. (By [Steven Sorial](https://github.com/StevenSorial))

### Changed

- Retain dynamic localization information when serializing / deserializing an `SFSymbol`. (By [Steven Sorial](https://github.com/StevenSorial))
- Deprecate `UIButton.systemButton(with:target:selector:` and `button.setImage(:for:)` interfaces. (By [Steven Sorial](https://github.com/StevenSorial))

### Fixed

- Remove misleading optionality of `NSImage.init(systemSymbol:accessibilityDescription:)` interface. (By [Steven Sorial](https://github.com/StevenSorial))

## [3.3.2] - 2022-05-01

### Fixed

- Added missing 3.3 layerset information. (By [Steven Sorial](https://github.com/StevenSorial))

## [3.3.1] - 2022-04-14

### Fixed

- Fix version numbering to adhere to the semantic versioning guide. (By [Frederick Pietschmann](https://github.com/fredpi))

## [3.3] - 2022-04-12

### Added

- Add support for SF Symbols 1.1, 2.2, 3.0, 3.1, 3.2, and 3.3 (By [Steven Sorial](https://github.com/StevenSorial))
- Add support for explicit symbol localization (By [David Knothe](https://github.com/knothed))
- Add documentation for available layersets & improve documentation in general. (By [Frederick Pietschmann](https://github.com/fredpi))

### Changed

- Deprecate `allCases: [SFSymbol]` in favor of new `allSymbols: Set<SFSymbol>`. (By [Steven Sorial](https://github.com/StevenSorial))
- Transfer repository to new location: https://github.com/SFSafeSymbols/SFSafeSymbols & simplify contributions to this repository. (By [Frederick Pietschmann](https://github.com/fredpi))
- Change the type of `SFSymbol` from `enum` to `class`, using `static let ...` instead of `case` for individual symbols. This allows for specification of custom symbols as `static let`s in `extension`s to `SFSymbol` and fixes an issue that prevented `rawValue` initialization of symbols. (By [Steven Sorial](https://github.com/StevenSorial))
- Improve internal code generation to allow for quick adjustments to new SF Symbols versions. (By [ddddxxx](https://github.com/ddddxxx))
- Drop dedicated `SFSafeSymbols-Dynamic` product in the `Package.swift` in favour of a new unified `SFSafeSymbols` product with automatic selection between static / dynamic linking. (By [Steven Sorial](https://github.com/StevenSorial))
- Lower watchOS deployment target to watchOS 4.0. (By [Steven Sorial](https://github.com/StevenSorial))
- Refactor unit tests. (By [Martin Wright](https://github.com/MartinW) and [Frederick Pietschmann](https://github.com/fredpi))

### Fixed

- Fix macOS availability. (By [Steven Sorial](https://github.com/StevenSorial))
- Fix unavailable 1.0 symbols by introducing a new 1.1 version. (By [Steven Sorial](https://github.com/StevenSorial))

## [2.1.3] - 2021-03-10

### Added

- None

### Changed

- None

### Fixed

- Fix App Store submission bug. (By [Yonas Kolb](https://github.com/yonaskolb))
- Fix wrong path to the test files that prevented the use of `swift build`. (By [Frederick Pietschmann](https://github.com/fredpi))

## [2.1.2] - 2021-02-18

### Added

- None

### Changed

- None

### Fixed

- Mark UIImage extension initializers as available for watchOS (By [Tomas Franzén](https://github.com/tomasf))
- Fix `Label.init(_:systemImage:)` type inference issue (By [ddddxxx](https://github.com/ddddxxx))

## [2.1.1] - 2020-12-13

### Added

- Add dynamic target (By [noppefoxwolf](https://github.com/noppefoxwolf))

### Changed

- None

### Fixed

- None

## [2.1.0] - 2020-11-24

### Added

- Add support for SF Symbols 2.1 (By [Frederick Pietschmann](https://github.com/fredpi))

### Changed

- None

### Fixed

- None

## [2.0.2] - 2020-11-09

### Added

- None

### Changed

- None

### Fixed

- Fix macOS Catalyst support (By [Hernan Gonzalez](https://github.com/hernangonzalez))

## [2.0.1] - 2020-10-28

### Added

- None

### Changed

- None

### Fixed

- Fix `public` availability of SwiftUI `Label` initializers (By [Seb Jachec](https://github.com/sebj))

## [2.0.0] - 2020-10-25

### Added

- Add support for the new symbols from SF Symbols v2 (By [Frederick Pietschmann](https://github.com/fredpi))
- Add two SwiftUI `Label` initializers (By [Seb Jachec](https://github.com/sebj))
- Add `NSImage` initializer (By [Frederick Pietschmann](https://github.com/fredpi))

### Changed

- Add macOS support for SwiftUI `Image` initializer (By [Seb Jachec](https://github.com/sebj))

### Fixed

- None

## [1.2.0] - 2020-03-29

### Added

- Add a UIButton extension with `systemButton(with:, target:, action:)`  initializer and `setImage(_:, for:)`   (By [Antonino Musolino](https://github.com/posix88))

### Changed

- None

### Fixed

- None

## [1.1.1] - 2020-01-03

### Added

- Add `UIApplicationShortcutIcon` initializer (By [Seb Jachec](https://github.com/sebj))

### Changed

- None

### Fixed

- None



## [1.1.0] - 2019-12-16

### Added

- Show symbols & Apple-only-reference-hints in docs (By [Frederick Pietschmann](github.com/fredpi))

### Changed

- None

### Fixed

- None



## [1.0.2] - 2019-12-03

### Added

- None

### Changed

- None

### Fixed

- Fix App Store submission bug. (By [Yonas Kolb](https://github.com/yonaskolb))



## [1.0.1] - 2019-11-04

### Added

- None

### Changed

- None

### Fixed

- Fix macOS compilation when installed via Carthage (By [Chris Zielinski](https://github.com/chriszielinski))
- Fix compatibility with older iOS versions when installed via CocoaPods (By [@jstarfruits](https://www.github.com/jstarfruits))



## [1.0.0] - 2019-09-12

### Added

- None

### Changed

- Update to symbols that are actually available in the final iOS 13, tvOS 13 and watchOS 6 releases (By [Frederick Pietschmann](github.com/fredpi))

### Fixed

- None



## [0.4.0] - 2019-06-27

### Added

- None

### Changed

- Readd CocoaPods compatibility (By [Frederick Pietschmann](github.com/fredpi))
- Drop `UIImage(systemSymbol:compatibleWith:)` initializer (By [Frederick Pietschmann](github.com/fredpi))
- Drop `SFSymbol.toImage`, `SFSymbol.toImage(withConfiguration:)`,  
   `SFSymbol.toImage(compatibleWith:)` methods.  
   Use the `UIImage(systemSymbol:)` initializers instead (By [Frederick Pietschmann](github.com/fredpi))
- Adjust deployment targets (By [Frederick Pietschmann](github.com/fredpi))
- Improve documentation of available platforms and available initializers (By [Frederick Pietschmann](github.com/fredpi))
- Adjust file structure (By [Frederick Pietschmann](github.com/fredpi))
- Test different scales, weights and pointSizes (By [Frederick Pietschmann](github.com/fredpi))

### Fixed

- Drop macOS support (that didn't work). (By [Thiago Holanda](https://github.com/unnamedd))



## [0.3.1] - 2019-06-22

### Added

- Extended support for `SwiftUI.Image` initializer to macOS, tvOS and watchOS platforms (By [Eric Lewis](github.com/ericlewis))

### Changed

- Temporarily removed CocoaPods support (By [Frederick Pietschmann](github.com/fredpi))

### Fixed

- None



## [0.3.0] - 2019-06-17

### Added

- Added support for SwiftUI.Image (By [Samuel Mellert](github.com/samuel-mellert))



## [0.2.0] - 2019-06-15

### Added

- Added a changelog file keeping track of the changes (By [David Knothe](https://github.com/knothed))
- Added support for CocoaPods (By [Frederick Pietschmann](https://github.com/fredpi))

### Changed

- Sorted enum cases alphabetically (By [David Knothe](https://github.com/knothed))

### Fixed

- Fixed tests for iOS 12 and below; instead of not compiling, the tests simply fail (By [David Knothe](https://github.com/knothed))



## [0.1.1] - 2019-06-04

### Changed
- Made library static (By [Frederick Pietschmann](https://github.com/fredpi))



## [0.1] - 2019-06-04

### Added (initial release)
- Helper script to extract all icon names
- Helper script to create a Swift enum
- The generated Swift code plus a handy UIImage extension, and
- Test cases for all methods. All by [Frederick Pietschmann](https://github.com/fredpi).
