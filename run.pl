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

my $VERBOSE = 1;
my $sbcl_space_size = 8192;
my $node_space_size = 16384;
my $scala_space_size = "2g";
my $repeat = 10;
my $minimal_runs = 3; # For slow runs; still, run at least this many times
my $long = 100; # if execution time > $long, then don't run it more than once
my @bounds = (1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000);
my $pattern = ""; # if defined, run only languages that match this pattern

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
    'Ruby'                =>   \&run_ruby,
    'Bash'                =>   \&run_bash,
    'R'                   =>   \&run_R,
    'Scala'               =>   \&run_scala,
    'Rust'                =>   \&rust
    );

my %compile_hooks = (
    'C (gcc)'             => \&compile_C,
    'Go'                  => \&compile_go,
    'Java'                => \&compile_java,
    'Common Lisp (sbcl)'  => \&compile_sbcl,
    'OCaml (native)'      => \&compile_ocaml_native,
    'OCaml (bytecode)'    => \&compile_ocaml_bytecode,
    'Rust'                => \&rust,
    'Scala'               => \&compile_scala
    );


pre_run();
my $compile_times = bench_compile();
my $run_times = bench_runs();
print_results_full($run_times, $compile_times);
print_results_compact($run_times, $compile_times);



sub bench_compile {
    my %compile_times;
    for (1 .. $repeat) {
        for my $lang (keys %compile_hooks) {
            next unless $lang =~ /$pattern/;
            printf "\033[2K\rCompiling [ %-19s] ($_/$repeat)", $lang if $VERBOSE;
            my (undef, $time) = time_fun($compile_hooks{$lang});
            push @{$compile_times{$lang}}, $time;
        }
    }
    print "\033[2K\r" if $VERBOSE;
    return \%compile_times;
}

sub bench_runs {
    my %run_times;
    for my $n (@bounds) {
        my $correct_res = run_C($n);
        for (1 .. $repeat) {
            for my $lang (keys %runners) {
                next unless $lang =~ /$pattern/;
                if ($n > 1000000 && $lang eq 'Bash') {
                    # Bash would be way too slow for n > 1000000
                    $run_times{$lang}->{$n} = [ '-' ];
                    next;
                }
                next if too_slow(\%run_times, $lang, $n);
                printf "\033[2K\rRunning [ %-19s]; n = %d", $lang, $n if $VERBOSE;
                my ($res, $time) = time_fun($runners{$lang}, $n);
                if (looks_like_number($res) && $res == $correct_res) {
                    push @{$run_times{$lang}->{$n}}, $time;
                } else {
                    push @{$run_times{$lang}->{$n}}, "-";
                }
            }
        }
    }
    print "\033[2K\r" if $VERBOSE;
    return \%run_times;
}

sub print_results_full {
    my ($run_times, $compile_times) = @_;
    open my $FH, '>', 'raw_data.txt' or die $!;
    print $FH "| **Language**        | Compilation |",
      (join " | ", map { sprintf " %-13s ", $_ } @bounds), " |\n";
    print $FH "| ------------------- | ----------- |",
      (join " | ", map { " " . ("-"x13) . " " } @bounds), " |\n";
    for my $lang (sort {sort_langs($run_times)} keys %$run_times) {
        my $format_str = "| %-19s | %-11s |" .
            (join " | ", map { " %-13s " }
                 keys %{$run_times->{$lang}}) . " |\n";
        printf $FH $format_str, $lang,
        (exists $compile_times->{$lang} ? mean($compile_times->{$lang}) : "-"),
          map { mean($run_times->{$lang}{$_}) }
            sort { $a <=> $b } keys %{$run_times->{$lang}};
    }
}

sub print_results_compact {
    my ($run_times, $compile_times) = @_;
    print "| **Language**        | Compilation |",
      (join "|", map { sprintf " %-*s ", length, $_ } @bounds), "|\n";
    print "| ------------------- | ----------- |",
      (join "|", map { sprintf " %-*s ", length, ($_=~s/./-/gr) } @bounds), "|\n";
    for my $lang (sort {sort_langs($run_times)} keys %$run_times) {
        my $format_str = "| %-19s | %-11s |" .
            (join "|", map { " %-" . (length $_) . "s " } @bounds) . "|\n";
        printf $format_str, $lang,
        (exists $compile_times->{$lang} ?
           mean($compile_times->{$lang}) =~ s/(\S+) *\S+/$1/r : "-"),
          map { my $r = mean($run_times->{$lang}{$_}) =~ s/(\S+) *\S+/$1/r;
                $_ == 1000000000 ? "**" . ($r =~ s/\..*//r) . "**" : $r }
            sort { $a <=> $b } keys %{$run_times->{$lang}};
    }
}

sub sort_langs {
    my ($run_times) = @_;
    my $rta = $run_times->{$a}->{$bounds[-1]}->[0];
    my $rtb = $run_times->{$b}->{$bounds[-1]}->[0];
    $rta = 0 if $rta !~ /\d/;
    $rtb = 0 if $rtb !~ /\d/;
    $rtb = -1 if $a =~ /numpy/;
    $rta = -1 if $b =~ /numpy/;
    return $rta <=> $rtb;
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
    my ($run_times, $lang, $n) = @_;
    return 0 unless $run_times->{$lang}->{$n}; # First execution
    return 0 if @{$run_times->{$lang}->{$n}} < $minimal_runs; # Not enough executions
    return 1 unless looks_like_number($run_times->{$lang}->{$n}->[-1]);
    return $run_times->{$lang}->{$n}->[-1] > $long;
}

# Sub to be run before running the other ones, doing stuffs that
# shouldn't be timed neither in the run time nor in the compile time.
sub pre_run {
    # Due to how OCaml is compiled; it's easier to put the source in
    # the bin folder.
    copy "src/primes.ml", "bin/primes.ml";

    # Scala and Java will generate .class with the same name. To avoid
    # that, we copy Scala's source code and rename its main class.
    copy "src/primes.scala", "bin/PrimesScala.scala";
    {
        local $^I = "";
        local @ARGV = "bin/PrimesScala.scala";
        while (<>) {
            s/object Primes/object PrimesScala/;
        } continue {
            print;
        }
    }
}

sub run_perl {
    my ($n) = @_;
    chomp(my $res = `perl src/primes.pl $n 2>/dev/null`);
    return $res;
}

sub compile_C {
    system "gcc -O3 -o bin/primes_c src/primes.c -lm";
}
sub run_C {
    my ($n) = @_;
    chomp(my $res = `./bin/primes_c $n 2>/dev/null`);
    return $res;
}

sub compile_go {
    system "go build -o bin/primes_go src/primes.go"
}
sub run_go {
    my ($n) = @_;
    chomp(my $res = `./bin/primes_go $n 2>/dev/null`);
    return $res;
}

sub compile_java {
    system "javac -d bin src/primes.java";
}
sub run_java {
    my ($n) = @_;
    chomp(my $res = `java -cp bin Primes $n 2>/dev/null`);
    return $res;
}

# Warning: Scala's source file has been moved to bin/PrimesScala.scala
# by pre_run(). (see pre_run's documentation for explanations)
sub compile_scala {
    system "scalac -d bin bin/PrimesScala.scala";
}
sub run_scala {
    my ($n) = @_;
    chomp(my $res = `scala -J-Xmx$scala_space_size -cp bin PrimesScala $n`);
    return $res;
}

sub run_javascript {
    my ($n) = @_;
    chomp(my $res = `node --max-old-space-size=$node_space_size src/primes.js $n 2>/dev/null`);
    return $res;
}

sub compile_sbcl {
    system q{sbcl --noinform --eval '(compile-file "src/primes.lisp" :output-file #P"../bin/primes")' --eval "(quit)" > /dev/null 2>&1};
}
sub run_sbcl {
    my ($n) = @_;
    chomp(my $res = `sbcl --dynamic-space-size $sbcl_space_size --noinform --load "bin/primes.fasl" --quit --end-toplevel-options $n 2>/dev/null`);
    return $res;
}

sub compile_ocaml_native {
    system "ocamlopt bin/primes.ml -o bin/primes_ml_native";
}
sub run_ocaml_native {
    my ($n) = @_;
    chomp(my $res = `./bin/primes_ml_native $n 2>/dev/null`);
    return $res;
}

sub compile_ocaml_bytecode {
    system "ocamlc bin/primes.ml -o bin/primes_ml_bytecode";
}
sub run_ocaml_bytecode {
    my ($n) = @_;
    chomp(my $res = `./bin/primes_ml_bytecode $n 2>/dev/null`);
    return $res;
}

sub compile_rust {
    system "rustc -C opt-level=3 src/primes.rs -o bin/primes_rust";
}
sub run_rust {
    my ($n) = @_;
    chomp(my $res = `./bin/primes_rust $n 2>/dev/null`);
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

sub run_racket {
    my ($n) = @_;
    chomp(my $res = `racket src/primes.rkt $n 2>/dev/null`);
    return $res;
}

sub run_ruby {
    my ($n) = @_;
    chomp(my $res = `ruby src/primes.rb $n 2>/dev/null`);
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
