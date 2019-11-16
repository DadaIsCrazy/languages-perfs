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
in a bunch of languages. I them ran those codes and timed them. Here
are the results:

| **Language**   | C   | Java   | CPython | Pypy  | Perl  | OCaml/native  | OCaml/bytecode  | PHP | Ruby |
| -----------    | --- | -----  |-------- | ----- | ----- | ------------- | --------------- | --- | ---- |
| **Time (sec)** |15   | 15     |  380    |  43   | 585   |  54           |   208           | 253 | 242  |


Following text:

 - explanations about languages used (versions, etc)
 - explanations about methodology (shell's time, repeat experiment..)
 - explanations about code (add a pseudo-code), explain that trying to stick to it in most languages. (not highly optimized sieve)
 - what to conclude (Java fast, Pypy fast-ish, OCaml slow, ...) and not conclude (no objects, simple progs)
 - memory footprint (C, Java low, Perl, PHP high)
 - Javascript: not doable because max array size =~ 100 million elements.
 - some take-aways?

TODOs:

 - Add languages: Common Lisp? Go? R? Scheme? Erlang? Scala? Haskell?
 - write makefile
