<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat, java.sql.*, java.util.*" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Panel</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <%@ include file="header.jsp" %>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0; 
            padding: 0;
        }

        h2, h3 {
            text-align: center;
            color: #343a40;
            margin-bottom: 20px;
        }

        .form-container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .table-container {
            margin-top: 30px;
        }

        .btn-custom {
            background-color: #007bff;
            color: #fff;
        }

        .btn-custom:hover {
            background-color: #0056b3;
            color: #fff;
        }

    

        .sales-table, .customer-table {
            width: 100%;
            margin-top: 20px;
            text-align: left;
            border-collapse: collapse;
        }

        .sales-table th, .sales-table td, .customer-table th, .customer-table td {
            border: 1px solid #ddd;
            padding: 8px;
        }

        .sales-table th, .customer-table th {
            background-color: #007bff;
            color: white;
            text-align: center;
        }

        .sales-table tbody tr:nth-child(even), .customer-table tbody tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .sales-table tbody tr:hover, .customer-table tbody tr:hover {
            background-color: #ddd;
        }

    </style>
</head>
<body>

<%
    String message = "";
    String messageClass = "";
%>

<div class="container">
    <h2><b>Welcome, <%= userName %>!</b></h2

    <% if (!message.isEmpty()) { %>
        <div class="alert <%= messageClass %>" role="alert">
            <%= message %>
        </div>
    <% } %>

    <!-- Add New Product -->
    <div class="form-container">
        <h3>Add New Product</h3>
        <form method="post" action="admin.jsp">
            <div class="mb-3">
                <label for="productName" class="form-label">Product Name:</label>
                <input type="text" id="productName" name="productName" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="category" class="form-label">Category:</label>
                <select id="category" name="category" class="form-select" required>
                    <option value="" disabled selected>Select a category</option>
                    <%
                        String categorySql = "SELECT categoryId, categoryName FROM category";
                        try {
                            getConnection();
                            Statement stmt = con.createStatement();
                            stmt.execute("USE orders");
                            ResultSet rs = stmt.executeQuery(categorySql);
                            while (rs.next()) {
                                out.println("<option value='" + rs.getInt("categoryId") + "'>" + rs.getString("categoryName") + "</option>");
                            }
                        } catch (Exception e) {
                            out.println("<option disabled>Error fetching categories</option>");
                        } finally {
                            closeConnection();
                        }
                    %>
                </select>
            </div>
            <div class="mb-3">
                <label for="price" class="form-label">Price:</label>
                <input type="number" step="0.01" id="price" name="price" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="description" class="form-label">Product Description:</label>
                <textarea id="description" name="description" class="form-control" required></textarea>
            </div>
            <div class="mb-3">
                <label for="quantity" class="form-label">Quantity:</label>
                <input type="number" id="quantity" name="quantity" class="form-control" required>
            </div>
            <button type="submit" name="action" value="Add Item" class="btn btn-custom">Add Product</button>
        </form>
    </div>

    <!-- Update or Delete Product -->
    <div class="form-container">
        <h3>Update or Delete a Product</h3>
        <form method="post" action="admin.jsp">
            <div class="mb-3">
                <label for="productSelect" class="form-label">Select Product:</label>
                <select id="productSelect" name="productSelect" class="form-select" required>
                    <option value="" disabled selected>Select a product</option>
                    <%
                        String productSql = "SELECT productId, productName FROM product";
                        try {
                            getConnection();
                            Statement stmt = con.createStatement();
                            stmt.execute("USE orders");
                            ResultSet rs = stmt.executeQuery(productSql);
                            while (rs.next()) {
                                out.println("<option value='" + rs.getInt("productId") + "'>" + rs.getString("productName") + "</option>");
                            }
                        } catch (Exception e) {
                            out.println("<option disabled>Error fetching products</option>");
                        } finally {
                            closeConnection();
                        }
                    %>
                </select>
            </div>
            <div class="mb-3">
                <label for="updatePrice" class="form-label">New Price (optional):</label>
                <input type="number" step="0.01" id="updatePrice" name="updatePrice" class="form-control">
            </div>
            <div class="mb-3">
                <label for="updateQuantity" class="form-label">New Quantity (optional):</label>
                <input type="number" id="updateQuantity" name="updateQuantity" class="form-control">
            </div>
            <div class="mb-3">
                <label for="updateDescription" class="form-label">New Description (optional):</label>
                <textarea id="updateDescription" name="updateDescription" class="form-control"></textarea>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" name="action" value="Update Item" class="btn btn-warning">Update Product</button>
                <button type="submit" name="action" value="Delete Item" class="btn btn-danger">Delete Product</button>
            </div>
        </form>
    </div>

    <%
        String action = request.getParameter("action");
        String productName = request.getParameter("productName");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        String quantityStr = request.getParameter("quantity");
        String productSelect = request.getParameter("productSelect");
        String updatePriceStr = request.getParameter("updatePrice");
        String updateQuantityStr = request.getParameter("updateQuantity");
        String updateDescription = request.getParameter("updateDescription");

        // Add Product Logic
        if ("Add Item".equals(action) && productName != null && category != null && priceStr != null && description != null && quantityStr != null) {
            try {
                double price = Double.parseDouble(priceStr);
                int quantity = Integer.parseInt(quantityStr);

                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");

                String insertProductSql = "INSERT INTO product (productName, categoryId, productPrice, productDesc) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmtProduct = con.prepareStatement(insertProductSql, Statement.RETURN_GENERATED_KEYS);
                pstmtProduct.setString(1, productName);
                pstmtProduct.setInt(2, Integer.parseInt(category));
                pstmtProduct.setDouble(3, price);
                pstmtProduct.setString(4, description);
                pstmtProduct.executeUpdate();

                ResultSet generatedKeys = pstmtProduct.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int productId = generatedKeys.getInt(1);

                    String insertInventorySql = "INSERT INTO productinventory (productId, warehouseId, quantity, price) VALUES (?, ?, ?, ?)";
                    PreparedStatement pstmtInventory = con.prepareStatement(insertInventorySql);
                    pstmtInventory.setInt(1, productId);
                    pstmtInventory.setInt(2, 1);
                    pstmtInventory.setInt(3, quantity);
                    pstmtInventory.setDouble(4, price);
                    pstmtInventory.executeUpdate();

                    message = "Product added successfully!";
                    messageClass = "alert alert-success";
                } else {
                    message = "Error: Could not retrieve product ID.";
                    messageClass = "alert alert-danger";
                }
            } catch (Exception e) {
                message = "Error adding product: " + e.getMessage();
                messageClass = "alert alert-danger";
            } finally {
                closeConnection();
            }
        }

      // Update Product Logic (
    if ("Update Item".equals(action) && productSelect != null) {
    try {
        getConnection();
        
        // Declare and initialize `Statement`
        Statement stmt = con.createStatement();
        stmt.execute("USE orders");

        // Prepare SQL statements
        boolean hasProductUpdates = false;
        StringBuilder productUpdateSql = new StringBuilder("UPDATE product SET ");
        List<Object> productParams = new ArrayList<>();

        if (updatePriceStr != null && !updatePriceStr.isEmpty()) {
            productUpdateSql.append("productPrice = ?, ");
            productParams.add(Double.parseDouble(updatePriceStr));
            hasProductUpdates = true;
        }
        if (updateDescription != null && !updateDescription.isEmpty()) {
            productUpdateSql.append("productDesc = ?, ");
            productParams.add(updateDescription);
            hasProductUpdates = true;
        }

        // Finalize `product` update
        if (hasProductUpdates) {
            productUpdateSql.setLength(productUpdateSql.length() - 2); // Remove trailing comma
            productUpdateSql.append(" WHERE productId = ?");
            productParams.add(Integer.parseInt(productSelect));

            PreparedStatement pstmtProduct = con.prepareStatement(productUpdateSql.toString());
            for (int i = 0; i < productParams.size(); i++) {
                pstmtProduct.setObject(i + 1, productParams.get(i));
            }
            pstmtProduct.executeUpdate();
        }

        // Update `productinventory` table for quantity
        if (updateQuantityStr != null && !updateQuantityStr.isEmpty()) {
            String inventoryUpdateSql = "UPDATE productinventory SET quantity = ? WHERE productId = ?";
            PreparedStatement pstmtInventory = con.prepareStatement(inventoryUpdateSql);
            pstmtInventory.setInt(1, Integer.parseInt(updateQuantityStr));
            pstmtInventory.setInt(2, Integer.parseInt(productSelect));
            pstmtInventory.executeUpdate();
        }

        if (!hasProductUpdates && (updateQuantityStr == null || updateQuantityStr.isEmpty())) {
            message = "No fields provided for update.";
            messageClass = "alert alert-warning";
        } else {
            message = "Product updated successfully!";
            messageClass = "alert alert-success";
        }
    } catch (Exception e) {
        message = "Error updating product: " + e.getMessage();
        messageClass = "alert alert-danger";
    } finally {
        closeConnection();
    }
}

        if ("Delete Item".equals(action) && productSelect != null) {
            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");

                PreparedStatement pstmtOrderProduct = con.prepareStatement("DELETE FROM orderproduct WHERE productId = ?");
                pstmtOrderProduct.setInt(1, Integer.parseInt(productSelect));
                pstmtOrderProduct.executeUpdate();

                PreparedStatement pstmtInventory = con.prepareStatement("DELETE FROM productinventory WHERE productId = ?");
                pstmtInventory.setInt(1, Integer.parseInt(productSelect));
                pstmtInventory.executeUpdate();

                PreparedStatement pstmtProduct = con.prepareStatement("DELETE FROM product WHERE productId = ?");
                pstmtProduct.setInt(1, Integer.parseInt(productSelect));
                pstmtProduct.executeUpdate();

                message = "Product deleted successfully!";
                messageClass = "alert alert-success";
            } catch (Exception e) {
                message = "Error deleting product: " + e.getMessage();
                messageClass = "alert alert-danger";
            } finally {
                closeConnection();
            }
        }
    %>

 <!-- Total Sales Report -->
    <div class="form-container">
    <div class="sales-report-container">
        <h3>Total Sales by Day</h3>
        <%
            String sql = "SELECT YEAR(orderDate) AS Year, MONTH(orderDate) AS Month, DAY(orderDate) AS Day, SUM(totalAmount) AS Total "
                       + "FROM OrderSummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate) ORDER BY Year, Month, Day";
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");
                ResultSet rs = stmt.executeQuery(sql);

                out.println("<table class='sales-table'>");
                out.println("<thead><tr><th>Date</th><th>Total Sales</th></tr></thead>");
                out.println("<tbody>");
                while (rs.next()) {
                    String date = rs.getInt("Year") + "-" + rs.getInt("Month") + "-" + rs.getInt("Day");
                    double total = rs.getDouble("Total");
                    out.println("<tr><td>" + date + "</td><td>" + currFormat.format(total) + "</td></tr>");
                }
                out.println("</tbody></table>");
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error fetching sales report: " + e.getMessage() + "</div>");
            } finally {
                closeConnection();
            }
        %>
    </div>
    </div>

    <!-- Customer List -->
    <div class="form-container">
        <h3>All Customers</h3>
        <%
            String customerSql = "SELECT customerId, firstName, lastName, email, phonenum FROM customer ORDER BY lastName, firstName";
            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");
                ResultSet rs = stmt.executeQuery(customerSql);

                out.println("<table class='customer-table'>");
                out.println("<thead><tr><th>Customer ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th></tr></thead>");
                out.println("<tbody>");
                while (rs.next()) {
                    int customerId = rs.getInt("customerId");
                    String firstName = rs.getString("firstName");
                    String lastName = rs.getString("lastName");
                    String email = rs.getString("email");
                    String phone = rs.getString("phonenum");

                    out.println("<tr>");
                    out.println("<td>" + customerId + "</td>");
                    out.println("<td>" + firstName + "</td>");
                    out.println("<td>" + lastName + "</td>");
                    out.println("<td>" + email + "</td>");
                    out.println("<td>" + phone + "</td>");
                    out.println("</tr>");
                }
                out.println("</tbody></table>");
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error fetching customer list: " + e.getMessage() + "</div>");
            } finally {
                closeConnection();
            }
        %>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>