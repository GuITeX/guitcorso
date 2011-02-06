# Due variabili che conteranno rispettivamente la lista dei PDF da produrre
# e dei file LaTeX prodotti durate il procedimento *.Rtex -> *.pdf. Da
# notare che l'utente non è più obbligato a specificare in alcun modo il
# nome del file da "compilare": qualunque file con estensione Rtex viene
# "massaggiato" nella speranza di ottenere un bel PDF.
documenti=$(patsubst %.tex,%.pdf,$(wildcard *.tex))
tarfiles=$(wildcard *.cls) $(wildcard *.pdf) $(patsubst %.pdf,%.tex,$(wildcard *.pdf)) Makefile

# Il target di default (potete anche chiamarlo Pippo, per quel che vale,
# dato che viene eseguito se l'utente non specifica altro (quindi basterà un
# semplice `make` senza fronzoli per compilare tutto)).
all: $(documenti)

# Static pattern rule: se la variabile "documenti" non è vuota la regola
# prende un valore alla volta (<file>.pdf) ed assume che esso dipenda da un
# file con lo stesso nome ma estensione diversa (<file>.tex), che diventa il
# prerequisito su cui agire.
$(documenti): %.pdf: %.tex
	pdflatex $<
	pdflatex $<

# Target di comodo
# Permette di compilare un file dato il nome di quel file senza estensione
%: %.tex
	pdflatex $<
	pdflatex $<

tarball:
	tar cjvf lezioni_`date +%F`.tar.bz2 $(tarfiles)

# Tanto per stare sicuri, conviene indicare target come questi (cioè quelli
# che non sono il nome di un file ma rappresentano un'azione) come phony
# target, per evitare problemi nel caso capiti fra i piedi un file con il
# nome del target.
.PHONY: clean  distclean all
clean:
	rm -f *~ *.aux *.log *.nav *.snm *.out *.toc

distclean: clean
	rm -f *.dvi *.ps *.pdf
