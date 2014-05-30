class MoviesController < ApplicationController
  helper_method :sort_column
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort] ? sort_column : session[:sort]
    @all_ratings = Movie.all_ratings
    
    if params[:ratings].nil?
      @selected_ratings = session[:ratings].nil? ? Hash[@all_ratings.map { |v| [v,v] }] : session[:ratings];
      flash.keep;
      redirect_to movies_path(:sort => @sort, :ratings => @selected_ratings)
    else
      @selected_ratings = params[:ratings] 
    end
    
    session[:sort] = @sort
    session[:ratings] = @selected_ratings

    @movies = Movie.where(:rating => @selected_ratings.keys).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

end
