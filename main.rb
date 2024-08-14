require_relative 'prime_number_finder'
require_relative 'async_prime_number_finder'
#
#pns = 
#pns.search_for_prime
puts 'Benchmarking'
puts 'Searching for 5 seconds using synchroneous fibers'
PrimeNumberFinder.find_largest_prime_number(5)
puts 'Searching for 5 seconds using async'
AsyncPrimeNumberFinder.find_largest_prime_number(5)
