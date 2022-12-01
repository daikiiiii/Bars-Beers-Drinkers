<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"  import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<% 
	StringBuilder myData = new StringBuilder();
	StringBuilder myData2 = new StringBuilder();
	String strData = "", chartTitle = "", legend = "";
	String strData2 = "", chartTitle2 = "", legend2 = "";

	try {
		
		ArrayList<Map<String, Integer>> list = new ArrayList();
		ArrayList<Map<String, Integer>> list2 = new ArrayList();
		Map<String, Integer> map = null;
	
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String bar = request.getParameter("barname");
		
		String str = "SELECT drinker, SUM(`total price`) FROM bills WHERE bar = '" + bar + 
		"' GROUP BY drinker ORDER BY SUM(`total price`) DESC LIMIT 10";
		
		String str2 = "SELECT t.item, SUM(t.quantity) FROM (SELECT * FROM bills WHERE bar = '" + bar + 
		"') AS B LEFT JOIN transactions t ON B.bill_id = t.bill_id WHERE t.bill_id IS NOT NULL AND t.type = 'beer' " + 
		"GROUP BY t.item ORDER BY SUM(t.quantity) DESC LIMIT 10";
		
		String str3 = "SELECT manf, SUM(X.quantity) FROM (SELECT B.bill_id, t.quantity, t.item, t.price " +
		"FROM (SELECT * FROM bills WHERE bar = '" + bar + "') AS B LEFT JOIN transactions t ON B.bill_id = t.bill_id "
		+ "WHERE t.bill_id IS NOT NULL) AS X LEFT JOIN beers a ON X.item = a.`name` WHERE a.`name` IS NOT NULL " + 
		"GROUP BY a.manf ORDER BY SUM(X.quantity) DESC LIMIT 5";
		
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
						+ "COUNT(t.bill_id) AS total_transactions FROM (SELECT * FROM bills WHERE bar = '" + bar + "') AS B "
						+ "LEFT JOIN transactions t ON B.bill_id = t.bill_id GROUP BY TimeInterval ORDER BY `time`";
									  
		String query2 = "SELECT `day`, COUNT(t.bill_id) AS total_transactions FROM (SELECT * FROM bills WHERE bar = '" + bar
						 + "') AS B LEFT JOIN transactions t ON B.bill_id = t.bill_id GROUP BY `day`";
		
		ResultSet result = stmt.executeQuery(str);
		
		stmt = con.createStatement();
		
		ResultSet result2 = stmt.executeQuery(str2);
		
		stmt = con.createStatement();
		
		ResultSet result3 = stmt.executeQuery(str3);
		
		stmt = con.createStatement();
		
		ResultSet result4 = stmt.executeQuery(query);
		
		stmt = con.createStatement();
		
		ResultSet result5 = stmt.executeQuery(query2);
		
		while (result4.next()) {
			map = new HashMap<String,Integer>();
			map.put(result4.getString("TimeInterval"), result4.getInt("total_transactions"));
			list.add(map);
		}
		result4.close();
		
		for (Map<String, Integer> hashmap : list) {
			Iterator it = hashmap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pair = (Map.Entry)it.next();
				String key = pair.getKey().toString().replaceAll("'", "");
				myData.append("['" + key + "'," + pair.getValue() + "],");
			}
		}
		strData = myData.substring(0, myData.length() - 1);
		chartTitle = "Busiest Periods of the Day";
		legend = "transactions";
		
		while (result5.next()) {
			map = new HashMap<String, Integer>();
			map.put(result5.getString("day"), result5.getInt("total_transactions"));
			list2.add(map);
		}
		result5.close();
		
		for (Map<String, Integer> hashmap : list2) {
			Iterator it = hashmap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pair = (Map.Entry)it.next();
				String key = pair.getKey().toString().replaceAll("'", "");
				myData2.append("['" + key + "'," + pair.getValue() + "],");
			}
		}
		strData2 = myData2.substring(0, myData2.length() - 1);
		chartTitle2 = "Busiest Days of the Week";
		legend2 = "transactions";
%>


<!DOCTYPE html  PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Bar Page</title>
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
		<script>
			var data2 = [<%=strData2%>];
			var title2 = '<%=chartTitle2%>';
			var legend2 = '<%=legend2%>'
			var cat2 = [];
			data2.forEach(function(item) {
				cat2.push(item[0]);
			});
			document.addEventListener('DOMContentLoaded', function() {
			var myChart2 = Highcharts.chart('graphContainer', {
				chart: {
					defaultSeriesType: 'column',
					events: {
						// load: requestData
					}
				}, 
				title: {
					text: title2
				},
				xAxis: {
					text: 'xAxis',
					categories: cat2
				},
				yAxis: {
					text: 'yAxis'
				},
				series: [{
					name: legend2,
					data: data2
				}]
			});	
			});
		</script>
	</head>
	<body>
		<div>
		Top Ten Drinkers who are the largest spenders for the given Bar
		<table border='1'>
			<tr>
				<td>Drinker</td>
				<td>Total Spendings</td>
			</tr>
				<%
				while (result.next()) { %>
					<tr>
						<td><%= result.getString("drinker") %></td>
						<td><%= result.getString("SUM(`total price`)") %></td>
					</tr>
				<% }
				//db.closeConnection(con);
				%>
		</table>
		</div>
		<br>
		
		<div>
		Top 10 beers which are the most popular
		<table border='1'>
			<tr>
				<td>Beer</td>
				<td>Total Amount</td>
			</tr>
				<%
				while (result2.next()) { %>
					<tr>
						<td><%= result2.getString("t.item") %></td>
						<td><%= result2.getString("SUM(t.quantity)") %></td>
					</tr>
				<% }
				//db.closeConnection(con);
				%>
		</table>
		</div>
		<br>
		
		<div>
		Top 5 manufacturers at the given Bar
		<table border='1'>
			<tr>
				<td>Manufacturer</td>
				<td>Units Sold</td>
			</tr>
				<%
				while (result3.next()) { %>
					<tr>
						<td><%= result3.getString("manf") %></td>
						<td><%= result3.getString("SUM(X.quantity)") %></td>
					</tr>
				<% }
				db.closeConnection(con);
				%>
		</table>
		</div>
		<br>
		
		<div id="timeGraphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>
		<br>
		
		<div id="graphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>
		
	<% 
	} catch (SQLException e) {
			out.print(e);
	} catch (Exception e) {
			out.print(e);
	}
	%>
	</body>
</html>