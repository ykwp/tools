package main;

require 5.008008;

use strict;
use warnings;
use ExtUtils::MakeMaker;

my $debug_mode = (grep { $_ eq '--debug' } @ARGV) ? '--debug' : '';

my %parms = (
    NAME                => 'aux',
    AUTHOR              => 'Ben auxsend  <ben.cpan@auxsend.org>',
    ABSTRACT            => 'Different auxiliary tools for everyday work',
    VERSION_FROM        => 'Aux/Utils.pm',

    PM                  => {
        'Aux/Sh.pm'            => '$(INST_LIBDIR)/lib/Aux/Sh.pm',
        'Aux/Utils.pm'            => '$(INST_LIBDIR)/lib/Aux/Utils.pm',
    },
    EXE_FILES               => [ 'foo' ],

    PREREQ_PM => {
        'Carp'              => '1.04',
        'Cwd'               => '3.00',
        'File::Basename'    => '1.00015',
        'File::Glob'        => '1.00015',
        'File::Spec'        => '3.00',
        'File::Temp'        => '0.19', # For newdir()
        'Getopt::Long'      => '2.38',
        'Pod::Usage'        => '1.26',
        'Term::ANSIColor'   => '1.10',
        'Test::More'        => '0.98', # For subtest()
        'Text::ParseWords'  => '3.1',
        ( $^O eq 'MSWin32' ? ('Win32::ShellQuote' => '0.002001') : () ),
    },
    MAN3PODS            => {}, # no need for man pages for any of the .pm files
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ack-2* nytprof* stderr.log stdout.log completion.*' },
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
    $parms{LICENSE} = 'artistic_2';
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.46' ) {
    $parms{META_MERGE} = {
        resources => {
            homepage    => 'http://www.auxsend.org/ftp/utils/appaux',
            license     => 'http://www.perlfoundation.org/artistic_license_2_0',
            repository  => 'git@bitbucket.org:auxsend/appaux.git',
        }
    };
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.48' ) {
    $parms{MIN_PERL_VERSION} = 5.008008;
}

WriteMakefile( %parms );

package MY;

# supress EU::MM test rule
sub MY::test {
    return '';
}

sub MY::postamble {
    my $postamble = sprintf(<<'MAKE_FRAG', $debug_mode);
AUX    = 
ALL_PM = 
TEST_VERBOSE=0
TEST_FILES=t/*.t t/lib/*.t
TEST_XT_FILES=xt/*.t

.PHONY: tags critic

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib \
		--exclude=.git \
		--exclude='*~' \
		--exclude=ack-standalone \
		--languages=Perl --langmap=Perl:+.t \

critic:
	perlcritic -1 -q -profile perlcriticrc $(ACK) $(ALL_PM) t/*.t t/lib/*.t xt/*.t

ack-standalone : $(ACK) $(ALL_PM) squash Makefile
	$(PERL) squash $(ACK) $(ALL_PM) File::Next  > ack-standalone
	$(FIXIN) ack-standalone
	-$(NOECHO) $(CHMOD) $(PERM_RWX) ack-standalone
	$(PERL) -c ack-standalone

bininst : $(ACK)
	$(CP) $(ACK) ~/bin/ack2
	$(CP) ackrc ~/.ack2rc

test: test_classic test_standalone

fulltest: test_classic test_standalone test_xt

test_classic: all
	$(FULLPERLRUN) t/runtests.pl 0 $(TEST_VERBOSE) "$(INST_LIB)" "$(INST_ARCHLIB)" $(TEST_FILES)

test_standalone: all ack-standalone
	$(FULLPERLRUN) t/runtests.pl 1 $(TEST_VERBOSE) "$(INST_LIB)" "$(INST_ARCHLIB)" $(TEST_FILES)


SOURCEDIR = txt
BUILDDIR = html
SRCEXT = txt
TGTEXT = html

SOURCES = $(shell find $(SOURCEDIR)/ -type f -iname '*'.$(SRCEXT))
TARGETS = $(patsubst $(SOURCEDIR)/%%,$(BUILDDIR)/%%,$(SOURCES:.$(SRCEXT)=.$(TGTEXT)))


$(BUILDDIR)/%%.$(TGTEXT): $(SOURCEDIR)/%%.$(SRCEXT)
	mkdir -p $(BUILDDIR)
	pandoc -s $< > $@


#all: $(TARGETS)
#	sh ./build.sh

virun:
	echo "jsdf"



test:
	echo %s

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

MAKE_FRAG

    return $postamble;
}

1;
