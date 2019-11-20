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

| **Language**         |    1000  |  10000   |   100000  |  1000000  |  10000000  | 100000000  | 1000000000 |
| -------------------- | -------- | -------- | --------- | --------- | ---------- | ---------- | ---------- |
| C (gcc)              |    0.09  |    0.09  |    0.08   |    0.09   |    0.14    |    1.34    |   **17**   |
| Java                 |    0.81  |    0.81  |    0.78   |    0.85   |    0.86    |    2.03    |   **18**   |
| Go                   |    0.34  |    0.33  |    0.32   |    0.35   |    0.43    |    1.69    |   **19**   |
| OCaml (native)       |    0.12  |    0.11  |    0.12   |    0.20   |    0.54    |    4.74    |   **60**   |
| Python (Pypy)        |    0.05  |    0.05  |    0.05   |    0.10   |    0.49    |    4.66    |   **61**   |
| Racket               |    0.25  |    0.26  |    0.29   |    0.33   |    0.76    |    5.51    |   **68**   |
| Common Lisp (sbcl)   |    0.06  |    0.02  |    0.03   |    0.09   |    0.56    |    5.71    |   **75**   |
| R                    |    0.12  |    0.13  |    0.12   |    0.20   |    0.71    |    6.57    |   **77**   |
| OCaml (bytecode)     |    0.02  |    0.02  |    0.03   |    0.14   |    1.53    |   17.49    |   **216**  |
| PHP                  |    0.01  |    0.02  |    0.04   |    0.23   |    2.50    |   29.10    |   **325**  |
| Python (CPython)     |    0.02  |    0.03  |    0.06   |    0.31   |    3.42    |   35.39    |   **401**  |
| Perl                 |    0.01  |    0.02  |    0.04   |    0.41   |    4.69    |   54.80    |   **616**  |
| Javascript (node)    |    0.06  |    0.07  |    0.07   |    0.11   |    0.53    |   30.56    |      -     |
| Bash                 |    0.08  |    0.46  |   10.84   |  2797.01  |     -      |     -      |      -     |
| Python (numpy)       |    0.21  |    0.21  |    0.21   |    0.22   |    0.26    |    1.43    |   **17**   |

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
 - add some justification for not comparing large systems (would be very time consuming to use objects, templates, etc.)
 - explain that the Sieve of Eratosthenes is a poor choice for functional languages, but it's hard to find a good example that works for all languages...
 - some further readings about computing prime numbers: how to optimize eratosthene sieves, and what alternatives to use or not.
 - some take-aways?

TODOs:

 - Add languages: Erlang? Scala? Haskell?
 - compute results for various n (in progress)
 - separate compilation from execution? (to distinguish between startup time and compile-time (`javac` is a bit slow for instance))
 - Improve benchmarking (the current precision isn't too great I think)
 - Use charts rather than tables to display the results?
 - Add other examples (which ones? One that would less imperative, like run the collactz series on a notoriously long run?)


## Acknowledgments

Thanks to [Lucas](https://github.com/lpeak) for the R implementation.
