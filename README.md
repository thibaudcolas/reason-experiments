# reason-cells

> [Reason](https://facebook.github.io/reason/) implementations of small [OCaml](https://ocaml.org) cellular automata.

## Forest fire

This is a simple modelisation of forest fires. Cells are of the types:

- Empty
- Trees
- Fire
- Ashes

Rules are:

- An empty area will stay empty.
- The wind blows ashes away and makes them disappear.
- Fire on a tree transforms it into ashes.
- Trees start burning when one of their neighbours is burning.

## In OCaml

![GIF of the fire spreading in X11](docs/ocaml-fire.gif)

```sh
ocamlbuild -lib graphics src/fire.native
./src/fire.native
```
