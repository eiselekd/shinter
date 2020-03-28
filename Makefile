all: staticperl32 shpreload32.so staticperl64 shpreload64.so

########################

PERL_CCOPTS=$(shell sh staticperl$(BIT) perl -MExtUtils::Embed -e ccopts)
PERL_LDOPTS=$(shell sh staticperl$(BIT) perl -MExtUtils::Embed -e ldopts)
PERL_VER=$(shell sh staticperl$(BIT) perl -e "print($$])")

shpreload32.so:
	BIT=32 M32_OPT=-m32  make shpreload.so
	mkdir -p rel/$(PERL_VER)
	cp shpreload32.so rel/$(PERL_VER)/shpreload32.so
	strip --strip-all rel/$(PERL_VER)/shpreload32.so

shpreload64.so:
	BIT=64 M32_OPT=      make shpreload.so
	mkdir -p rel/$(PERL_VER)
	cp shpreload64.so rel/$(PERL_VER)/shpreload64.so
	strip --strip-all rel/$(PERL_VER)/shpreload64.so

shpreload.so: shpreload.c
	@echo "sh staticperl$(BIT) perl ccopts: $(PERL_CCOPTS)"
	@echo "sh staticperl$(BIT) perl ldopts: $(PERL_LDOPTS)"
	gcc $(M32_OPT) -DSHINTER_PERL5LIB="\"$(CURDIR)\"" $(PERL_CCOPTS) -fPIC -shared -g -o shpreload$(BIT).so shpreload.c  -Wl,--version-script=exportmap -lm $(PERL_LDOPTS) -ldl

########################

staticperl32:
	BIT=32 M32_OPT=-m32  make staticperl

staticperl64:
	BIT=64 M32_OPT=      make staticperl

staticperl:
	rm -f staticperl$(BIT)
	wget -O staticperl$(BIT) http://cvs.schmorp.de/App-Staticperl/bin/staticperl;
	cp staticperl$(BIT) staticperl.tmp
	cat staticperl.tmp | sed -e 's/STATICPERL=~\/.staticperl/STATICPERL=~\/.staticperl$(BIT)/' \
			   | sed -e 's/-g /-g -fPIC $(M32_OPT) /' \
                           | sed -e 's/PERL_LDFLAGS=/PERL_LDFLAGS="$(M32_OPT)" /' > staticperl$(BIT)
	chmod a+x staticperl$(BIT)
	sh staticperl$(BIT) clean
	sh staticperl$(BIT) build
	sh staticperl$(BIT) install

########################

test64:
	rm -f /tmp/report.txt
	LD_PRELOAD=$(CURDIR)/shpreload64.so bash -c 'ls'
	cat /tmp/report.txt

clean:
	rm staticperl32 staticperl64

.PHONY: shpreload32.so shpreload64.so staticperl32 staticperl64 shpreload.so staticperl test64
