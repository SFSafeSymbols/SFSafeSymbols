# SFSymbol Enum Creator

Creates the code for the SFSymbol enum by reading the clipboard (expecting a string like `, some.name, some.other, ..., the.last.icon`), converting it and writing the valid Swift code into the clipboard.

E. g. having `, abc.abc, 00.circle.big` in the pasteboard before execution will result in the following being in the pasteboard after execution:

```
enum SFSymbol: String, CaseIterable {
    case abcAbc = "abc.abc"
    case 00CircleBig = "00.circle.big"
}
```

You can run this helper locally via the command line or  `make install` to have it available globally.

`make install`
`symbolenumcreator`
