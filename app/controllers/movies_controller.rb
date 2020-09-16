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
    #when no boxes are checked --> redirect to last used
    if(!params.has_key?(:sort) && !params.has_key?(:ratings))
      if(session.has_key?(:sort) || session.has_key?(:ratings))
        flash.keep
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
    end
    
    @all_ratings = Movie.ratings
    
    #sort for title and release date
    if params[:sort]                #user sets a sort
       @sorting = params[:sort]
    elsif session[:sort]            #user did not set a sort
       @sorting = session[:sort]
    end

    #movie ratings filter
    if params[:ratings]             #user selected filter(s)
       @ratings = params[:ratings]
    elsif session[:ratings]         #user did not select filter(s)
       @ratings = session[:ratings]
    else                            #add checked ratings to @ratings
       @all_ratings.each do |rate|
           (@ratings ||= { })[rate] = 1
        end
    end
    
    #set movies to desired order and filter settings
    @movies = Movie.where(rating: @ratings.keys).order(@sorting)
    
    #for memory purposes (going back)
    session[:sort] = @sorting
    session[:ratings] = @ratings 
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
