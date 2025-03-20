package Model;

public class Account {

    private String email;
    private String password;
    private String role;

    public Account() {
    }

    public Account(String email, String password, String role) {
        this.email = email;
        this.password = password;
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }

    @Override
    public String toString() {
        return "Account{" + "email=" + email + ", password=" + password + ", role=" + role + '}';
    }
    
}
