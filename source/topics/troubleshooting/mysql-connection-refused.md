If you run `aptible db:tunnel $DB_HANDLE` and try connecting to the db with the `mysql` commandline client, you may see the folowing error:

      ERROR 1045 (28000): Access denied for user 'aptible'@'ip-[IP_ADDRESS].ec2.internal' (using password: YES)

On Aptible, MySQL servers are configured to require SSL for any TCP connection from the user `aptible`, but the client does not connect over ssl by default, resulting in an error.  

You can either pass in the user as `-u aptible-nossl` or you can set the `ssl-cipher` parameter with with `DHE-RSA-AES256-SHA` or `AES128-SHA`

To verify your connection is running over ssl run

    mysql> show status like 'Ssl_cipher';
    +---------------+--------------------+
    | Variable_name | Value              |
    +---------------+--------------------+
    | Ssl_cipher    | DHE-RSA-AES256-SHA |
    +---------------+--------------------+

  or 

    mysql> \s

    ...
    SSL: Not in use
    ...

  _(^ in case where `aptible-nossl` used)_



