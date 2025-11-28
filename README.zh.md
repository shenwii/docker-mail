# **Postfix & Dovecot 容器化邮件服务器**

本项目提供了一个健壮的、容器化的完整邮件系统解决方案，使用了 Postfix (MTA) 和 Dovecot (IMAP/POP3)。系统通过两个独立的 Docker 容器运行，以增强模块化和安全性，并使用映射的 Unix Socket 文件进行通信。

## **功能特点**

* **邮件传输代理 (MTA):** Postfix 负责邮件的发送和接收。  
* **邮件投递代理 (MDA)/投递:** Dovecot 负责 IMAP/POP3 访问。  
* **容器间通信:** 通过映射的 Unix Socket 文件实现 Postfix 和 Dovecot 之间安全高效的通信。  
* **虚拟用户/域管理:** **目前仅支持使用 MySQL 作为后端数据存储。**

## **前期准备**

在启动容器之前，您需要确保您的 MySQL 数据库已经准备就绪并完成了初始化。

1. **SQL 初始化:** 用于管理用户、域和别名所需的表和视图定义，位于 sql 文件夹下的 SQL 文件中。请将这些脚本应用于您的 MySQL 数据库实例。

## **快速上手**

项目提供了一对示例配置文件，以便您快速启动。

1. **环境配置:** 复制示例环境文件并修改其中的值。  
   cp sample.app.env app.env  
   \# 编辑 app.env 以配置您的特定设置

2. **Docker Compose 配置:** 复制 Docker Compose 配置文件。  
   cp sample.docker-compose.yml docker-compose.yml

3. **启动系统:** 使用分离模式启动容器。  
   docker compose up \-d

## **配置说明 (app.env)**

app.env 文件包含了关键的环境变量，这些变量是容器连接数据库和处理 TLS 设置所必需的。

| 变量名 | 描述 | 示例值 |
| :---- | :---- | :---- |
| TLS\_CERY\_FILE | 容器内部到 TLS 证书文件的绝对路径（供 Postfix/Dovecot 使用）。 | /ssl/sample.cer |
| TLS\_KEY\_FILE | 容器内部到 TLS 私钥文件的绝对路径。 | /ssl/sample.key |
| MAIL\_DOMAIN | 邮件服务器配置的主邮件域。 | sample.com |
| DB\_USER | 连接邮件数据库所使用的 MySQL 用户名。 | mysql |
| DB\_PASSWORD | 对应 MySQL 用户的密码。 | mysql |
| DB\_PORT | MySQL 服务器的端口号。 | 3306 |
| DB\_HOST | MySQL 服务器的主机名或 IP 地址。 | mysql |
| DB\_DBNAME | 包含用户和域数据的邮件数据库名称。 | mail |

