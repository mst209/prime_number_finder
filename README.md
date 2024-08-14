# Prime Number Finder

## Problem

Write a function that looks for prime numbers for a certain amount of time. When that
amount of time has elapsed, it prints the largest prime number it found, and then returns
nil. invoked like this to run for 5 seconds: find_prime_number(5)

## Solutions

The first approach PrimeNumberFinder utilizes fibers however this is more or less just a sequential search using an iterator. I also included a file that gets created to persist the largest known prime.

The second approach AsyncPrimeNumberFinder, iterates sequentially however batches them into 1000 number ranges, executes them in parallel, and combines the results after the alloted time is up.

## Benchmarks

PrimeNumberFinder -> Largest Prime Found 1122259
AsyncPrimeNumberFinder -> Largest Prime Found 1136000

Comments: The runtimes of these are pretty similar, given that ruby isn't a natively threaded language. To acheive ideal results it would be best to do this in something designed for concurrenct such as Golang, however the excersize was to show some more advanced ruby skills that i have aquired.

## How to use

Run `bundle install`

Modify the `main.rb` file

Run the main file
```
ruby main.rb
```