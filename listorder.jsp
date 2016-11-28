<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Kai's Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%@page import = "java.sql.*"%>
<%	
	String url ="jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_kneubaue";
	String uid = "kneubaue";
	String pwd = "34742149";
	Connection con = null;
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	
	try {	
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		con = DriverManager.getConnection(url,uid,pwd);
		Statement stmt = con.createStatement();
	
		String SQL = "SELECT orderId, C.customerId, C.cname, totalAmount "
				+ "FROM Orders O, Customer C "
				+ "WHERE O.customerId = C.customerId";
		
		ResultSet rst = stmt.executeQuery(SQL);
		
		out.println("<table border=\"1\"><tr><th>Order Id</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
		
		while (rst.next()) {
			out.println("<tr><td>" + rst.getString(1) + "</td><td>" + rst.getString(2) + "</td><td>" + rst.getString(3) + "</td><td>" +currFormat.format(rst.getDouble(4)) + "</td>");
			String SQL2 = "SELECT productId, quantity, price "
					+ "FROM OrderedProduct WHERE orderId = ?";
			PreparedStatement pstmt = con.prepareStatement(SQL2);
			pstmt.setString(1, rst.getString(1));
			ResultSet rst2 = pstmt.executeQuery();
			out.println("<tr align = \"right\"><td colspan = \"4\"><table border = \"1\">");
			out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th>");
			while (rst2.next()) {
				out.println("<tr><td>" + rst2.getString(1) + "</td><td>" + rst2.getString(2) + "</td><td>" + currFormat.format(rst2.getDouble(3)) + "</td>");
			}
			out.println("</table></td></tr>");
		}
		out.println("</table>");
		
		
	}
	catch (SQLException ex) {
		out.println(ex);
	}
	finally {
		if (con != null) try {
			con.close(); 
		}
		catch (SQLException ex) {
			System.err.println("SQLException: " + ex);
		}
	}
	
%>

</body>
</html>

