import javax.mail.internet.InternetAddress;
import sun.jvm.hotspot.debugger.AddressException;

public class ValidEmailAddress {

    public static boolean isEmailValid(String email){
        boolean feedback = true;

        try{
            InternetAddress emailAdd = new InternetAddress(email);
            emailAdd.validate(); // valid the email if its real or fake
            System.out.println("Email is valid");

        } catch (AddressException e) {
            e.printStackTrace();
            System.out.println("Email is  NOT valid");
            feedback = false;
        } catch (javax.mail.internet.AddressException e) {
            e.printStackTrace();
        }
        return feedback;
    }
}





