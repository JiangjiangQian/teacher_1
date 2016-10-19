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
    @movies = Movie.order(params[:sort_by])
    @sort = params[:sort_by]
    @all_ratings = Movie.ratings
    @choice = params[:ratings]
 

 
    if @choice!=nil
	    session[:savedRatings] = @choice
	    if (session[:savedSortVal]!=nil)
	    	@movies = Movie.where(:rating => @choice.keys).order(session[:savedSortVal] + ' ASC')
	    else
		@movies = Movie.where(:rating => @choice.keys)
	    end
    else
	@choice = {}
    end
 
   if @sort!=nil
	 session[:savedSortVal] = @sort
	if @choice!={}
	    @movies = Movie.where(:rating => @choice.keys).order(@sort + ' ASC')
	else
	    @movies = Movie.order(@sort + ' ASC')
	end
    end

  if (@sort==nil && @choice=={} && (session[:savedSortVal]!=nil or session[:savedRatings]!=nil))
	 flash.keep
	 redirect_to movies_path(:sort => session[:savedSortVal], :ratings => session[:savedRatings])
  end


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