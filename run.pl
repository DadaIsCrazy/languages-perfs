#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);
$| = 1;

use FindBin;
use File::Path qw(make_path);
use File::Copy;
use Time::HiRes qw(time);
use List::Util qw(sum);
use Scalar::Util qw(looks_like_number);

chdir $FindBin::Bin;
make_path 'bin' unless -d 'bin';

my $sbcl_space_size = 16384;
my $node_space_size = 16384;
my $repeat = 10;
my $long = 100; # if execution time > $long, then don't run it more than once

my %runners = (
    'Perl'                =>   \&run_perl,
    'C (gcc)'             =>   \&run_C,
    'Go'                  =>   \&run_go,
    'Java'                =>   \&run_java,
    'Javascript (node)'   =>   \&run_javascript,
    'Common Lisp (sbcl)'  =>   \&run_sbcl,
    'OCaml (native)'      =>   \&run_ocaml_native,
    'OCaml (bytecode)'    =>   \&run_ocaml_bytecode,
    'PHP'                 =>   \&run_php,
    'Python (CPython)'    =>   \&run_cpython,
    'Python (Pypy)'       =>   \&run_pypy,
    'Python (numpy)'      =>   \&run_numpy,
    'Racket'              =>   \&run_racket,
    'Bash'                =>   \&run_bash,
    'R'                   =>   \&run_R
    );

pre_run();

my %res;
for my $n (1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000) {
    my $correct_res = run_C($n);
    for (1 .. $repeat) {
        for my $lang (keys %runners) {
            if ($n > 1000000 && $lang eq 'Bash') {
                $res{$lang}->{$n} = [ '-' ];
                next;
            }
            next if too_slow($lang, $n);
            printf "\033[2K\rRunning [ %-19s]; n = %d", $lang, $n;
            my ($res, $time) = time_fun($runners{$lang}, $n);
            if (looks_like_number($res) && $res == $correct_res) {
                push @{$res{$lang}->{$n}}, $time;
            } else {
                push @{$res{$lang}->{$n}}, "-";
            }
        }
    }
}
print "\033[2K\r";


for my $lang (keys %res) {
    my $format_str = "%-20s | " . (join " | ", map { " %13s " } keys %{$res{$lang}}) . "\n";
    printf $format_str, $lang, 
      map { mean($res{$lang}{$_}) }
        sort { $a <=> $b } keys %{$res{$lang}};
}

# Runs |$fun| with arguments |@args|, and returns the results as well
# as the time (in milli-seconds) it took to run.
sub time_fun {
    my ($fun, @args) = @_;
    my $time = time;
    my $res = $fun->(@args);
    return ($res, time() - $time);
}

# Returns the mean and standard deviation of an arrayref
sub mean {
    my @nums  = @{$_[0]};
    if (grep { /-/ } @nums) {
        # Contains non-numeric -> returning "-"
        return "-"
    } else {
        # Contains numeric only -> computing mean/stdev
        my $mean  = sum(@nums) / @nums;
        if (@nums > 1) {
            my $sigma = sqrt( (sum map { ($_ - $mean) ** 2 } @nums) / @nums );
            return sprintf "%.2f +-%.2f", $mean, $sigma;
        } else {
            return sprintf "%.2f", $mean;
        }
    }
}

# Returns true if the previous execution of $lang with $n took more
# than $long seconds. False otherwise. Also returns true if the last
# execution of $lang with $n didn't produce the valid result (because
# in that case, no need to rerun it)
sub too_slow {
    my ($lang, $n) = @_;
    return 0 unless $res{$lang}->{$n}; # First execution
    return 1 unless looks_like_number($res{$lang}->{$n}->[-1]);
    return $res{$lang}->{$n}->[-1] > $long;
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
    chomp(my $res = `perl src/primes.pl $n 2>/dev/null`);
    return $res;
}

sub run_C {
    my ($n) = @_;
    system "gcc -O3 -o bin/primes_c src/primes.c -lm";
    chomp(my $res = `./bin/primes_c $n 2>/dev/null`);
    return $res;
}

sub run_go {
    my ($n) = @_;
    chomp(my $res = `go run src/primes.go $n 2>/dev/null`);
    return $res;
}

sub run_java {
    my ($n) = @_;
    system "javac -d bin src/primes.java";
    chomp(my $res = `java -cp bin Primes $n 2>/dev/null`);
    return $res;
}

sub run_javascript {
    my ($n) = @_;
    chomp(my $res = `node --max-old-space-size=$node_space_size src/primes.js $n 2>/dev/null`);
    return $res;
}

sub run_sbcl {
    my ($n) = @_;
    chomp(my $res = `sbcl --dynamic-space-size $sbcl_space_size --script src/primes.lisp $n 2>/dev/null`);
    return $res;
}

sub run_ocaml_native {
    my ($n) = @_;
    system "ocamlopt bin/primes.ml -o bin/primes_ml_native";
    chomp(my $res = `./bin/primes_ml_native $n 2>/dev/null`);
    return $res;
}

sub run_ocaml_bytecode {
    my ($n) = @_;
    system "ocamlc bin/primes.ml -o bin/primes_ml_bytecode";
    chomp(my $res = `./bin/primes_ml_bytecode $n 2>/dev/null`);
    return $res;
}

sub run_php {
    my ($n) = @_;
    chomp(my $res = `php src/primes.php $n 2>/dev/null`);
    return $res;
}

sub run_cpython {
    my ($n) = @_;
    chomp(my $res = `python3 src/primes.py $n 2>/dev/null`);
    return $res;
}

sub run_pypy {
    my ($n) = @_;
    chomp(my $res = `pypy src/primes.py $n 2>/dev/null`);
    return $res;
}

sub run_numpy {
    my ($n) = @_;
    chomp(my $res = `python3 src/primes_numpy.py $n 2>/dev/null`);
    return $res;
}

sub run_ruby {
    my ($n) = @_;
    chomp(my $res = `ruby src/primes.rb $n 2>/dev/null`);
    return $res;
}

sub run_racket {
    my ($n) = @_;
    chomp(my $res = `racket src/primes.rkt $n 2>/dev/null`);
    return $res;
}

sub run_bash {
    my ($n) = @_;
    chomp(my $res = `bash src/primes.sh $n 2>/dev/null`);
    return $res;
}

sub run_R {
    my ($n) = @_;
    chomp(my $res = `Rscript src/primes.R $n 2>/dev/null`);
    return $res;
}
