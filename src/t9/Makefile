# Makefile dependencies
OCAMLC = ocamlc
OCAMLDEP = ocamldep

# Required .cmo files ordered by dependency
CMO	= keyboard.cmo t9.cmo iphone.cmo

LIBS = graphics
EXE	= iphone

$(EXE): $(CMO)
	$(OCAMLC) -o $@ $(addsuffix .cma, $(LIBS)) $^

.SUFFIXES: .ml .mli .cmo .cmi

.mli.cmi:
	$(OCAMLC) -c $<

.ml.cmo:
	$(OCAMLC) -c $<

clean:
	rm -f *~ \#* $(EXE).cmo $(CMO) $(CMO:.cmo=.cmi) *.o $(CMO:.cmo=.cmx) $(CMO:.cmo=.o) $(CMO:.cmo=.annot)

dist-clean: clean
	rm -f $(EXE)

depend .depend:
	rm -f .depend
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
