<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<% 
	StringBuilder myData = new StringBuilder();
	StringBuilder myData2 = new StringBuilder();
	StringBuilder myData3 = new StringBuilder();
	String strData = "", chartTitle = "", legend = "";
	String strData2 = "", chartTitle2 = "", legend2 = "";
	String strData3 = "", chartTitle3 = "", legend3 = "";
	
	//String chartTitle = "";
	//String legend = "";

	try {
		
		ArrayList<Map<String, Integer>> list = new ArrayList();
		ArrayList<Map<String, Integer>> list2 = new ArrayList();
		ArrayList<Map<String, Integer>> list3 = new ArrayList();
		Map<String, Integer> map = null;
	
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement stmt = con.createStatement();
		
		String drinker = request.getParameter("drinkername");
		
		String str ="SELECT b.bill_id, b.bar, b.`date`, b.`time`, b.`day`, t.quantity, t.item, t.`type`, t.price "
		+ "FROM bills b LEFT JOIN transactions t ON b.bill_id = t.bill_id WHERE b.drinker = '" + drinker +
		"' ORDER BY " + "b.bar, b.`date`, b.`time`";
		
		String query = "SELECT t.item, SUM(t.quantity) FROM (SELECT * FROM bills WHERE drinker = '" + drinker +
		"') AS B LEFT JOIN transactions t ON B.bill_id = t.bill_id WHERE t.bill_id IS NOT NULL AND t.`type` = 'beer'" +
		" GROUP BY t.item ORDER BY SUM(t.quantity) DESC LIMIT 10";
		
		String query2 = "SELECT `day`, SUM(`total price`) AS total_price FROM bills WHERE drinker = '" + drinker + 
		"' GROUP BY `day`";
		
		String query3 = "SELECT CASE " + "WHEN `date` >= '2018-01-01' AND `date` <  '2018-02-01' THEN 'January' "
									   + "WHEN `date` >= '2018-02-01' AND `date` < '2018-03-01' THEN 'Februrary' "
									   + "WHEN `date` >= '2018-03-01' AND `date` < '2018-04-01' THEN 'March' "
									   + "WHEN `date` >= '2018-04-01' AND `date` < '2018-05-01' THEN 'April' "
									   + "WHEN `date` >= '2018-05-01' AND `date` < '2018-06-01'THEN 'May' "
									   + "WHEN `date` >= '2018-06-01' AND `date` < '2018-07-01' THEN 'June' "
									   + "WHEN `date` >= '2018-07-01' AND `date` < '2018-08-01' THEN 'July' "
									   + "WHEN `date` >= '2018-08-01' AND `date` < '2018-09-01' THEN 'August' "
									   + "WHEN `date` >= '2018-09-01' AND `date` < '2018-10-01' THEN 'September' "
									   + "WHEN `date` >= '2018-10-01' AND `date` < '2018-11-01' THEN 'October' "
									   + "WHEN `date` >= '2018-11-01' AND `date` < '2018-12-01' THEN 'November' "
									   + "WHEN `date` >= '2018-12-01' THEN 'December' END AS DateInterval, SUM(`total price`)"
						 + " AS total_spendings FROM bills WHERE drinker = '" + drinker + "' GROUP BY DateInterval";
		
		ResultSet result = stmt.executeQuery(str); 
		
		stmt = con.createStatement();
		
		ResultSet result2 = stmt.executeQuery(query);
		
		stmt = con.createStatement();
		
		ResultSet result3 = stmt.executeQuery(query2);
		
		stmt = con.createStatement();
		
		ResultSet result4 = stmt.executeQuery(query3);
		
		/*FOR THE GRAPH OF THE BEERS THAT THE DRINKER PURCHASES THE MOST*/
		while (result2.next()) {
			map = new HashMap<String, Integer>();
			map.put(result2.getString("item"), result2.getInt("SUM(t.quantity)"));
			list.add(map);
		}
		result2.close();
		
		/*Loops through all objects within the ArrayList*/
		for (Map<String, Integer> hashmap : list) {
			Iterator it = hashmap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pair = (Map.Entry)it.next();
				String key = pair.getKey().toString().replaceAll("'", "");
				myData.append("['" + key + "'," + pair.getValue() + "],");
			}
		}
		strData = myData.substring(0, myData.length() - 1);
		chartTitle = "Most Beers the Drinker Ordered";
		legend = "beers"; 
		
		/*FOR THE TIME DISTRIBUTION OF THE SPENDINGS OF THE DRINKER AMONGST DIFFERENT DAYS*/
		while (result3.next()) {
			map = new HashMap<String, Integer>();
			map.put(result3.getString("day"), result3.getInt("total_price"));
			list2.add(map);
		}
		result3.close();
		
		for (Map<String, Integer> hashmap : list2) {
			Iterator it = hashmap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pair = (Map.Entry)it.next();
				String key = pair.getKey().toString().replaceAll("'", "");
				myData2.append("['" + key + "'," + pair.getValue() + "],");
			}
		}
		strData2 = myData2.substring(0, myData2.length() - 1);
		chartTitle2 = "Spendings Throughout the Week";
		legend2 = "spendings";
		
		while (result4.next()) {
			map = new HashMap<String, Integer>();
			map.put(result4.getString("DateInterval"), result4.getInt("total_spendings"));
			list3.add(map);
		}
		result4.close();
		
		for (Map<String, Integer> hashmap : list3) {
			Iterator it = hashmap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry pair = (Map.Entry)it.next();
				String key = pair.getKey().toString().replaceAll("'", "");
				myData3.append("['" + key + "'," + pair.getValue() + "],");
			}
		}
		strData3 = myData3.substring(0, myData3.length() - 1);
		chartTitle3 = "Spendings Throughout the Months";
		legend3 = "spendings";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Drinker Page</title>
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
			var myChart = Highcharts.chart('graphContainer', {
				chart: {
					defaultSeriesType: 'column',
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
			var myChart2 = Highcharts.chart('timegraphContainer', {
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
		<script>
			var data3 = [<%=strData3%>];
			var title3 = '<%=chartTitle3%>';
			var legend3 = '<%=legend3%>'
			var cat3 = [];
			data3.forEach(function(item) {
				cat3.push(item[0]);
			});
			document.addEventListener('DOMContentLoaded', function() {
			var myChart3 = Highcharts.chart('timegraphContainer2', {
				chart: {
					defaultSeriesType: 'column',
					events: {
						// load: requestData
					}
				}, 
				title: {
					text: title3
				},
				xAxis: {
					text: 'xAxis',
					categories: cat3
				},
				yAxis: {
					text: 'yAxis'
				},
				series: [{
					name: legend3,
					data: data3
				}]
			});	
			});
		</script>
	</head>
	<body>
		<div>
		Transactions of the Drinker sorted by Bars, Date and Time
		<table border='1'>
			<tr>
				<td>Bill ID</td>
				<td>Bar</td>
				<td>Date</td>
				<td>Time</td>
				<td>Day</td>
				<td>Quantity</td>
				<td>Item</td>
				<td>Type</td>
				<td>Price</td>
			</tr>
				<% 
				while (result.next()) { %>
					<tr>
						<td><%= result.getString("b.bill_id")%></td>
						<td><%= result.getString("b.bar") %></td>
						<td><%= result.getDate("date") %></td>
						<td><%= result.getTime("b.time") %></td>
						<td><%= result.getString("b.day") %></td>
						<td><%= result.getInt("t.quantity") %></td>
						<td><%= result.getString("t.item") %></td>
						<td><%= result.getString("t.type") %></td>
						<td><%= result.getDouble("t.price") %></td>
					</tr>
				<% }
				db.closeConnection(con);
				%>
		</table>
		</div>
		<br>
		
		<div id="graphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>
		<br>
		
		<div id="timegraphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>
		<br>
		
		<div id="timegraphContainer2" style="width: 500px; height: 400px; margin: 0 auto"></div>
		
	<% 
	} catch(SQLException e) {	
		out.print(e);
	} catch(Exception e) {
		out.print(e);
	}
	%>

	</body>
</html>