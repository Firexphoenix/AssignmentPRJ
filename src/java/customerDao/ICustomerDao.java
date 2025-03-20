package customerDao;

import Model.Customer;
import java.sql.SQLException;
import java.util.List;

public interface ICustomerDao {

    void insertCustomer(Customer customer, String password) throws SQLException;

    Customer getCustomerById(String customerID);

    Customer getCustomerByEmail(String email);

    List<Customer> getAllCustomers();

    boolean updateCustomer(Customer customer) throws SQLException;

    boolean deleteCustomer(String customerID) throws SQLException;

    Customer loginCustomer(String email, String password);
}
