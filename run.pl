#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';
$| = 1;

use FindBin;
use File::Path qw( make_path );
use File::Copy;

chdir $FindBin::Bin;
make_path 'bin' unless -d 'bin';


my %runners = (
    'Perl'                =>   \&run_perl,
    'C'                   =>   \&run_C,
    'Go'                  =>   \&run_go,
    'Java'                =>   \&run_java,
    'Javascript (node)'   =>   \&run_javascript,
    'Common Lisp (sbcl)'  =>   \&run_sbcl,
    'OCaml (native)'      =>   \&run_ocaml_native,
    'OCaml (bytecode)'    =>   \&run_ocaml_bytecode,
    'PHP'                 =>   \&run_php,
    'Python (CPython)'    =>   \&run_cpython,
    'Python (Pypy)'       =>   \&run_pypy,
    'Racket'              =>   \&run_racket,
    'Bash'                =>   \&run_bash
    );

pre_run();

for my $lang (keys %runners) {
    my $res = $runners{$lang}->(10000);
    say "$lang: $res";
}


# Sub to be run before running the other ones, doing stuffs that
# shouldn't be timed.
sub pre_run {
    # Due to how OCaml is compiled; it's easier to put the source in
    # the bin folder.
    copy "src/primes.ml", "bin/primes.ml";
}

sub run_perl {
    my ($n) = @_;
    chomp(my $res = `perl src/primes.pl $n`);
    return $res;
}

sub run_C {
    my ($n) = @_;
    system "gcc -O3 -o bin/primes_c src/primes.c -lm";
    chomp(my $res = `./bin/primes_c $n`);
    return $res;
}

sub run_go {
    my ($n) = @_;
    chomp(my $res = `go run src/primes.go $n`);
    return $res;
}

sub run_java {
    my ($n) = @_;
    system "javac -d bin src/primes.java";
    chomp(my $res = `java -cp bin Primes $n`);
    return $res;
}

sub run_javascript {
    my ($n) = @_;
    chomp(my $res = `node src/primes.js $n`);
    return $res;
}

sub run_sbcl {
    my ($n) = @_;
    chomp(my $res = `sbcl --script src/primes.lisp $n`);
    return $res;
}

sub run_ocaml_native {
    my ($n) = @_;
    system "ocamlopt bin/primes.ml -o bin/primes_ml_native";
    chomp(my $res = `./bin/primes_ml_native $n`);
    return $res;
}

sub run_ocaml_bytecode {
    my ($n) = @_;
    system "ocamlc bin/primes.ml -o bin/primes_ml_bytecode";
    chomp(my $res = `./bin/primes_ml_bytecode $n`);
    return $res;
}

sub run_php {
    my ($n) = @_;
    chomp(my $res = `php src/primes.php $n`);
    return $res;
}

sub run_cpython {
    my ($n) = @_;
    chomp(my $res = `python3 src/primes.py $n`);
    return $res;
}

sub run_pypy {
    my ($n) = @_;
    chomp(my $res = `pypy3 src/primes.py $n`);
    return $res;
}

sub run_ruby {
    my ($n) = @_;
    chomp(my $res = `ruby src/primes.rb $n`);
    return $res;
}

sub run_racket {
    my ($n) = @_;
    chomp(my $res = `racket src/primes.rkt $n`);
    return $res;
}

sub run_bash {
    my ($n) = @_;
    chomp(my $res = `bash src/primes.sh $n`);
    return $res;
}
