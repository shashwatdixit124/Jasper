package Jasper;
import java.sql.*;

public class QueryResult {
	public static enum ResultType{
		OK,
		ERROR
	}
	
	ResultType type;
	ResultSet result;
	
	public QueryResult(ResultType t, ResultSet r){
		type = t;
		result = r;
	}
	
	public boolean isError(){
		return type == ResultType.ERROR;
	}
	
	public ResultSet getResult(){
		return result;
	}
}
