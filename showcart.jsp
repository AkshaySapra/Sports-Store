<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
</head>
<body>
<script>
function update(newid, newqty)
{
window.location="showcart.jsp?update="+newid+"&newqty="+newqty;	
}
</script>
<FORM name="form1">
<%! 
public static boolean isNumeric(String str) {
  return str.matches("-?\\d+(\\.\\d+)?"); 
}
%>
<%

	// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String newid = request.getParameter("update");
String newqty = request.getParameter("newqty");
String deleteid = request.getParameter("delete");

ArrayList<Object> product1 = new ArrayList<Object>();

if (newid != null && newqty != null && isNumeric(newqty)) {
	product1 = (ArrayList<Object>) productList.get(newid);
	if (Integer.parseInt(newqty) > 0) {
		int qtyint = Integer.parseInt(newqty);
		product1.set(3, qtyint);
	}
	else {
		deleteid = newid;
	}
}

if (deleteid != null) {
	productList.remove(deleteid);
	
}

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th><th></th><th></th></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	int count = 1;
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<td align=\"center\"><input type=\"text\" name=\"newqty"+count+"\" size=\"3\" value=\""+product.get(3)+"\"></td>");
		double pr = Double.parseDouble( (String) product.get(2));
		int qty = Integer.parseInt(product.get(3).toString());

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>&nbsp;&nbsp;&nbsp;&nbsp;<td><A HREF=\"showcart.jsp?delete="+product.get(0)+"\">Remove Item from Cart</A></td>");
		out.print("<td>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=BUTTON OnClick=\"update("+product.get(0)+", document.form1.newqty"+count+".value)\" VALUE=\"Update Quantity\" style =\"background: url(cat-300572_960_720.jpg);width:960px;height:720px;\"></td>");
		out.print("</tr>");
		total = total +pr*qty;
		++count;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
	+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
	session.setAttribute("productList", productList);
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</FORM>
</body>
</html> 

