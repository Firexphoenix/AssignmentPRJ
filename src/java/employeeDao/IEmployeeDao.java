package employeeDao;

import Model.Employee;
import java.sql.SQLException;
import java.util.List;

public interface IEmployeeDao {

    void insertEmployee(Employee emp, String password, String role) throws SQLException;

    Employee selectEmployee(String empID);

    List<Employee> selectAllEmployees();

    boolean deleteEmployee(String empID) throws SQLException;

    boolean updateEmployee(Employee emp) throws SQLException;

    Employee getEmployeeByEmail(String email);
    
    Employee getEmployeeById(String empID);
}
