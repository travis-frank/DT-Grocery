<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    
        /* Navbar background color */
        .navbar {
            background-color: #343a40;
            padding: 0 20px;
        }

        /* Navbar brand */
        .navbar-brand {
            color: #ff7f50 !important;
            font-weight: bold;
            font-size: 1.3rem;
            text-transform: uppercase;
            display: flex;
            align-items: center; 
            margin: 0;
            padding: 10px 0;
        }

        .navbar-brand:hover {
            color: #f8f9fa !important;
        }

        /* Navbar links */
        .navbar-nav .nav-link {
            color: white !important;
            font-size: 1.1rem;
            padding: 10px 15px; 
        }

        .navbar-nav .nav-link:hover {
            color: #ff7f50 !important;
        }

        /* User info styling */
        .navbar-text {
            color: #ff7f50 !important;
            font-size: 1.1rem;
            font-weight: bold;
            padding: 10px 15px;
            white-space: nowrap;
        }

        /* Remove extra spacing on smaller screens */
        .navbar-collapse {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* Navbar toggler icon for mobile */
        .navbar-toggler-icon {
            background-color: white;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <a class="navbar-brand" href="index.jsp">DT Grocery</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="listprod.jsp">Shop</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="listorder.jsp">Orders</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="customer.jsp">Customer Info</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="admin.jsp">Admin</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="showcart.jsp">View Cart</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Log Out</a>
                </li>
            </ul>
            <span class="navbar-text">
                <% 
                    String userName = (String) session.getAttribute("authenticatedUser");
                    if (userName != null) {
                        out.print("Signed in as: " + userName);
                    } else {
                        out.print("Not signed in");
                    }
                %>
            </span>
        </div>
    </nav>
</body>
</html>
