<%--
  Created by IntelliJ IDEA.
  User: sid
  Date: 19/03/2018
  Time: 18:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.security.MessageDigest" %>
<%!
  private PreparedStatement find;
%>
<%!
  private PreparedStatement find2;
%>
<%
  String dbName = System.getProperty("RDS_DB_NAME");
  String userName = System.getProperty("RDS_USERNAME");
  String password = System.getProperty("RDS_PASSWORD");
  String hostname = System.getProperty("RDS_HOSTNAME");
  String port = System.getProperty("RDS_PORT");
  String jdbcUrl = "jdbc:mysql://" + hostname + ":" +
          port + "/" + dbName + "?user=" + userName + "&password=" + password;

  //get the data to enter in RDS on AWS

  String first_name = request.getParameter("first_name");
  String last_name = request.getParameter("last_name");
  String Email = request.getParameter("Email");
  String LoginEmail = request.getParameter("Email");
  String Title = request.getParameter("Title");
  String loginTitle = request.getParameter("Title");
  String Password = request.getParameter("Password");
  String hashPass = sha_256(Password);
  PrintWriter pr = response.getWriter();

  Connection con;
  Statement st2;
  Statement st;

  try {
    Class.forName("com.mysql.jdbc.Driver");  // load the driver
    con =  DriverManager.getConnection(jdbcUrl);

    find = con.prepareStatement("SELECT * FROM peopleDetails WHERE Email =?");
    find2 = con.prepareStatement("SELECT * FROM Login WHERE Email=?");

    int result = checkSignDB(Email);
    String passwordResult =checkLoginDB(LoginEmail);

    if(result == 0){
      pr.println("<html><head><title>PICKMEUP</title></head><body>");
      pr.println("<p>Person Already exist in the database </p></body></html>");
      pr.flush();
    }else{
      st = con.createStatement();
      int i = st.executeUpdate("INSERT INTO peopleDetails(First_Name,Last_Name,Email,Title,passKey)" +
              " VALUES ('" + first_name + "','" + last_name + "','" + Email + "','" + Title + "','" + hashPass + "')");
      st2 = con.createStatement();
      int j = st2.executeUpdate("INSERT INTO Login(Email,Title,passKey) VALUE('" +LoginEmail + "','"+loginTitle+"','" + hashPass +"')");
      pr.println("<html><head><title>PICKMEUP</title></head><body>");
      pr.println("<p>Connected </p></body></html>");
      pr.flush();
    }
    if(passwordResult.equals(hashPass)){//next page
      pr.println("<html><head><title>PICKMEUP</title></head><body>");
      pr.println("<p>NEXT PAGE</p></body></html>");
      pr.flush();
    }
    else{// error
      pr.println("<html><head><title>PICKMEUP</title></head><body>");
      pr.println("<p>Person Already exist in the database </p></body></html>");
      pr.flush();
    }

  }catch (Exception ee){
    ee.printStackTrace();
    pr.println("<html><head><title>PICKMEUP</title></head><body>");
    pr.println("<p>"+ee.getMessage()+"</p></body></html>");
    pr.flush();
  }


%>

<%!
  public static String sha_256(String password){

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
  public int checkSignDB( String Email) {
    try {
      find.setString(1,Email);
      ResultSet rs = find.executeQuery();
      if (rs.next()) {
        return 0;
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return 1;//direct to next page
  }
%>

<%!
  public String checkLoginDB(String LoginEmail) {
    try {
      find2.setString(1,LoginEmail);
      ResultSet rs = find2.executeQuery();
      if (rs.next()) {
        //email exist
        return rs.getString(3);//next page
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return null;//direct to next page
  }
%>
