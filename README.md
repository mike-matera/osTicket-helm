# A Helm Chart for osTicket 

To install this Helm chart run the command:

```console 
$ helm install my-osticket chart/ 
```

## Configuration Options 

The following keys configure the installation parameters of osTicket:

| Key | Use | Default | 
| --- | --- | ---  | 
| `ostName` | The name of this osTicket installation | "osTicket Helm Chart" | 
| `ostEmail` | The email address for osTicket | "help@help.help" | 
| `adminFirstName` | Admin's first name | "Helper" | 
| `adminLastName` | Admin's last name | "Person" | 
| `adminEmail` | Admin's email address | "admin@help.help" | 
| `adminUsername` | Admin's username | "admin" | 
| `adminPassword` | Admin's password | "admin12345" | 
| `timezone` | | "America/Los_Angeles" | 

You should provide your own secure credentials for MySQL using the following keys:

| Key | Use | Default | 
| --- | --- | --- | 
| `mysql.auth.database` | The name of the schema for osTicket | "osticket" | 
| `mysql.auth.username` | The osTicket database user | "ostuser" | 
| `mysql.auth.password` | The osTicket database user's password | "ostpasswd" | 
| `mysql.auth.rootPassword` | MySQL root password | "ostroot" | 
