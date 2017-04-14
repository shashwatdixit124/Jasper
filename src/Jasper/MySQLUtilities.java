package Jasper;
import java.sql.*;

public class MySQLUtilities {
	
	public static ConnectionResult getConnection(String uname, String pass){
		Connection conn = null;
		try{
			try{
			   Class.forName("com.mysql.jdbc.Driver").newInstance();
			}catch(Exception e){
				return new ConnectionResult(ConnectionResult.ResultType.JDBCERROR,null,"Cannot Initialise JDBC Instance");
			}
		   conn = DriverManager.getConnection("jdbc:mysql://localhost/", uname, pass);
		   return new ConnectionResult(ConnectionResult.ResultType.OK,conn,"Success");
			   
		}catch(SQLException se){
			return new ConnectionResult(ConnectionResult.ResultType.CONNERROR,null,"Cannot Connect ");
		}
	}
	
	public static void closeConnection(Connection conn){
		try{
			if(conn!=null)
				conn.close();
		}catch(SQLException se){
			se.printStackTrace();
		}
	}

	public static QueryResult executeQuery(Connection conn, String query){
		if(conn == null)
			return new QueryResult(QueryResult.ResultType.ERROR, null);
		
		Statement stmt = null;
		try{
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			try{
				if(stmt!=null)
					stmt.close();
			}catch(SQLException se){
				se.printStackTrace();
			}
			return new QueryResult(QueryResult.ResultType.OK, rs);
			
		}catch(Exception e)
		{
			try{
				if(stmt!=null)
					stmt.close();
			}catch(SQLException se){
				se.printStackTrace();
			}
			return new QueryResult(QueryResult.ResultType.ERROR, null);
		}
	}
}
