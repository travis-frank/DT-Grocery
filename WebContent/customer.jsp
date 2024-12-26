<!DOCTYPE html>
<html>
<head>
<link href="css/bootstrap.min.css" rel="stylesheet">
    <%@ include file="header.jsp" %>
<style>
    /* General Page Styling */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 0;
        color: #333;
    }

    h3 {
        color: #4CAF50;
        text-align: center;
        margin-top: 20px;
    }

    /* Styling for the Customer Profile Table */
    table {
        width: 80%;
        margin: 30px auto;
        border-collapse: collapse;
        background-color: #fff;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }

    th, td {
        padding: 12px 20px;
        text-align: left;
        border: 1px solid #ddd;
    }

    th {
        background-color: #4CAF50;
        color: white;
        font-size: 16px;
    }

    td {
        font-size: 14px;
    }

    /* Add Hover Effect for Rows */
    tr:hover {
        background-color: #f2f2f2;
    }

    /* Button Styling (For future use if needed) */
    .btn {
        display: inline-block;
        padding: 10px 15px;
        font-size: 16px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        text-align: center;
        text-decoration: none;
        margin-top: 20px;
    }

    .btn:hover {
        background-color: #45a049;
    }

    /* Centering the content */
    .container {
        width: 90%;
        margin: 0 auto;
        padding: 20px;
    }
</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<div class="container">
    

    <%
        // Print Customer information
        String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM Customer WHERE userid = ?";

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        try {
            out.println("<h3>Customer Profile</h3>");
            
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userName);    
            ResultSet rst = pstmt.executeQuery();

            if (rst.next()) {
                out.println("<table class=\"table\">");
                out.println("<tr><th>Id</th><td>" + rst.getString(1) + "</td></tr>");    
                out.println("<tr><th>First Name</th><td>" + rst.getString(2) + "</td></tr>");
                out.println("<tr><th>Last Name</th><td>" + rst.getString(3) + "</td></tr>");
                out.println("<tr><th>Email</th><td>" + rst.getString(4) + "</td></tr>");
                out.println("<tr><th>Phone</th><td>" + rst.getString(5) + "</td></tr>");
                out.println("<tr><th>Address</th><td>" + rst.getString(6) + "</td></tr>");
                out.println("<tr><th>City</th><td>" + rst.getString(7) + "</td></tr>");
                out.println("<tr><th>State</th><td>" + rst.getString(8) + "</td></tr>");
                out.println("<tr><th>Postal Code</th><td>" + rst.getString(9) + "</td></tr>");
                out.println("<tr><th>Country</th><td>" + rst.getString(10) + "</td></tr>");
                out.println("<tr><th>User id</th><td>" + rst.getString(11) + "</td></tr>");        
                out.println("</table>");
            }
        }
        catch (SQLException ex) {  
            out.println(ex); 
        }
        finally {    
            closeConnection();    
        }
    %>
</div>

</body>
</html>