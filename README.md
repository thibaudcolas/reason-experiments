# reason-experiments

> [Reason](https://facebook.github.io/reason/) implementations of small [OCaml](https://ocaml.org) experiments.

## Forest fire cellular automata

![GIF of the forest fire in X11](docs/ocaml-fire.gif)

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

## Dragon curve

![GIF of the dragon curve in X11](docs/ocaml-dragon.gif)

## In OCaml


```sh
ocamlbuild -lib graphics src/fire.native
./fire.native
ocamlbuild -lib graphics src/dragon.native
./dragon.native
```

## Docs

### Useful links

- [http://www.ocaml-tutorial.org/](http://www.ocaml-tutorial.org/)
- [http://caml.inria.fr/](http://caml.inria.fr/)
- [http://ocamlgraph.lri.fr/](http://ocamlgraph.lri.fr/)
- [http://www.lri.fr/~conchon/](http://www.lri.fr/~conchon/)
