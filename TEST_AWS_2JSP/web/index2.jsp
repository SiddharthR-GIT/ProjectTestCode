<%--
  Created by IntelliJ IDEA.
  User: sid
  Date: 20/03/2018
  Time: 18:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.security.MessageDigest" %>
<%!
    private PreparedStatement find;//global variable
%>

<%
    String dbName = System.getProperty("RDS_DB_NAME");
    String userName = System.getProperty("RDS_USERNAME");
    String password = System.getProperty("RDS_PASSWORD");
    String hostname = System.getProperty("RDS_HOSTNAME");
    String port = System.getProperty("RDS_PORT");
    String jdbcUrl = "jdbc:mysql://" + hostname + ":" +
            port + "/" + dbName + "?user=" + userName + "&password=" + password;

    String loginEmail = request.getParameter("Email");
    String loginpassword = request.getParameter("Password");
    String hashedPasskey =sha_256(loginpassword);
    PrintWriter pr = response.getWriter();

    try {
        String driver = "com.mysql.jdbc.Driver";
        //String url = "jdbc:mysql://localhost:3306/Details?autoReconnect=true&useSSL=false";
        Class.forName(driver);  // load the driver
        Connection connection = DriverManager.getConnection(jdbcUrl);

        find = connection.prepareStatement("SELECT * FROM Login WHERE Email =?");
        //data to enter the sign up page
        String checkPasswords = checkLoginDB(loginEmail); // checking for duplicate email
        if(checkPasswords.equals(hashedPasskey)){
            pr.println("<html><head><title>PICKMEUP</title></head><body>");
            pr.println("<p>Password match</p></body></html>");
            pr.flush();
        }
        else {
            pr.println("<html><head><title>PICKMEUP</title></head><body>");
            pr.println("<p>ERROR - no match password or email</p></body></html>");
            pr.flush();

        }
    } catch (Exception e) {
        e.printStackTrace();
    }

%>

<%!
    public String sha_256(String password){

        try{
            MessageDigest msg = MessageDigest.getInstance("SHA-256");
            byte[] hash = msg.digest(password.getBytes("UTF-8"));
            StringBuffer hexStr = new StringBuffer();

            for(int i = 0; i< hash.length;i++){
                String hex = Integer.toHexString(0xff & hash[i]);
                if(hex.length() == 1)hexStr.append('0');
                hexStr.append(hex);
            }
            return hexStr.toString();
        }catch (Exception ex){
            throw new RuntimeException(ex);
        }
    }
%>

<%!
    public String checkLoginDB(String LoginEmail) {
        try {
            find.setString(1,LoginEmail);
            ResultSet rs = find.executeQuery();
            if (rs.next()) {
                //email exist
                return rs.getString(4);//next page

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;//direct to next page
    }
%>