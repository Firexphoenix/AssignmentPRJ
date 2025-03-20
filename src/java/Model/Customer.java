package Model;

import java.util.Date;

public class Customer {

    private String customerID;
    private String customerName;
    private String email;
    private String phoneNumber;
    private Date birthday;
    private String gender;

    public Customer() {
    }

    public Customer(String customerID, String customerName, String email, String phoneNumber, Date birthday, String gender) {
        this.customerID = customerID;
        this.customerName = customerName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.birthday = birthday;
        this.gender = gender;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    @Override
    public String toString() {
        return "Customer{" + "customerID=" + customerID + ", customerName=" + customerName
                + ", email=" + email + ", phoneNumber=" + phoneNumber + ", birthday=" + birthday
                + ", gender=" + gender + '}';
    }
}
