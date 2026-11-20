# The Reds Gaming Lounge Database Management System

## Project Overview

A database management system designed for The Reds Gaming Lounge, a PlayStation gaming lounge. This project focuses on managing customer information, employees, PlayStation units, bookings, and payment transactions using PostgreSQL.

## Objectives

- Design a relational database for gaming lounge operations.
- Manage online and offline booking transactions.
- Support bookings involving multiple PlayStation units.
- Record down payments and settlement payments.
- Calculate booking costs and remaining balances.

## Database Structure

The database consists of six main tables:

1. `customers`
2. `employees`
3. `ps_units`
4. `bookings`
5. `booking_details`
6. `payments`

## Business Rules

- Customers can make online or offline bookings.
- One booking can include multiple PlayStation units.
- Each unit can have a different rental duration.
- Payments support down payment (DP) and settlement.
- Bookings cannot be cancelled.
- Online bookings do not require employee assignment.

## Tools & Technologies

- PostgreSQL
- DBeaver
- SQL

## Project Documentation

- Database Design: `02_database_design/`
- SQL Scripts: `03_sql_scripts/`
- Testing: `04_testing/`
- Project Documentation: `01_project_documentation/`
- Portfolio Materials: `05_portofolio/`

## Testing

Six SQL tests were conducted, covering table relationships, booking cost calculations, payment history, remaining balances, and payment status verification.

## Project Status

Database design, SQL implementation, and initial testing completed.
