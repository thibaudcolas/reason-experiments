# Makefile dependencies
OCAMLC = ocamlc
OCAMLDEP = ocamldep

# Required .cmo files ordered by dependency
CMO	= gris.cmo couleur.cmo image.cmo quadtrees.cmo

LIBS = graphics

EXE	= quadtrees

$(EXE): $(CMO)
	$(OCAMLC) -o $@ $(addsuffix .cma, $(LIBS)) $^

.SUFFIXES: .ml .mli .cmo .cmi

.mli.cmi:
	$(OCAMLC) -c $<

.ml.cmo:
	$(OCAMLC) -c $<

clean:
	rm -f *~ \#* $(EXE).cmo $(CMO) $(CMO:.cmo=.cmi)

dist-clean: clean
	rm -f $(EXE)

depend .depend:
	rm -f .depend
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
