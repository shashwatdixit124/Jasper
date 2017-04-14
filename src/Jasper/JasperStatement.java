package Jasper;
import java.sql.*;

public class JasperStatement {
	Statement stmt;
	public JasperStatement(Connection conn){
		try{
			stmt = conn.createStatement();			
		}catch(Exception e)
		{
			stmt = null;
		}
	}
	
	public QueryResult executeQuery(String query){
		if(stmt == null)
			return new QueryResult(QueryResult.ResultType.ERROR, null);
		try{
			ResultSet rs = stmt.executeQuery(query);
			return new QueryResult(QueryResult.ResultType.OK, rs);
		}catch(Exception e)
		{
			return new QueryResult(QueryResult.ResultType.ERROR, null);
		}
	}
	
	public void close(){
		try{
			if(stmt!=null)
				stmt.close();
		}catch(SQLException se){
			se.printStackTrace();
		}
	}
}
