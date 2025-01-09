<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('./img/grocery.jpeg');
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
        }

        .custom-container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            padding: 40px;
            text-align: center;
        }

        h3 {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 30px;
            color: #333;
        }

        .btn-custom {
            font-size: 1.2rem;
            font-weight: 600;
            padding: 10px 25px;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .btn-custom:hover {
            background-color: #fff;
            color: #333;
            border: 1px solid #ff7f50;
        }

        .signed-in {
            background-color: #f8f9fa;
            border: 1px solid #ced4da;
            font-weight: bold;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="d-flex justify-content-center align-items-center vh-100">
        <div class="custom-container w-50">
            <h3>Welcome to DT Grocery</h3>
            <div class="d-grid gap-3">
                <a href="login.jsp" class="btn btn-custom btn-primary">Login</a>
                <a href="listprod.jsp" class="btn btn-custom btn-success">Begin Shopping</a>
                <a href="listorder.jsp" class="btn btn-custom btn-info">List All Orders</a>
                <a href="customer.jsp" class="btn btn-custom btn-warning">Customer Info</a>
                <a href="admin.jsp" class="btn btn-custom btn-danger">Administrators</a>
                <a href="logout.jsp" class="btn btn-custom btn-secondary">Log out</a>

                <% String userName = (String) session.getAttribute("authenticatedUser"); if (userName != null) { %>
                    <button class="btn btn-custom signed-in">
                        Signed in as: <%= userName %>
                    </button>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
