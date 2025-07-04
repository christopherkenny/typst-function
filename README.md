# typst-function Extension For Quarto

`typst-function` is a designed to be an analogous extension to Quarto's `latex-filter` extension [(quarto-ext/latex-environment)](https://github.com/quarto-ext/latex-environment).
It allows `divs` and `spans` to be converted to `typst` functions from within Quarto.
The syntax is similar to `latex-environment`, where you can specify argument's in a document's metadata to control which divs/spans are converted to function calls.
This uses the `functions` key in the YAML metadata to avoid conflicts with the familiar LaTeX extension.

If you have suggestions or problems, please open an issue.

## Installing

To add this filter, run:

```bash
quarto add christopherkenny/typst-function
```

## Using

### Basic use
Divs that match names listed in the `functions` key are translated to Typst functions of the same name.
Adding this to your metadata:

```yaml
functions: align
```

Allows you to write:

```md
::: {.align arguments="right"}
this
:::
```

Spans function similarly, so you can style like:

```md
[other text]{.align arguments=right}
```

These can also be defined within the document in `typst` blocks, if desirable.
For example, if you include a typst block like:

```typst
#let highlight-red(body) = highlight(fill: red, body)
```
Then you can immediately use the following, if you've included it in the YAML under `functions`:

[wow I'm angry]{.highlight-red}


### Spreading arguments (experimental)

One harder case to work with is when arguments are spread.
In those cases, the function takes the form `#function(args, ..spread[body])`
This is currently and only experimentally supported by adding `spread=true`.
The filter inserts the body before the closing parentheses. In the case where the `..spread` involves an open `map()`, it uses the mismatchingnumber of parentheses to insert 2 parentheses.
Note that this may be removed or changed (hopefully improved) in the future as it is not the cleanest syntax.

This currently functions as below.
Here, the call to `map()` is not closed, so two `)`s will be inserted after the block.

```md
::: {.stack arguments="dir: ltr, spacing:1fr, ..range(16).map(i=>rotate(24deg*i)" spread=true}
Hi
:::
```

### Linking (experimental)

Another feature is support for linking to arbitrary elements.
If `label=some-label` is set, then it can be linked using the Typst linking syntax.
Assuming we have `highlight` listed under `functions:`, we could write:

```md
::: {.highlight label=block-highlight}
Look at how yellow this gets.
:::
```

This is not currently a crossref in Quarto's sense.
Instead, link with the following inline.

```md
`#link(<block-highlight>)[like so]`{=typst}
```

This feature is also experimental and only supported because I have a use case in mind.
This may be removed or changed in the future, likely to use Quarto-style crossrefs.

You can also use spans here, which is at least feels less ugly, though is still worse than crossreferences.

```md
[some linked text]{.link arguments=<block-highlight>}
```

Note that a "happy" solution to linking/references is at the tradeoff of Quarto and Typst currenltly, as only floats or built in types can be crossreferenced in Quarto, whereas arbitrary elements can be linked in Typst.

## Example

A full example is available in [example.qmd](example.qmd).

## Common issues

```md
:::{.align arguments = "center"}
This will not be processed because of the spaces after `arguments` and the `=` sign.
:::

:::{.align arguments="center"}
It should look like this instead.
:::
```

## License

This extension is licensed under the MIT license.
The extension builds from [(quarto-dev/latex-environment)](https://github.com/quarto-ext/latex-environment) which is licensed under MIT by Posit, PBC.
All modifications by me are licensed under the MIT license.
See the [license file](LICENSE) for futher details.
