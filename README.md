
# The Reds Gaming Lounge Database Management System

A PostgreSQL-based database project designed to manage the daily operations of a PlayStation gaming lounge, including customer records, employee information, PlayStation units, bookings, and payment transactions.

# Project Overview

The Reds Gaming Lounge is a database management system developed to organize gaming lounge operations through a relational database.

The system focuses on managing online and offline bookings, multiple PlayStation unit reservations, rental costs, and payment records.

# Project Objectives

- Design a relational database for gaming lounge operations.
- Organize customer, employee, and PlayStation unit information.
- Manage online and offline booking transactions.
- Support multiple PlayStation units within a single booking.
- Calculate rental costs based on duration and hourly rates.
- Track down payments, settlements, and remaining balances.

# Database Structure

The database consists of six main tables:

| Table | Description |
| `customers` | Stores customer information. |
| `employees` | Stores employee information. |
| `ps_units` | Stores PlayStation unit information and availability status. |
| `bookings` | Records customer booking transactions. |
| `booking_details` | Stores unit reservations, rental duration, and hourly rates. |
| `payments` | Records payment transactions. |

# Business Rules

- Customers can make bookings through online or offline channels.
- Online bookings do not require employee assignment.
- Offline bookings must be handled by an employee.
- One booking can include multiple PlayStation units.
- Each unit in a booking can have a different rental duration.
- Rental costs are calculated based on rental duration and hourly rates.
- Payments support down payments (DP) and final settlements.
- The system tracks total payments and remaining booking balances.

# Tools & Technologies

- Database: PostgreSQL
- SQL Editor: DBeaver
- Language: SQL

# Project Structure

| Folder / File | Description |
| `01_project_documentation/` | Project documentation and testing explanations. |
| `02_database_design/` | Entity Relationship Diagram (ERD). |
| `03_sql_scripts/` | SQL scripts for database creation, data insertion, and queries. |
| `04_testing/` | Screenshots of SQL query testing results. |
| `README.md` | Project overview and documentation guide. |

# Testing

The database was tested using six SQL queries to verify:

1. Booking records and customer information.
2. Booking details and PlayStation unit information.
3. Total booking cost calculations.
4. Total payments and remaining balances.
5. Payment transaction history.
6. Payment status verification.

The testing results confirmed that the sample booking costs, payment records, and payment statuses were calculated as expected.

# Project Status

**Completed** Database design, SQL implementation, sample data insertion, and query testing have been completed.

