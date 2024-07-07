# typst-function Extension For Quarto

`typst-function` is an analogous extension to Quarto's `latex-filter` extension [(quarto-ext/latex-environment)](https://github.com/quarto-ext/latex-environment).
It allows `divs` to be converted to `typst` functions

## Installing

```bash
quarto add christopherkenny/typst-function
```

## Using

Divs that match names listed in the `functions` key are translated to Typst functions of the same name.

```yaml
functions: quote
```

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).
