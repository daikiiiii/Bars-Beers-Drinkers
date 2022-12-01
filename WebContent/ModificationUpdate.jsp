<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Update Page</title>
</head>
<body>
	<% 
	try {
		
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String table = request.getParameter("table");
		String setEntity = request.getParameter("setEntity");
		String currEntity = request.getParameter("currEntity");
		
		String update = "UPDATE " + table + " SET " + setEntity + " WHERE " + currEntity + ";";
		
		stmt.executeUpdate(update);
		
		con.close();
		out.print("UPDATE successful!");
		
	} catch (Exception ex) {
		out.println(ex);
		out.println("UPDATE failed!");
	}
	
	
	%>
</body>
</html>