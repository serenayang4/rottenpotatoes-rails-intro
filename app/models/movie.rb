class Movie < ActiveRecord::Base

    def self.all_ratings
        result = {}
        
        self.select(:rating).uniq.each do |movie|
          result[movie.rating] = 1
        end
        
        return result
    end
=begin
    def self.all_ratings
        Movie.select(:rating).distinct.inject([]) {|a,m| a.push m.rating}
    end
=end
end
