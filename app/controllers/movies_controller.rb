class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  # debugger
    prev = request.referer
    if (prev.nil? || !prev.include?("aws") || !prev.include?("heroku"))
      session.clear
    end
    @all_ratings = Movie.all_ratings
    @sort = params[:sort_by]
    # redirect = false
    
    # if params[:ratings].nil?
    #   @ratings_to_show = @all_ratings
    #   @movies = Movie.with_ratings(@ratings_to_show)
      
    # else
    #   @ratings_to_show = params[:ratings].keys
    #   @movies = Movie.with_ratings(@ratings_to_show)
    # end
   
    
    if params[:ratings].nil?
      if params[:commit]=="Refresh"
         @ratings_to_show = @all_ratings
      else 
        if !session[:ratings].nil?
          if session[:ratings].is_a? Array
            @ratings_to_show = session[:ratings]
          else
             @ratings_to_show = session[:ratings].keys
          end
        else
          @ratings_to_show = @all_ratings
        end
      end
      if !session[:sort_by].nil?
        @sort= session[:sort_by]
      end
    else
      if params[:ratings].is_a? Array
        
        @ratings_to_show = params[:ratings]
        session[:ratings]= params[:ratings]
        session[:sort_by] = params[:sort_by]
        # if params[:sort_by].nil?
          @sort= session[:sort_by]
        # else
          # session[:sort_by] = params[:sort_by]
        # end
        # if !session[:sort_by].nil?
        #   @sort= session[:sort_by]
        # end
      else
        # puts hello
        @ratings_to_show = params[:ratings].keys
        session[:ratings]= params[:ratings]
        session[:sort_by] = params[:sort_by]
        @sort= session[:sort_by]
        # if params[:sort_by].nil?
          # @sort= session[:sort_by]
        # else
          # session[:sort_by] = params[:sort_by]
        # end
      end
    end
    @movies = Movie.with_ratings(@ratings_to_show, @sort)
    
   
      
      
    @movies = Movie.with_ratings(@ratings_to_show, @sort)
    
    
    
      
  
      
    
    
    # @movies = Movie.all
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
