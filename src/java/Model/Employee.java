package Model;

import java.sql.Date;

public class Employee {

    private String empID;
    private String empName;
    private double salary;
    private String phoneNumber;
    private String email;
    private String gender;
    private Date birthday;
    private Date hireDate;
    private String address;
    private String cinemaID;

    public Employee() {
    }

    public Employee(String empID, String empName, double salary, String phoneNumber, String email, String gender,
            Date birthday, Date hireDate, String address, String cinemaID) {
        this.empID = empID;
        this.empName = empName;
        this.salary = salary;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.gender = gender;
        this.birthday = birthday;
        this.hireDate = hireDate;
        this.address = address;
        this.cinemaID = cinemaID;
    }

    public String getEmpID() {
        return empID;
    }

    public void setEmpID(String empID) {
        this.empID = empID;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCinemaID() {
        return cinemaID;
    }

    public void setCinemaID(String cinemaID) {
        this.cinemaID = cinemaID;
    }

    @Override
    public String toString() {
        return "Employee{" + "empID=" + empID + ", empName=" + empName + ", salary=" + salary + ", phoneNumber="
                + phoneNumber + ", email=" + email + ", gender=" + gender + ", birthday=" + birthday + ", hireDate="
                + hireDate + ", address=" + address + ", cinemaID=" + cinemaID + '}';
    }
}
