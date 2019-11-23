#!/usr/bin/perl

use strict;
use warnings;
use v5.14;

my $version_re = qr/\d+\.\d+\.\d+/;

my %version_subs = (
    'Bash'    => \&get_bash_version,
    'GCC'     => \&get_gcc_version,
    'Go'      => \&get_go_version,
    'Java'    => \&get_java_version,
    'Node.js' => \&get_node_version,
    'Perl'    => \&get_perl_version,
    'PHP'     => \&get_php_version,
    'PyPy'    => \&get_pypy_version,
    'Python'  => \&get_python_version,
    'OCaml'   => \&get_ocaml_version,
    'R'       => \&get_R_version,
    'Racket'  => \&get_racket_version,
    'SBCL'    => \&get_sbcl_version,
    );

for my $lang (sort keys %version_subs) {
    say " - $lang ", $version_subs{$lang}->();
}

sub get_bash_version {
    my $version_string = `bash --version`;
    my ($version) = $version_string =~ /version ($version_re)/;
    return $version;
}

sub get_gcc_version {
    my $version_string = `gcc --version`;
    my ($version) = $version_string =~ /^gcc.*($version_re)/;
    return $version;
}

sub get_go_version {
    my $version_string = `go version`;
    my ($version) = $version_string =~ /^go version go($version_re)/;
    return $version;
}

sub get_java_version {
    my $version_string = `java --version`;
    my ($version) = $version_string =~ /^java ($version_re)/;
    return $version;
}

sub get_node_version {
    my $version_string = `node -v`;
    my ($version) = $version_string =~ /^v($version_re)/;
    return $version;
}

sub get_ocaml_version {
    my $version_string = `ocamlopt --version`;
    my $version_string2 = `ocamlc --version`;
    if ($version_string ne $version_string2) {
        die "Different version for ocamltop and ocamlc: " .
            "$version_string vs $version_string2. ".
            "Exiting.";
    }
    my ($version) = $version_string =~ /($version_re)/;
    return $version;
}

sub get_perl_version {
    # Note: could use directly $^V, but to be more consistent with
    # other languages, doing a "system" call.
    # (meaning, if at any point this script needs to be ported to any
    # other language, nobody will wonder "hmm, how to do it in Perl?")
    my $version_string = `perl -e 'print \$^V'`;
    my ($version) = $version_string =~ /v($version_re)/;
    return $version;
}

sub get_php_version {
    my $version_string = `php -v`;
    my ($version) = $version_string =~ /^PHP ($version_re)/;
    return $version;
}

sub get_pypy_version {
    my $version_string = `pypy --version 2>&1`;
    my ($version) = $version_string =~ /PyPy ($version_re)/;
    return $version;
}

sub get_python_version {
    my $version_string = `python3 --version`;
    my ($version) = $version_string =~ /Python ($version_re)/;
    return $version;
}

sub get_R_version {
    my $version_string = `Rscript --version 2>&1`;
    my ($version) = $version_string =~ /version ($version_re)/;
    return $version;
}

sub get_racket_version {
    my $version_string = `racket -v`;
    my ($version) = $version_string =~ /Racket v(\d+\.\d+)/;
    return $version;
}

sub get_sbcl_version {
    my $version_string = `sbcl --version`;
    my ($version) = $version_string =~ /SBCL ($version_re)/;
    return $version;
}
