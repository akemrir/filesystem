package = filesystem
distfiles = Makefile README

root = $(DESTDIR)
etc = $(DESTDIR)/etc
run = $(DESTDIR)/run
usr = $(DESTDIR)/usr
var = $(DESTDIR)/var

.PHONY: all check dist clean distclean install uninstall

all:

check:

dist:
	rm -R -f -- $(package) $(package).tar $(package).tar.gz
	mkdir -- $(package)
	cp -- $(distfiles) $(package)
	tar -c -f $(package).tar -- $(package)
	gzip -- $(package).tar
	rm -R -f -- $(package) $(package).tar

clean:
	rm -R -f -- $(package) $(package).tar $(package).tar.gz

distclean: clean

install: all mkroot mketc mkrun mkusr mkvar

uninstall: rmroot rmetc rmrun rmusr rmvar

.PHONY: mkroot rmroot mketc rmetc mkrun rmrun mkusr rmusr mkvar rmvar

mkroot:
	mkdir -p -- $(root) $(root)/boot $(root)/sys $(root)/proc \
	            $(root)/dev $(root)/srv $(root)/mnt $(root)/home \
	            $(root)/root $(root)/tmp
	ln -s -f -- bin $(root)/sbin
	ln -s -f -- usr/bin $(root)/bin
	ln -s -f -- usr/lib $(root)/lib
	chmod -- 1777 $(root)/tmp
	chmod -- o= $(root)/root
	chmod -- a-w $(root)/sys $(root)/proc

rmroot:
	rm -f -- $(root)/lib $(root)/bin $(root)/sbin
	-rmdir -- $(root)/tmp $(root)/root $(root)/home $(root)/mnt \
	          $(root)/srv $(root)/dev $(root)/proc $(root)/sys \
	          $(root)/boot

mketc:
	mkdir -p -- $(etc)
	ln -s -f -- /proc/mounts $(etc)/mtab
	ln -s -f -- /var/lib/hwclock/adjtime $(etc)/adjtime

rmetc:
	rm -f -- $(etc)/adjtime $(etc)/mtab
	-rmdir -- $(etc)

mkrun:
	mkdir -p -- $(run) $(run)/lock $(run)/user

rmrun:
	-rmdir -- $(run)/user $(run)/lock $(run)

mkusr:
	mkdir -p -- $(usr) $(usr)/bin $(usr)/lib $(usr)/share \
	            $(usr)/share/man $(usr)/include $(usr)/src
	ln -s -f -- bin $(usr)/sbin
	ln -s -f -- lib $(usr)/libexec
	ln -s -f -- share/man $(usr)/man

rmusr:
	rm -f -- $(usr)/man $(usr)/libexec $(usr)/sbin
	-rmdir -- $(usr)/src $(usr)/include $(usr)/share/man \
	          $(usr)/share $(usr)/lib $(usr)/bin $(usr)

mkvar:
	mkdir -p -- $(var) $(var)/lib $(var)/spool $(var)/cache \
	            $(var)/log $(var)/crash $(var)/backups \
	            $(var)/lib/hwclock $(var)/spool/mail
	ln -s -f -- /run $(var)/run
	ln -s -f -- /run/lock $(var)/lock
	ln -s -f -- /tmp $(var)/tmp
	ln -s -f -- spool/mail $(var)/mail

rmvar:
	rm -f -- $(var)/mail $(var)/tmp $(var)/lock $(var)/run
	-rmdir -- $(var)/spool/mail $(var)/lib/hwclock \
	          $(var)/backups $(var)/crash $(var)/log \
	          $(var)/cache $(var)/spool $(var)/lib $(var)
