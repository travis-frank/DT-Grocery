<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
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

        

        .container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }

        h3 {
            color: black;
            font-size: 5rem;
            font-weight: 900; 
            margin-bottom: 20px;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .button {
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            color: black;
            background-color: #ff7f50;
            border: none;
            border-radius: 5px;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }

        .button:hover {
            background-color: white;
            text-decoration: none;
        }

        .button-container .signed-in {
            background-color: white; 
            border: 1px solid #ccc;
            border-radius: 5px; 
            padding: 10px 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            font-weight: bold; 
            color: black; 
            cursor: default; 
            pointer-events: none; 
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h3>Welcome to DT Grocery</h3>
        <div class="button-container">
            <a href="login.jsp" class="button">Login</a>
            <a href="listprod.jsp" class="button">Begin Shopping</a>
            <a href="listorder.jsp" class="button">List All Orders</a>
            <a href="customer.jsp" class="button">Customer Info</a>
            <a href="admin.jsp" class="button">Administrators</a>
            <a href="logout.jsp" class="button">Log out</a>

            <% String userName = (String) session.getAttribute("authenticatedUser"); if (userName != null) { %>
                <button class="button signed-in">
                    Signed in as: <%= userName %>
                </button>
            <% } %>
        </div>
    </div>
</body>
</html>
