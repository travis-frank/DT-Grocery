<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
<html>
<head>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <%@ include file="header.jsp" %>
    <title>Cart</title>
    <style>
        .empty-cart {
            text-align: center;
            margin-top: 50px;
            padding: 20px;
            border: 2px dashed #ff7f50;
            background-color: #fff3e6;
            color: #ff7f50;
            font-size: 1.5rem;
            border-radius: 10px;
        }

        .empty-cart a {
            color: #ff7f50;
            text-decoration: none;
            font-weight: bold;
        }

        .empty-cart a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">

<%
    // Handle removal of an item if requested
    String removeProductId = request.getParameter("removeId");
    if (removeProductId != null) {
        @SuppressWarnings("unchecked")
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        if (productList != null) {
            productList.remove(removeProductId);
            session.setAttribute("productList", productList); // Update session
        }
    }

    // Get the current list of products
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null || productList.isEmpty()) {
%>
        <div class="empty-cart">
            <p>Your shopping cart is empty!</p>
            <a href="listprod.jsp">Continue Shopping</a>
        </div>
<%
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

        out.println("<h1>Your Shopping Cart</h1>");
        out.print("<table class=\"table table-bordered table-striped\"><tr>");
        out.print("<th>Product Id</th><th>Product Name</th><th>Quantity</th>");
        out.println("<th>Price</th><th>Subtotal</th><th>Action</th></tr>");

        double total = 0;
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
            ArrayList<Object> product = entry.getValue();
            if (product.size() < 4) {
                out.println("Expected product with four entries. Got: " + product);
                continue;
            }

            out.print("<tr><td>" + product.get(0) + "</td>");
            out.print("<td>" + product.get(1) + "</td>");
            out.print("<td align=\"center\">" + product.get(3) + "</td>");

            Object price = product.get(2);
            Object itemQty = product.get(3);
            double pr = 0;
            int qty = 0;

            try {
                pr = Double.parseDouble(price.toString());
            } catch (Exception e) {
                out.println("Invalid price for product: " + product.get(0) + " price: " + price);
            }
            try {
                qty = Integer.parseInt(itemQty.toString());
            } catch (Exception e) {
                out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
            }

            out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
            out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>");
            // Add Remove link
            out.print("<td align=\"center\"><a href=\"showcart.jsp?removeId=" + product.get(0) + "\">Remove</a></td>");
            out.println("</tr>");

            total = total + pr * qty;
        }

        out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                + "<td align=\"right\">" + currFormat.format(total) + "</td><td></td></tr>");
        out.println("</table>");

        out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
        out.println("<h2><a href=\"listprod.jsp.jsp\">Continue Shopping</a></h2>");
    }
%>
</div>
</body>
</html>
