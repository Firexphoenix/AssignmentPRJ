package Model;

import java.util.Date;

public class Movie {
    private String movieID;
    private String movieTitle;
    private String movieGenre;
    private Date releaseDate;
    private String director;
    private int movieDuration;
    private String language;

    public Movie() {
    }

    public Movie(String movieID, String movieTitle, String movieGenre, Date releaseDate, String director,
                 int movieDuration, String language) {
        this.movieID = movieID;
        this.movieTitle = movieTitle;
        this.movieGenre = movieGenre;
        this.releaseDate = releaseDate;
        this.director = director;
        this.movieDuration = movieDuration;
        this.language = language;
    }

    public String getMovieID() {
        return movieID;
    }

    public void setMovieID(String movieID) {
        this.movieID = movieID;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getMovieGenre() {
        return movieGenre;
    }

    public void setMovieGenre(String movieGenre) {
        this.movieGenre = movieGenre;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public int getMovieDuration() {
        return movieDuration;
    }

    public void setMovieDuration(int movieDuration) {
        this.movieDuration = movieDuration;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    @Override
    public String toString() {
        return "Movie{" + "movieID=" + movieID + ", movieTitle=" + movieTitle + ", movieGenre=" 
                + movieGenre + ", releaseDate=" + releaseDate + ", director=" + director + ", movieDuration=" 
                + movieDuration + ", language=" + language + '}';
    }
}

