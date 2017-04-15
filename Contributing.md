## Jasper's Helper Classes

`import jasper.helper.*;`

contains

### JasperDb 
for easy DB Query Handling

### JasperConnection 
resembles `Connection` in `java.sql.*`, used in `JasperDb`

### JasperStatement 
resembles `Statement` in `java.sql.*`, used in `JasperDb`

### ConnectionResult 
returned by `JasperConnection.start()`
helps to check for a connection error
* `isConnError()`
* `isJDBCError()`

### QueryResult 
returned by `JasperStatement.executeQuery()` 
helps to check for a query error
* `isError()`

contains the actual result 
* `getResult()`

### JasperCookie
helper Class for handling Cookies

## Executing a Query

```java

JasperConnection conn = new JasperCommunication("database","username","password");
ConnectionResult cr = jp.start();
if(!cr.isError())
{
    JasperStatement stmt = new JasperStatement(conn);
    QueryResult qr = stmt.executeQuery("SELECT * FROM TABLE");
    if(!qr.isError())
    {
        ResultSet rs = qr.getResult();
        while(rs.next())
        {
            // do Something
        }
        rs.close();
    }
    stmt.close();
}
conn.close();

```

#### Better Way

```java

JasperDb db = new JasperDb("database","username","password");
QueryResult qr = db.executeQuery("SELECT * FROM TABLE");
if(!qr.isError())
{
    ResultSet rs = qr.getResult();
    while(rs.next())
    {
        // do Something
    }
    rs.close();
}
db.close();

```

This saves us from writing the big old code

```java

Connection conn = null;
Statement stmt = null;
try{
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost/database","username","password");
    stmt = conn.createStatement();
    String sql = "SELECT id, first, last, age FROM Registration";
    ResultSet rs = stmt.executeQuery(sql);
    while(rs.next())
    {
        // Do Something
    }
    rs.close();
}catch(SQLException se){
    se.printStackTrace();
}catch(Exception e){
    e.printStackTrace();
}finally{
    try{
        if(stmt!=null)
            conn.close();
    }catch(SQLException se){
        se.printStackTrace()
    }
    try{
        if(conn!=null)
            conn.close();
    }catch(SQLException se){
        se.printStackTrace();
    }
}

```
