class Movie < ActiveRecord::Base
    def self.ratings
        Movie.select(:rating).distinct.inject([]) {|a,mov| a.push mov.rating}
    end
end