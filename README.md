# **Postfix & Dovecot Mail Server (Dockerized)**

This project provides a robust, containerized solution for running a complete mail system using Postfix (MTA) and Dovecot (IMAP/POP3). The system utilizes two separate Docker containers for enhanced modularity and security, communicating via a mapped Unix socket file.

## **Features**

* **MTA:** Postfix for sending and receiving mail.  
* **MDA/Delivery:** Dovecot for IMAP/POP3 access.  
* **Inter-Container Communication:** Uses a mapped Unix socket for secure and efficient communication between Postfix and Dovecot.  
* **Virtual User/Domain Management:** **Currently only supports MySQL for backend data storage.**

## **Prerequisites**

Before starting the containers, you need to ensure your MySQL database is ready and initialized.

1. **SQL Initialization:** The necessary tables and views for user, domain, and alias management are defined in the SQL files located under the sql directory. Please apply these scripts to your MySQL database instance.

## **Quick Start**

The project includes sample configuration files to get you up and running quickly.

1. **Environment Setup:** Rename the sample environment file and modify its values.  
   cp sample.app.env app.env  
   \# Edit app.env with your specific settings

2. **Docker Compose Setup:** Rename the Docker Compose configuration file.  
   cp sample.docker-compose.yml docker-compose.yml

3. **Launch the System:** Start the containers in detached mode.  
   docker compose up \-d

## **Configuration (app.env)**

The app.env file contains critical environment variables required for both containers to connect to the database and handle TLS settings.

| Variable | Description | Sample Value |
| :---- | :---- | :---- |
| TLS\_CERY\_FILE | Absolute path inside the container to the TLS certificate file (e.g., for Postfix/Dovecot). | /ssl/sample.cer |
| TLS\_KEY\_FILE | Absolute path inside the container to the TLS private key file. | /ssl/sample.key |
| MAIL\_DOMAIN | The primary mail domain to be configured for the mail server. | sample.com |
| DB\_USER | MySQL username used to connect to the mail database. | mysql |
| DB\_PASSWORD | Password for the MySQL user. | mysql |
| DB\_PORT | Port number of the MySQL server. | 3306 |
| DB\_HOST | Hostname or IP address of the MySQL server. | mysql |
| DB\_DBNAME | Name of the mail database containing user and domain data. | mail |

