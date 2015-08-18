If you are connecting to an MySQL database on Aptible, either through your app or when running `aptible db:tunnel $DB_HANDLE` and using the `mysql` commandline client, you may hit the folowing error:

      ERROR 1045 (28000): Access denied for user 'aptible'@'ip-[IP_ADDRESS].ec2.internal' (using password: YES)

On Aptible, MySQL servers are configured to require SSL for any TCP connection from the user `aptible`, but the client does not connect over SSL by default, resulting in an error. 

To address this, you can either pass in the user as `-u aptible-nossl` to connect without SSL or you can set the `ssl-cipher` parameter with with `DHE-RSA-AES256-SHA` or `AES128-SHA`

To verify your connection is running over SSL run

    mysql> show status like 'Ssl_cipher';
    +---------------+--------------------+
    | Variable_name | Value              |
    +---------------+--------------------+
    | Ssl_cipher    | DHE-RSA-AES256-SHA |
    +---------------+--------------------+

