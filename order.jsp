<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Kai's Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
String password = request.getParameter("password");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String url ="jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_kneubaue";
String uid = "kneubaue";
String pwd = "34742149";

Connection con = null;
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try {	
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	con = DriverManager.getConnection(url,uid,pwd);

	String SQL = "SELECT customerId FROM Customer WHERE customerId = ?";
	PreparedStatement pstmt1 = con.prepareStatement(SQL);
	pstmt1.setString(1,custId);
	ResultSet rst = pstmt1.executeQuery();
	if (!rst.next()) {
		out.println("<h1>Customer id is not valid. Please go back and try again.</h1>");
	}
	else if (productList == null){
		out.println("<h1>Your shopping cart is empty</h1>");
	}
	else {
		String SQL3 = "SELECT customerId FROM Customer WHERE customerId = ? AND password = ?";
		PreparedStatement passQuery = con.prepareStatement(SQL3);
		passQuery.setString(1, custId);
		passQuery.setString(2, password);
		ResultSet passSet = passQuery.executeQuery();
		if (!passSet.next()){
			out.println("<h1>Password is incorrect. Please go back and try again.</h1>");
		}
		else {
			out.println("<h1>Your Order Summary</h1>");
			out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
			out.println("<th>Price</th><th>Subtotal</th></tr>");
			
			double total =0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) 
			{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				out.print("<tr><td>"+product.get(0)+"</td>");
				out.print("<td>"+product.get(1)+"</td>");
	
				out.print("<td align=\"center\">"+product.get(3)+"</td>");
				double pr = Double.parseDouble( (String) product.get(2));
				int qty = ( (Integer)product.get(3)).intValue();
	
				out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
				out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
				out.println("</tr>");
				total = total +pr*qty;
			}
			String SQL2 = "INSERT INTO Orders (customerId, totalAmount) VALUES (?, ?)";
			PreparedStatement pstmt = con.prepareStatement(SQL2, Statement.RETURN_GENERATED_KEYS);			
			pstmt.setString(1, custId);
			pstmt.setDouble(2,total);
			pstmt.executeUpdate();
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
			out.println("<h2>Your order reference number is: " + orderId + "</h2>");
			PreparedStatement pstmt2 = con.prepareStatement("SELECT cName FROM Customer WHERE customerId = ?");
			pstmt2.setString(1, custId);
			ResultSet rst2 = pstmt2.executeQuery();
			rst2.next();
			out.println("<h2>Shipping to Customer ID: " + custId + ", Name: " + rst2.getString(1) + "</h2>");
		
			iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) 
			{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				PreparedStatement pstmt3 = con.prepareStatement("INSERT INTO OrderedProduct VALUES (?, ?, ?, ?)");
				String productId = (String) product.get(0);
	        	String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				pstmt3.setInt(1, orderId);
				pstmt3.setObject(2, productId);
				pstmt3.setObject(3, qty);
				pstmt3.setObject(4, pr);
				pstmt3.executeUpdate();
			}
			productList = null;
			session.setAttribute("productList", productList);
		}
	}
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
</BODY>
</HTML>

