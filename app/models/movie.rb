class Movie < ActiveRecord::Base
    def hello
        puts "hello_world"
    end
    #def self.all_ratings
    #    self.find(:all, :select => "rating", :group => "rating").map(&:rating)
    #end
end
