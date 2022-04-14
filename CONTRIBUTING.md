# Contributing

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Bug reports and suggestions for improvements are welcome! For this, please [raise an issue on GitHub](https://github.com/SFSafeSymbols/SFSafeSymbols/issues). [Pull requests](https://github.com/SFSafeSymbols/SFSafeSymbols/pulls) are also very much welcome. However, for non-trivial changes, please make sure to raise an issue before opening up a PR that addresses the issue.

## Core Contributors

There's a **team of core contributors** responsible for the management of this repository, i. e. configuring the CI, releasing new versions and **managing PRs & issues**. Everyone that created at least one non-trivial PR (i. e. not just correcting spelling mistakes) can **request to become a core contributor** once the PR has been approved and merged. 

## Pull Requests

When issuing a pull request, please **add a summary of your changes to the `CHANGELOG.md` file** and credit yourself as the author.

The **approval of a core contributor** is required before merging a PR. When a core contributor creates a PR themselves and no other core contributor responds in a week's time, they are allowed to **merge the PR themselves** even without further approval. All changes (apart from trivial changes, i. e. when releasing a new version) **must be made via PRs**.

## Git

Please write **meaningful commit messages** (see rationale [here](http://chris.beams.io/posts/git-commit/)).

## Updating to a new SF Symbols version

With the current structure of the repository, where **most code is generated** by the `SymbolsGenerator` helper tool, it is quite easy to update `SFSafeSymbols` to a new SF Symbols version (as long as there are no breaking changes in the way Apple organizes the symbols):

1. **Update the files** in the `/SymbolsGenerator/Sources/SymbolsGenerator` folder to the latest SF Symbols version. Some of the files are created manually (there's a comment at the top of these files, explaing how it is done), some other files are copied from the *Package Contents* of the SF Symbols app.
2. Open a terminal and change to the root folder of the repository. **Then run `make generate-symbol`**.
3. If new files are created by the generator tool (which is expected to happen when updating to a new SF Symbols version), make sure they are **added to the `SFSafeSymbols.xcodeproj`**.
4. **Update the `README.md`**, so that support for the new SF Symbols version is mentioned there.
5. **Check the CI configuration** and, if needed, make adjustments (or ask a core contributor to do so), so that the new changes are properly tested with a matching Xcode version.

## Releasing a new version

To be able to release a new version, you **need to be a core contributor**, i. e. have write access to the repository and CocoaPods. If you have these privileges, it's up to you to release a new version whenever you feel that it's appropriate.

To release a new version, follow these steps:

1. **Choose a new semantic versioning-compatible version number**. For it to be semantic versioning-compatible, it **MUST** take the form `X.Y.Z`. As an example, version numbers like `1.0` are illegal while version numbers like `1.0.0` are allowed.
2. **Update to the new the version number** in the `SFSafeSymbols.podspec` and at all places in the `README.md` (Version Badge, Version Badge Alt Text, Installation Instructions).
3. **Update the `CHANGELOG.md` file** by changing the *Unreleased* title to the version number and the release date. Then add a new *Unreleased* Section on top, keeping the 3 existing subsections (Added, Changed, Fixed).
4. **Commit these changes directly to the `stable` branch** with the commit message `Bump version number & update changelog`.
5. **Release on GitHub** and copy the changelog contents for this version into the release notes on GitHub. Make sure that the tag is named similar to the version number.
6. **Publish on CocoaPods** using `pod trunk push SFSafeSymbols.podspec --allow-warnings`.
