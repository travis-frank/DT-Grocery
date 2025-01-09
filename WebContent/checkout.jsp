<!DOCTYPE html>
<html>
<head>
    <title>CheckOut Line</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .checkout-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 100%;
            max-width: 400px;
        }

        h1 {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        input[type="text"] {
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 100%;
        }

        input[type="submit"], input[type="reset"] {
            padding: 10px;
            font-size: 1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        input[type="reset"] {
            background-color: #6c757d;
            color: white;
        }

        input[type="reset"]:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>
    <div class="checkout-container">
        <h1>Enter your customer id to complete the transaction:</h1>

        <form method="get" action="order.jsp">
            <input type="text" name="customerId" placeholder="Customer ID">
            <div>
                <input type="submit" value="Submit">
                <input type="reset" value="Reset">
            </div>
        </form>
    </div>
</body>
</html>