import java.io.IOException;
import java.io.PrintWriter;

import java.util.logging.Logger;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = "/Passenger")
public class Passenger extends HttpServlet {


    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        String origin = request.getParameter("OriginIn");
        String destination = request.getParameter("DestinationIn");

        PrintWriter pr = response.getWriter();
        Logger log = Logger.getLogger(Passenger.class.getName());

        pr.println("<html><head><title>PICKMEUP</title></head><body>");
        pr.println("<p>" + origin + "," + destination + "</p></body></html>");
        log.info("Getting the values");
        System.out.print("Passed it");
        pr.flush();
        pr.close();
    }
}
