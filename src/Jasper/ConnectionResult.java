package Jasper;
import java.sql.*;

public class ConnectionResult {
	public static enum ResultType{
		OK,
		CONNERROR,
		JDBCERROR
	}
	
	ResultType type;
	Connection conn;
	String msg;
	
	public ConnectionResult(ResultType t, Connection c, String m){
		type = t;
		conn = c;
		msg = m;
	}

	public boolean isError(){
		return type != ResultType.OK;
	}
	
	public boolean isConnectionError(){
		return type == ResultType.CONNERROR;
	}
	
	public boolean isJDBCError(){
		return type == ResultType.JDBCERROR;
	}
	
	public String getMessage(){
		return msg;
	}
	
	public Connection getConnection(){
		return conn;
	}
}
