package movieDao;

import Model.Movie;
import java.util.List;
import java.sql.SQLException;

public interface IMovieDao {

    public void insertMovie(Movie user) throws SQLException;

    public Movie selectMovie(int id);

    public List<Movie> selectAllUsers();

    public boolean deleteMovie(int id) throws SQLException;

    public boolean updateUser(Movie user) throws SQLException;
}
