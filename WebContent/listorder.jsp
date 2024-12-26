<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <%@ include file="header.jsp" %>
    <title>Orders</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }

        h1 {
            text-align: center;
            color: #343a40;
            margin-top: 20px;
        }

        table {
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .table th {
            background-color: #007bff;
            color: white;
        }

        .table-hover tbody tr:hover {
            background-color: #f1f1f1;
        }

        .button-container {
            text-align: center;
            margin: 20px 0;
        }

        .btn {
            font-size: 16px;
        }

        .nested-table th {
            background-color: #6c757d;
            color: white;
        }

        .nested-table {
            margin-top: 10px;
            background-color: #fff;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Order List</h1>
    <%
    String sql = "SELECT orderId, O.CustomerId, totalAmount, firstName+' '+lastName, orderDate FROM OrderSummary O, Customer C WHERE "
            + "O.customerId = C.customerId";

    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

    try {
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders");

        ResultSet rst = stmt.executeQuery(sql);
    %>
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>Order Id</th>
                <th>Order Date</th>
                <th>Customer Id</th>
                <th>Customer Name</th>
                <th>Total Amount</th>
            </tr>
        </thead>
        <tbody>
        <%
            String productSql = "SELECT productId, quantity, price FROM OrderProduct WHERE orderId=?";
            PreparedStatement pstmt = con.prepareStatement(productSql);

            while (rst.next()) {
                int orderId = rst.getInt(1);
        %>
            <tr>
                <td><%= orderId %></td>
                <td><%= rst.getString(5) %></td>
                <td><%= rst.getInt(2) %></td>
                <td><%= rst.getString(4) %></td>
                <td><%= currFormat.format(rst.getDouble(3)) %></td>
            </tr>
            <tr>
                <td colspan="5">
                    <table class="table table-sm table-bordered nested-table">
                        <thead>
                            <tr>
                                <th>Product Id</th>
                                <th>Quantity</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            pstmt.setInt(1, orderId);
                            ResultSet rst2 = pstmt.executeQuery();
                            while (rst2.next()) {
                        %>
                            <tr>
                                <td><%= rst2.getInt(1) %></td>
                                <td><%= rst2.getInt(2) %></td>
                                <td><%= currFormat.format(rst2.getDouble(3)) %></td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
    } catch (SQLException ex) {
        out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
    } finally {
        closeConnection();
    }
    %>
    <div class="button-container">
        <a href="index.jsp" class="btn btn-primary">Return to Home</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>