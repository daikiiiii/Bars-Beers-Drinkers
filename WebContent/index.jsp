<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>BarBeerDrinker Home</title>
	</head>
	<body>

		Hello, welcome to the BarBeerDrinker Homepage! <!-- the usual HTML way -->
		<br>
		<% out.println("Here you will be able to view records, or insert or update tables."); %> <!-- output the same thing, but using 
	                                      jsp programming -->
							  
		<br>
	<br>
	
	In order to see a Drinker's transactions, please enter the Drinker's name:
	<br>
		<form method="get" action="Drinker.jsp">
			<table>
				<tr>
					<td>Drinker</td><td><input type="text" name="drinkername"></td>
				</tr>
			</table>
			<input type="submit" value="Check for the Drinker's records!">
		</form>
	<br>
	
	In order to see the records of a Bar, please enter the Bar's name:
	<br>
		<form method="get" action="Bar.jsp">
			<table>
				<tr>
					<td>Bar</td><td><input type="text" name="barname"></td>
				</tr>
			</table>
			<input type="submit" value ="Check for the Bar's records!">
		</form>
	<br>
	
	In order to see the records of a Beer, please enter the name of the Beer:
	<br>
		<form method="get" action="Beer.jsp">
			<table>
				<tr>
					<td>Beer</td><td><input type="text" name="beername"></td>
				</tr>
			</table>
			<input type="submit" value="Check for the Beer's records!">
		</form>
	<br>
	
	If you are either a new bar or old bar, or new drinker or old drinker, or anything else and would like to INSERT some records:
	<br>
	*The Structure is INSERT INTO [table] (COLUMN_VALUES,,...) VALUES (VAL1, VAL2,...)*
	<br>
	Please be sure to input with correct format with the correct arguments for each INSERT. 
		<form method="post" action="ModificationInsert.jsp">
			<table>
				<tr>
					<td>INSERT INTO </td><td><input type="text" name="table"></td>
					<td> (<input type="text" name="colValues">)</td>
				</tr>
				<tr>
					<td>VALUES </td><td>( <input type="text" name="values"> )</td>
				</tr>
			</table>
			<input type="submit" value="INSERT!">
		</form>
	<br>
	
	If you would like to UPDATE any of the records within the Database, please follow the necessary parameters:
	<br>
	*The Structure is UPDATE [table] SET [attribute = 'NEW_VALUE'] WHERE [attribute = 'CURRENT_VALUE']*
	<br>
	Please be sure to input with correct format with the correct arguments for each UPDATE.
		<form method="post" action="ModificationUpdate.jsp">
			<table>
				<tr>
					<td>UPDATE </td><td><input type="text" name="table"></td>
				</tr>
				<tr>
					<td>SET </td><td><input type="text" name="setEntity"></td>
				</tr>
				<tr>
					<td>WHERE </td><td><input type="text" name="currEntity"></td>
				</tr>
			</table>
			<input type="submit" value="UPDATE!">
		</form>
	<br>
</body>
</html>