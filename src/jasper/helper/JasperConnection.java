package jasper.helper;
import java.sql.*;

public class JasperConnection {
	
	Connection conn;
	String db;
	String uname;
	String pass;
	
	public JasperConnection(String d, String u, String p){
		db = d;
		uname = u;
		pass = p;
		conn = null;
	}
	
	public ConnectionResult start(){
		try{
			try{
			   Class.forName("com.mysql.jdbc.Driver").newInstance();
			}catch(Exception e){
				return new ConnectionResult(ConnectionResult.ResultType.JDBCERROR,null,"Cannot Initialise JDBC Instance");
			}
			conn = DriverManager.getConnection("jdbc:mysql://localhost/"+db, uname, pass);
		    return new ConnectionResult(ConnectionResult.ResultType.OK,conn,"Success");
			   
		}catch(SQLException se){
			close();
			return new ConnectionResult(ConnectionResult.ResultType.CONNERROR,null,"Cannot Connect ");
		}
	}
	
	public void close(){
		try{
			if(conn!=null)
				conn.close();
		}catch(SQLException se){
			se.printStackTrace();
		}
	}
	
	public Connection getConnection(){
		return conn;
	}
}
