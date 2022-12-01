<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<% 

	StringBuilder myData = new StringBuilder();
	String strData = "", chartTitle = "", legend = "";

	try {
	
		ArrayList<Map<String, Integer>> list = new ArrayList();
		Map<String, Integer> map = null;
		
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String beer = request.getParameter("beername");
		
		String str = "SELECT b.bar, SUM(t.quantity) FROM (SELECT * FROM transactions WHERE item = '" + beer + 
		"') AS T LEFT JOIN bills b ON T.bill_id = b.bill_id WHERE b.bill_id IS NOT NULL GROUP BY b.bar ORDER BY "
		+ "SUM(T.quantity) DESC LIMIT 5";
		
		String str2 = "SELECT b.drinker, SUM(T.quantity) FROM (SELECT * FROM transactions WHERE item = '" + beer + 
		"') AS T LEFT JOIN bills b ON T.bill_id = b.bill_id WHERE b.bill_id IS NOT NULL GROUP BY b.drinker ORDER BY "
		+ "SUM(T.quantity) DESC LIMIT 10";
		
		String query = "SELECT CASE " + "WHEN `time` >= '00:00:00' AND `time` < '01:00:00' THEN '12 AM' "
									  + "WHEN `time` >= '01:00:00' AND `time` < '02:00:00' THEN '1 AM' "
									  + "WHEN `time` >= '02:00:00' AND `time` < '03:00:00' THEN '2 AM' "
									  + "WHEN `time` >= '03:00:00' AND `time` < '04:00:00' THEN '3 AM' "
									  + "WHEN `time` >= '04:00:00' AND `time` < '05:00:00' THEN '4 AM' "
									  + "WHEN `time` >= '05:00:00' AND `time` < '06:00:00' THEN '5 AM' "
									  + "WHEN `time` >= '06:00:00' AND `time` < '07:00:00' THEN '6 AM' "
									  + "WHEN `time` >= '07:00:00' AND `time` < '08:00:00' THEN '7 AM' "
									  + "WHEN `time` >= '08:00:00' AND `time` < '09:00:00' THEN '8 AM' "
									  + "WHEN `time` >= '09:00:00' AND `time` < '10:00:00' THEN '9 AM' "
									  + "WHEN `time` >= '10:00:00' AND `time` < '11:00:00' THEN '10 AM' "
									  + "WHEN `time` >= '11:00:00' AND `time` < '12:00:00' THEN '11 AM' "
									  + "WHEN `time` >= '12:00:00' AND `time` < '13:00:00' THEN '12 PM' "
									  + "WHEN `time` >= '13:00:00' AND `time` < '14:00:00' THEN '1 PM' "
									  + "WHEN `time` >= '14:00:00' AND `time` < '15:00:00' THEN '2 PM' "
									  + "WHEN `time` >= '15:00:00' AND `time` < '16:00:00' THEN '3 PM' "
									  + "WHEN `time` >= '16:00:00' AND `time` < '17:00:00' THEN '4 PM' "
									  + "WHEN `time` >= '17:00:00' AND `time` < '18:00:00' THEN '5 PM' "
									  + "WHEN `time` >= '18:00:00' AND `time` < '19:00:00' THEN '6 PM' "
									  + "WHEN `time` >= '19:00:00' AND `time` < '20:00:00' THEN '7 PM' "
									  + "WHEN `time` >= '20:00:00' AND `time` < '21:00:00' THEN '8 PM' "
									  + "WHEN `time` >= '21:00:00' AND `time` < '22:00:00' THEN '9 PM' "
									  + "WHEN `time` >= '22:00:00' AND `time` < '23:00:00' THEN '10 PM' "
									  + "WHEN `time` >= '23:00:00' AND `time` < '24:00:00' THEN '11 PM' END AS TimeInterval, "
						+ "SUM(t.quantity) AS quantity FROM (SELECT * FROM transactions WHERE item = '" + beer + "') AS T "
						+ "LEFT JOIN bills b ON T.bill_id = b.bill_id WHERE b.bill_id IS NOT NULL GROUP BY TimeInterval "
						+ "ORDER BY `time`";
		
		ResultSet result = stmt.executeQuery(str);
		
		stmt = con.createStatement();
		
		ResultSet result2 = stmt.executeQuery(str2);
		
		stmt = con.createStatement();
		
		ResultSet result3 = stmt.executeQuery(query);
		
		while (result3.next()) {
			map = new HashMap<String, Integer>();
			map.put(result3.getString("TimeInterval"), result3.getInt("quantity"));
			list.add(map);
		}
		result3.close();
		
		for (Map<String, Integer> hashmap : list) {
			Iterator it = hashmap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pair = (Map.Entry)it.next();
				String key = pair.getKey().toString().replaceAll("'", "");
				myData.append("['" + key + "'," + pair.getValue() + "],");
			}
		}
		strData = myData.substring(0, myData.length() - 1);
		chartTitle = "Most Sells Throughout the Day";
		legend = "sells";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Beer Page</title>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script>
			var data = [<%=strData%>];
			var title = '<%=chartTitle%>';
			var legend = '<%=legend%>'
			var cat = [];
			data.forEach(function(item) {
				cat.push(item[0]);
			});
			document.addEventListener('DOMContentLoaded', function() {
			var myChart = Highcharts.chart('timeGraphContainer', {
				chart: {
					defaultSeriesType: 'line',
					events: {
						// load: requestData
					}
				}, 
				title: {
					text: title
				},
				xAxis: {
					text: 'xAxis',
					categories: cat
				},
				yAxis: {
					text: 'yAxis'
				},
				series: [{
					name: legend,
					data: data
				}]
			});	
			});
		</script>
	</head>
	<body>
		<div>
		Top 5 bars that sell the most of the given beer
		<table border='1'>
			<tr>
				<td>Bar</td>
				<td>Units Sold</td>
			</tr>
				<% 
				while (result.next()) { %>
					<tr>
						<td><%= result.getString("bar") %></td>
						<td><%= result.getString("SUM(T.quantity)") %></td>
					</tr>
				<% }
				//db.closeConnection(con);
				%>
		</table>
		</div>
		<br>
		
		<div>
		Drinkers who are the biggest consumer of given beer
		<table border='1'>
			<tr>
				<td>Drinker</td>
				<td>Amount Purchased</td>
			</tr>
				<%
				while (result2.next()) { %>
					<tr>
						<td><%= result2.getString("b.drinker") %></td>
						<td><%= result2.getString("SUM(T.quantity)") %></td>
					</tr>
				<% }
				db.closeConnection(con);
				%>
		</table>
		</div>
		<br>
		
		<div id="timeGraphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>
		
	<% 
	} catch(SQLException e) {
		out.print(e);
	} catch (Exception e) {
		out.print(e);
	} 
	%>
	</body>
</html>