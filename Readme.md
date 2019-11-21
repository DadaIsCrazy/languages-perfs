A simple comparison between some programming languages
===

People tend to have intuitions about which programming language are
faster. Most everyone is going to guess that C is fast. PHP is
probably slow. Java is... somewhat fast but not that much? OCaml is
very fast... right?

The goal of this experiment is not to come up with a definitive answer
to the question "which programming languages are the fastest", but
rather to get a better idea of how fast some programming languages are
or are not.

A good study would take a lot of different examples of codes. It would
try to find out the strength and weaknesses of each languages: maybe
one is bad with arithmetic but does method resolution very fast? Maybe
one has a slow warmup phase, but a high peak performance... Well, this
isn't such a study! (mostly because I don't have that much time to
dedicate to it right now)

What I've done instead is implement the [Sieve of
Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) (a
classic algorithm for finding all prime numbers bellow a given limit)
in a bunch of languages. I then ran those codes and timed them. Here
are the times in second needed to compute the primes up to a given number:

| **Language**        | Compilation | 1000 | 10000 | 100000 | 1000000 | 10000000 | 100000000 | 1000000000 |
| ------------------- | ----------- | ---- | ----- | ------ | ------- | -------- | --------- | ---------- |
| C (gcc)             | 0.09        | 0.00 | 0.00  | 0.00   | 0.01    | 0.06     | 1.10      | **14**     |
| Java                | 0.72        | 0.13 | 0.14  | 0.17   | 0.16    | 0.21     | 1.24      | **14**     |
| Go                  | 0.40        | 0.00 | 0.00  | 0.00   | 0.01    | 0.07     | 1.18      | **15**     |
| OCaml (native)      | 0.11        | 0.00 | 0.00  | 0.01   | 0.05    | 0.39     | 3.91      | **52**     |
| Python (Pypy)       | -           | 0.08 | 0.04  | 0.04   | 0.09    | 0.44     | 4.03      | **54**     |
| Racket              | -           | 0.30 | 0.26  | 0.26   | 0.30    | 0.69     | 4.77      | **60**     |
| Common Lisp (sbcl)  | 0.03        | 0.01 | 0.01  | 0.02   | 0.06    | 0.49     | 5.12      | **69**     |
| R                   | -           | 0.11 | 0.12  | 0.11   | 0.18    | 0.64     | 5.52      | **69**     |
| OCaml (bytecode)    | 0.01        | 0.00 | 0.01  | 0.02   | 0.11    | 1.38     | 15.74     | **201**    |
| Python (CPython)    | -           | 0.03 | 0.03  | 0.06   | 0.30    | 3.14     | 33.56     | **394**    |
| PHP                 | -           | 0.02 | 0.02  | 0.03   | 0.21    | 2.21     | 27.51     | **403**    |
| Perl                | -           | 0.01 | 0.01  | 0.04   | 0.37    | 4.07     | 50.33     | **589**    |
| Javascript (node)   | -           | 0.07 | 0.06  | 0.08   | 0.10    | 0.49     | 30.69     | **-**      |
| Bash                | -           | 0.10 | 0.57  | 9.76   | 2506.9  | -        | -         | **-**      |
| Python (numpy)      | -           | 0.20 | 0.20  | 0.20   | 0.20    | 0.23     | 1.23      | **13**     |

(data with standard deviation (on 10 runs) available in [raw_data.txt](raw_data.txt))

Following text:

 - explanations about languages used (versions, etc)
 - explanations about methodology (shell's time, repeat experiment..)
 - explanations about code (add a pseudo-code), explain that trying to stick to it in most languages. (not highly optimized sieve)
 - what to conclude (Java fast, Pypy fast-ish, OCaml slow, ...) and not conclude (no objects, simple progs)
 - memory footprint (C, Java low, Perl, PHP high)
 - javascript hard limit on array size (=~ 130 million)
 - bash very slow
 - numpy is not the bottom of the list: I feel like using a module specifically designed to handle arrays is cheating. Using a loop instead of `nums[i*2:MAX:i] = True` would have yielded the same performances as CPython (would stronger reinforce the idea that numpy is fast because is has precisely the right builtin).
 - add some justification for not comparing large systems (would be more consuming to develop codes using objects, templates, etc.)
 - explain that the Sieve of Eratosthenes is a poor choice for functional languages, but it's hard to find a good example that works for all languages...
 - some further readings about computing prime numbers: how to optimize eratosthene sieves, and what alternatives to use or not.
 - some take-aways?

TODOs:

 - Add languages: Erlang? Scala? Haskell?
 - Improve benchmarking (the current precision isn't too great I think)
 - Use charts rather than tables to display the results?
 - Add other examples (which ones? One that would less imperative, like run the collactz series on a notoriously long run?)


## Acknowledgments

Thanks to [Lucas](https://github.com/lpeak) for the R implementation.
