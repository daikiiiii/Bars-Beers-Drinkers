<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert Page</title>
</head>
<body>
	<% 
	try {
		
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String table = request.getParameter("table");
		String columns = request.getParameter("colValues");
		String values = request.getParameter("values");
		
		//String query = request.getParameter("insertquery");
		
		//String insert = query;
		
		//stmt.executeUpdate(insert);
		
		String insert = "INSERT INTO " + table + " (" + columns + ") VALUES (" + values + ");";
		
		stmt.executeUpdate(insert);
		
		con.close();
		out.println("INSERT successful!");
			
	} catch (Exception ex) {
		out.println(ex);
		out.println("INSERT failed!");
	}
	
	%>
</body>
</html>