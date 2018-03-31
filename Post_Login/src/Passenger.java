import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Logger;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Passenger extends HttpServlet{

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        String origin = request.getParameter("Origin");
        String destination = request.getParameter("Destination");

        PrintWriter pr = response.getWriter();
        Logger log = Logger.getLogger(Passenger.class.getName());

        try{

        }catch (Exception ee){

        }


    }
}
