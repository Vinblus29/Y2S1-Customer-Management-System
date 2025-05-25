
package Model;
import java.sql.Connection;
import java.sql.DriverManager;

public class connection {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/customercaresystem", "root", "Keerthi@2002");
            System.out.println("Connection successful!");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Connection unsuccessful!");
        }
    }
}
