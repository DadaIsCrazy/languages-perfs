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
are the results when computing prime numbers up to 1 billion:

| **Language**       | **Time (sec)** |
| ------------------ | -------------- |
| C (gcc)            |  15            |
| Java               |  15            |
| Go                 |  32            |
| Pypy               |  43            |
| OCaml/native       |  54            |
| Racket             |  66            |
| Common Lisp (sbcl) |  106           |
| OCaml/bytecode     |  208           |
| Ruby               |  242           |
| PHP                |  253           |
| CPython            |  380           |
| Perl               |  585           |
| JavaScript (node)  |  18\*          |
| Bash               |  2857\*\*      |

\* only up to 100 million
\*\* only up to 1 million


Following text:

 - explanations about languages used (versions, etc)
 - explanations about methodology (shell's time, repeat experiment..)
 - explanations about code (add a pseudo-code), explain that trying to stick to it in most languages. (not highly optimized sieve)
 - what to conclude (Java fast, Pypy fast-ish, OCaml slow, ...) and not conclude (no objects, simple progs)
 - memory footprint (C, Java low, Perl, PHP high)
 - javascript hard limit on array size (=~ 130 million)
 - bash very slow
 - add some justification for not comparing large systems (would be very time consuming to use objects, templates, etc.)
 - explain that the Sieve of Eratosthenes is a poor choice for functional languages, but it's hard to find a good example that works for all languages...
 - some take-aways?

TODOs:

 - Add languages: R? Erlang? Scala? Haskell?
 - compute results for various n (in progress)
 - separate compilation from execution? (to distinguish between startup time and compile-time (`javac` is a bit slow for instance))
 - Improve benchmarking (the current precision isn't too great I think)
 - Use charts rather than tables to display the results?
 - Add other examples (which ones? One that would less imperative, like run the collactz series on a notoriously long run?)
