require 'pry'
require 'securerandom'
require 'prime'
require 'async'
require 'async/barrier'
require 'async/semaphore'
require 'timeout'

# This function finds the largest prime number within a given range utilizing threads

class AsyncPrimeNumberFinder
  CONCURRENCY = 12 # Limit to 12 parallel workers
  def self.find_largest_prime_number(seconds)
    AsyncPrimeNumberFinder.new(seconds).find_largest_prime_number
  end

  def initialize(seconds)
    @seconds = seconds
    @iterator = 0
    @tasks = nil
    @start_time = Time.now
  end

  def find_largest_prime_number
    barrier = Async::Barrier.new
    semaphore = Async::Semaphore.new(CONCURRENCY, parent: barrier)
    max = 0
    Async do
      while(Time.now <= @start_time + @seconds) do
        min = @iterator + 1
        max = min + 999
        @iterator = max
        semaphore.async(parent: barrier) do
          # These searches are working in parallel
          PrimeNumberRangeSearch.new(min, max).find_largest_prime_number
        end
      end
    end
    @largest_prime = barrier.tasks.to_a.map(&:task).map(&:result).max
    puts "Searched up to #{max}, and found a largest prime of #{@largest_prime}"
    return @largest_prime
  end
  
end

class PrimeNumberRangeSearch

  def initialize(min, max)
    @start_time = Async::Clock.now
    @min = min
    @max = max
    @largest_prime = 0
    @iterator = min
    @elapsed_time = 0
  end

  def find_largest_prime_number
    while @iterator <= @max do
      if is_prime?(@iterator)
        @largest_prime = @iterator
      end
      @iterator += 1
    end
    @elapsed_time = Async::Clock.now - @start_time
    #puts "Range Search [#{@min}, #{@max}] took #{@elapsed_time} and returned a largest prime of #{@largest_prime}"
    @largest_prime
  end
  
  private 
  
  def is_prime?(number)
    Prime.prime?(number) 
  end

  def persist_largest_known_prime
    File.open("largest_known_prime.txt", "w") { |f| f.write "#{@largest_prime }" }
  end

  def largest_known_prime
    largest_know_prime = File.open("largest_known_prime.txt").read.to_i rescue 2
    puts "Starting at largest known prime #{largest_know_prime}"
    largest_know_prime
  end
end