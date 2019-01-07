# KRS Project Proposal
## Problem Statement
Customer data is most of the time a large amount of data that isn't sorted or shown as a clear 
overview. In this case it is the data of a company that installs boilers and maintain them. The 
data consists of maintainance data, placement date and customer information.
I want to make an application that shows the all of that data in a clear overview.

## Solution
My idea in a single sentence is: "Create an app that creates a simple overview of customer data.".
The app starts with a login screen where the user, who can be an user or an administrator, logins to the app. 
//Picture of login screen
For the API part, all the data will be in an SQL database which can be requested and edited from within the app using PHP.


If the user is an administrator, it has the following features:
- Add new users
- Add new customers
- Edit customer information
- Add new maintainance data
- Add new placement data
- Search for customers
- Search for boiler data
- View all appointments in the agenda
- Add new appointments in the agenda

If the user is an user, it has the following features:
- Edit his/her information
- Add new maintenance data
- Add new placement data
- View his/her appointments in the agenda

Minimum viable product:
The login part is an optional part of the project, all the other features will be in the final application.

## Prerequisites
### Data sources
- Own SQL database with example data

### External Components
- MySQL

### Similar Apps
My application is made for companies that places boilers and is very specific in its target.
There are many apps that give a good customer overview, but none of them are specified for companies.
An app that gives a customer overview of a company is Microsoft Outlook Customer Manager. In this app the
user can see important information about customers.

### Hardest Parts
- Request and edit information in the SQL database using the app.
- Create a function that checks if the logged in user is an administrator or not, and disable 
  certain functions when he/she is not.
