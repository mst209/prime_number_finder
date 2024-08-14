require 'pry'
require 'securerandom'
require 'prime'
require 'async'
require 'timeout'

# This function finds the largest prime number within a given range
class PrimeNumberFinder

  def self.find_largest_prime_number(seconds)
    PrimeNumberFinder.new(seconds).search_for_largest_prime
  end

  def initialize(seconds)
    @seconds = seconds
    @largest_prime = largest_known_prime
    @iterator = @largest_prime
    @search_fiber = setup_search_fiber
  end

  def search_for_largest_prime
    begin
      Timeout.timeout(@seconds) do
        while true do
          @search_fiber.resume
        end
      end
      rescue Timeout::Error
        puts "Largest prime found: #{@largest_prime} in #{@seconds} seconds"
        persist_largest_known_prime
      end
  end
  
  private 
  
  def setup_search_fiber
    Fiber.new do
      loop do
        if is_prime?(@iterator)
          @largest_prime = @iterator
        end
        @iterator += 1
        Fiber.yield
      end
    end
  end

  def is_prime?(number)
    # I don't think i am going to write a more efficient prime check than this.
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