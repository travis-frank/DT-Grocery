# DT-Grocery E-commerce Platform

## Overview

DT-Grocery is a web-based e-commerce system designed to support interactions between customers and administrators. The project is implemented using JavaServer Pages (JSP), ensuring modularity, scalability, and ease of maintenance. It provides features such as user authentication, product catalog management, shopping cart functionalities, and administrative control over products and transactions.

---

## Features

### User Features
- **Login and Authentication**
  - Users can log in via `login.jsp` with session management for secure access.
  - Logout functionality ensures session security (`logout.jsp`).

- **Product Browsing and Search**
  - Products are dynamically displayed using `listprod.jsp` with detailed information.
  - Search products by name or filter by category.

- **Product Reviews**
  - Add and view reviews for products via `product.jsp`.

- **Shopping Cart**
  - Add, view, update, and remove items from the cart (`addcart.jsp`, `showcart.jsp`).
  - Proceed to checkout with customer ID validation.

- **Order Management**
  - View past orders and track order history (`listorder.jsp`).

### Administrative Features
- **Product Management**
  - Add, update, and delete products using `admin.jsp`.

- **Order Tracking**
  - Monitor and track orders with a comprehensive list view (`listorder.jsp`).

- **Data Management**
  - Facilitate database interactions and maintenance using `jdbc.jsp` and `loaddata.jsp`.

### Additional Features
- **Dynamic Image Loading**
  - Images are fetched and displayed dynamically using `displayImage.jsp`.

- **Docker Integration**
  - Docker configuration files ensure consistent and scalable deployment.

- **Input Validation and Error Handling**
  - Robust mechanisms to ensure data integrity and system reliability.

---

## Installation

### Prerequisites
- Java JDK 8+
- Apache Tomcat 9+
- MySQL Database
- Docker (optional for containerized deployment)

### Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone https://github.com/DT-Grocery

2. **Import the project** into your favorite IDE (e.g., Eclipse, IntelliJ IDEA).

3. **Configure the database**:
   - Import the SQL schema from `resources/database/schema.sql`.
   - Update the database connection settings in `WEB-INF/web.xml`.

4. **Using Docker**:
   - Run the application using Docker Compose:
     ```bash
     docker-compose up -d
     ```
   - Open a browser and navigate to:
     ```
     http://localhost/shop/loaddata.jsp
     ```
     This will load the database with sample data.

5. **Log In**: Use one of the following default user credentials:

   | Username | Password |
   |----------|----------|
   | arnold   | test     |
   | bobby    | bobby    |
   | candace  | password |
   | darren   | pw       |
   | beth     | test     |

6. **Access the application**:
   - Open the browser and navigate to:
     ```
     http://localhost/shop
     ```
     
## Video Walkthroughs
[DT- Grocery Walkthough](https://youtu.be/EI9uJSDQM7E)
[Add/Delete/Update](https://youtu.be/UZ8ipyqt31M) 
