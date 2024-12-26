<%@ page import="java.util.HashMap" %> 
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>DT Grocery</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script>
        function filterByCategory() {
            document.getElementById("categoryForm").submit();
        }
    </script>
</head>
<body>

<%@ include file="header.jsp" %>




<h2>Browse Products By Category and Search by Product Name:</h2>
<%
    // Retrieve parameters from the request
    String category = request.getParameter("categoryName");
    String name = request.getParameter("productName");

    if (category == null) {
        category = ""; // Default value
    }
    if (name == null) {
        name = ""; // Default value
    }
%>

<form id="categoryForm" name="categoryForm" method="get" action="listprod.jsp">
    <p>
        <select name="categoryName" id="categoryName" onchange="filterByCategory()">
            <option value="Beverages" <%= "Beverages".equals(category) ? "selected" : "" %>>Beverages</option>
            <option value="Condiments" <%= "Condiments".equals(category) ? "selected" : "" %>>Condiments</option>
            <option value="Confections" <%= "Confections".equals(category) ? "selected" : "" %>>Confections</option>
            <option value="Dairy Products" <%= "Dairy Products".equals(category) ? "selected" : "" %>>Dairy Products</option>
            <option value="Grains/Cereals" <%= "Grains/Cereals".equals(category) ? "selected" : "" %>>Grains/Cereals</option>
            <option value="Meat/Poultry" <%= "Meat/Poultry".equals(category) ? "selected" : "" %>>Meat/Poultry</option>
            <option value="Produce" <%= "Produce".equals(category) ? "selected" : "" %>>Produce</option>
            <option value="Seafood" <%= "Seafood".equals(category) ? "selected" : "" %>>Seafood</option>
        </select>
        <input type="text" name="productName" size="50" value="<%= name %>">
        <input type="submit" value="Submit">
        <input type="reset" value="Reset">
    </p>
</form>

<%
    // Colors for different item categories
    HashMap<String, String> colors = new HashMap<>();
    colors.put("Beverages", "#0000FF");
    colors.put("Condiments", "#FF0000");
    colors.put("Confections", "#000000");
    colors.put("Dairy Products", "#6600CC");
    colors.put("Grains/Cereals", "#55A5B3");
    colors.put("Meat/Poultry", "#FF9900");
    colors.put("Produce", "#00CC00");
    colors.put("Seafood", "#FF66CC");

    // SQL query setup
    boolean hasNameParam = name != null && !name.isEmpty();
    boolean hasCategoryParam = category != null && !category.isEmpty() && !category.equals("All");
    String filter = "", sql = "";

    if (hasNameParam && hasCategoryParam) {
        filter = "<h3>Products containing '" + name + "' in category: '" + category + "'</h3>";
        name = '%' + name + '%';
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ? AND categoryName = ?";
    } else if (hasNameParam) {
        filter = "<h3>Products containing '" + name + "'</h3>";
        name = '%' + name + '%';
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ?";
    } else if (hasCategoryParam) {
        filter = "<h3>Products in category: '" + category + "'</h3>";
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE categoryName = ?";
    } else {
        filter = "<h3>All Products</h3>";
        sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId";
    }

    out.println(filter);

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders");

        PreparedStatement pstmt = con.prepareStatement(sql);
        if (hasNameParam) {
            pstmt.setString(1, name);
            if (hasCategoryParam) {
                pstmt.setString(2, category);
            }
        } else if (hasCategoryParam) {
            pstmt.setString(1, category);
        }

        ResultSet rst = pstmt.executeQuery();

        out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th></th><th>Product Name</th>");
        out.println("<th>Category</th><th>Price</th><th>Actions</th></tr>");

        while (rst.next()) {
            int id = rst.getInt(1);
            String productName = rst.getString(2);
            double productPrice = rst.getDouble(3);
            String itemCategory = rst.getString(4);
            String color = colors.getOrDefault(itemCategory, "#FFFFFF");

            out.println("<tr>");
            // Add "Add to Cart" button
            out.print("<td><a href=\"addcart.jsp?id=" + id + "&name=" + productName
                    + "&price=" + productPrice + "\" class=\"btn btn-primary\">Add to Cart</a></td>");

            // Product Name with hyperlink
            out.println("<td><a href=\"product.jsp?id=" + id + "\"><font color=\"" + color + "\">" + productName + "</font></a></td>");

            // Category Name
            out.println("<td><font color=\"" + color + "\">" + itemCategory + "</font></td>");

            // Price
            out.println("<td><font color=\"" + color + "\">" + currFormat.format(productPrice) + "</font></td>");

            // View Cart Button
            out.println("<td><a href=\"showcart.jsp\" class=\"btn btn-success\">View Cart</a></td>");
            out.println("</tr>");
        }
        out.println("</table></font>");
        closeConnection();
    } catch (SQLException ex) {
        out.println(ex);
    }
%>

</body>
</html>