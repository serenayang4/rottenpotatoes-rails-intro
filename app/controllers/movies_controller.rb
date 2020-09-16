class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
 
    #when no boxes ar checked --> redirect to last used
    if(!params.has_key?(:sort) && !params.has_key?(:ratings))
      if(session.has_key?(:sort) || session.has_key?(:ratings))
        flash.keep
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
    end
=begin       
    @all_ratings = Movie.all_ratings.keys
    @ratings = params[:ratings]
    
    #added rating filter
    if(@ratings != nil)
      ratings = @ratings.keys
      session[:ratings] = @ratings
    else #no checked
      if(!params.has_key?(:commit) && !params.has_key?(:sort)) #not submitted yet
        ratings = Movie.all_ratings.keys
        session[:ratings] = Movie.all_ratings
      else #was submitted
        ratings = session[:ratings].keys
      end
    end

    #redefine movies to have filtered movies
    #@movies = Movie.order(sort_column).select { |filteredMovies| ratings.include?filteredMovies.rating }
    
=end
    @all_ratings = Movie.ratings
    
    if params[:sort]
       @sorting = params[:sort]
    elsif session[:sort]
       @sorting = session[:sort]
    end

    if params[:ratings]
       @ratings = params[:ratings]
    elsif session[:ratings]
       @ratings = session[:ratings]
    else
       @all_ratings.each do |rat|
           (@ratings ||= { })[rat] = 1
        end
    end
   
    @movies = Movie.where(rating: @ratings.keys).order(@sorting)
    
    session[:sort] = @sorting
    session[:ratings] = @ratings 
  end 
  
  private
  def sort_column
    params[:sort] || "title"
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
