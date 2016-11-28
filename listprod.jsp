<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Kai's Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
String url ="jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_kneubaue";
String uid = "kneubaue";
String pwd = "34742149";
Connection con = null;
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	con = DriverManager.getConnection(url,uid,pwd);
	String SQL = "SELECT productId, productName, price FROM product";
	PreparedStatement pstmt = null;
	
	if (name == null || name == "") {
		pstmt = con.prepareStatement(SQL);
		out.println("<h2>All Products</h2>");
	}
	else {
		SQL += " WHERE productName LIKE ?";
		pstmt = con.prepareStatement(SQL);
		out.println("<h2>Products containing '" + name + "'</h2>");
		name = "%" + name + "%";
		pstmt.setString(1, name);
	}
	ResultSet rst = pstmt.executeQuery();
	
	out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");
	while (rst.next()) {
		out.println("<tr><td><a href = \"addcart.jsp?id=" + rst.getString("productId") + "&name=" + rst.getString("productName") + "&price=" +rst.getDouble("price") + "\">Add to Cart</a></td><td>" + rst.getString("productName") + "</td><td>" + currFormat.format(rst.getDouble("price")) + "</td></tr>");
	}
}
catch (SQLException ex) {
	out.println("SQLException: " + ex);
}
finally {
	if (con!=null) {
		try {
			con.close();
			}
		catch (SQLException ex){
			out.println("SQLException: " + ex);
		}
	}
}
%>

</body>
</html>