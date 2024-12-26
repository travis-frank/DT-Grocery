<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 20px;
            font-family: Arial, sans-serif;
        }
        .product-details {
            margin-bottom: 30px;
        }
        .image-container {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-bottom: 20px;
        }
        .image-container img {
            max-width: 300px;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .button-row {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }
        .review-container {
            margin-top: 40px;
        }
        .review {
            border-bottom: 1px solid #ddd;
            padding: 15px 0;
        }
        .review p {
            margin: 5px 0;
        }
        .review .review-rating {
            font-weight: bold;
            color: #f39c12;
        }
        .review-form {
            margin-top: 30px;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
        }
        .btn-secondary {
           background-color: #808080;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <%
        // Fetch authenticated user and customerId
        String authenticatedUser = (String) session.getAttribute("authenticatedUser");
        Integer customerId = (Integer) session.getAttribute("customerId");

        // If customerId is not set, fetch it using the username
        if (customerId == null && authenticatedUser != null) {
            String fetchCustomerSql = "SELECT customerId FROM customer WHERE firstName = ?";
            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders"); 

                PreparedStatement pstmtFetchCustomer = con.prepareStatement(fetchCustomerSql);
                pstmtFetchCustomer.setString(1, authenticatedUser);
                ResultSet rsCustomer = pstmtFetchCustomer.executeQuery();
                if (rsCustomer.next()) {
                    customerId = rsCustomer.getInt("customerId");
                    session.setAttribute("customerId", customerId);
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error fetching customer ID: " + e.getMessage() + "</div>");
            } finally {
                closeConnection();
            }
        }

        String productId = request.getParameter("id");

        if (productId == null || productId.isEmpty()) {
            out.println("<div class='alert alert-warning'>Invalid Product ID.</div>");
        } else {
            String sql = "SELECT productId, productName, productPrice, productImageURL, productImage, productDesc FROM product WHERE productId = ?";
            String reviewSql = "SELECT r.reviewRating, r.reviewComment, c.firstName, c.lastName, r.reviewDate " +
                               "FROM review r " +
                               "JOIN customer c ON r.customerId = c.customerId " +
                               "WHERE r.productId = ? " +
                               "ORDER BY r.reviewDate DESC";

            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders"); 

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(productId));
                ResultSet rst = pstmt.executeQuery();

                if (!rst.next()) {
                    out.println("<div class='alert alert-warning'>Product not found.</div>");
                } else {
                    out.println("<div class='product-details'>");
                    out.println("<h2 class='text-center'>" + rst.getString("productName") + "</h2>");

                    int prodId = rst.getInt("productId");
                    double price = rst.getDouble("productPrice");
                    String imageLoc = rst.getString("productImageURL");
                    String imageBinary = rst.getString("productImage");
                    String productDesc = rst.getString("productDesc");

                    out.println("<div class='text-center'><strong>Price: </strong>" + currFormat.format(price) + "</div>");
                    out.println("<div class='text-center'><strong>Description: </strong>" + productDesc + "</div>");
                    out.println("<div class='image-container'>");
                    if (imageLoc != null && !imageLoc.isEmpty()) {
                        out.println("<img src=\"" + imageLoc + "\" alt='Product Image'>");
                    }
                    if (imageBinary != null && !imageBinary.isEmpty()) {
                        out.println("<img src=\"displayImage.jsp?id=" + prodId + "\" alt='Product Image'>");
                    }
                    out.println("</div>");

                    
                    out.println("<div class='text-center'>");
                    out.println("<div class='button-row'>");
                    out.println("<a href=\"addcart.jsp?id=" + prodId + "&name=" + rst.getString("productName") 
                                + "&price=" + price + "\" class='btn btn-primary'>Add to Cart</a>");
                    out.println("<a href=\"listprod.jsp\" class='btn btn-secondary'>Continue Shopping</a>");
                    out.println("</div>");
                    out.println("</div>");

                    
                    String reviewRatingStr = request.getParameter("reviewRating");
                    String reviewComment = request.getParameter("reviewComment");

                    if (reviewRatingStr != null && reviewComment != null) {
                        if (customerId == null) {
                            out.println("<div class='alert alert-danger'>You need to log in to submit a review.</div>");
                        } else {
                            try {
                                int reviewRating = Integer.parseInt(reviewRatingStr);
                                String insertReviewSql = "INSERT INTO review (reviewRating, reviewComment, reviewDate, customerId, productId) VALUES (?, ?, GETDATE(), ?, ?)";
                                PreparedStatement pstmtInsertReview = con.prepareStatement(insertReviewSql);
                                pstmtInsertReview.setInt(1, reviewRating);
                                pstmtInsertReview.setString(2, reviewComment);
                                pstmtInsertReview.setInt(3, customerId);
                                pstmtInsertReview.setInt(4, Integer.parseInt(productId));
                                pstmtInsertReview.executeUpdate();

                                out.println("<div class='alert alert-success'>Review submitted successfully!</div>");
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error submitting review: " + e.getMessage() + "</div>");
                            }
                        }
                    }

                    
                    PreparedStatement pstmtReviews = con.prepareStatement(reviewSql);
                    pstmtReviews.setInt(1, Integer.parseInt(productId));
                    ResultSet rsReviews = pstmtReviews.executeQuery();

                    out.println("<div class='review-container'>");
                    out.println("<h3>Customer Reviews</h3>");
                    boolean reviewsFound = false;
                    while (rsReviews.next()) {
                        reviewsFound = true;
                        String customerName = rsReviews.getString("firstName") + " " + rsReviews.getString("lastName");
                        int rating = rsReviews.getInt("reviewRating");
                        String comment = rsReviews.getString("reviewComment");
                        Date reviewDate = rsReviews.getDate("reviewDate");

                        out.println("<div class='review'>");
                        out.println("<p><span class='review-rating'>Rating: " + rating + "/5</span></p>");
                        out.println("<p><strong>" + customerName + "</strong> (" + reviewDate + ")</p>");
                        out.println("<p>" + comment + "</p>");
                        out.println("</div>");
                    }
                    if (!reviewsFound) {
                        out.println("<p>No reviews yet. Be the first to review this product!</p>");
                    }
                    out.println("</div>");

                  
                    out.println("<div class='review-form'>");
                    out.println("<h3>Write a Review</h3>");
                    out.println("<form method='post' action='product.jsp?id=" + productId + "'>");
                    out.println("<div class='form-group'>");
                    out.println("<label for='reviewRating'>Rating (1-5):</label>");
                    out.println("<input type='number' class='form-control' id='reviewRating' name='reviewRating' min='1' max='5' required>");
                    out.println("</div>");
                    out.println("<div class='form-group'>");
                    out.println("<label for='reviewComment'>Comment:</label>");
                    out.println("<textarea class='form-control' id='reviewComment' name='reviewComment' rows='3' required></textarea>");
                    out.println("</div>");
                    out.println("<button type='submit' class='btn btn-primary'>Submit Review</button>");
                    out.println("</form>");
                    out.println("</div>");
                }
            } catch (SQLException ex) {
                out.println("<div class='alert alert-danger'>Error fetching product details: " + ex.getMessage() + "</div>");
            } catch (NumberFormatException ex) {
                out.println("<div class='alert alert-warning'>Invalid Product ID format.</div>");
            } finally {
                closeConnection();
            }
        }
    %>
</div>

</body>
</html>