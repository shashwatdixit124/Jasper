package jasper.data;

import jasper.helper.*;
import java.sql.ResultSet;
import java.util.*;

public class DataBase {

	private String error = "";
	private String database = "";
	private String user = "";
	private String pass = "";
	
	private JasperDb db;
	
	public DataBase(String dbname,String uname,String passwd)
	{
		database = dbname;
		user = uname;
		pass = passwd;
		db = new JasperDb(database,user,pass);
	}
	
	public String getErrorMessage()
	{
		return error;
	}
	
	public ArrayList<String> getDatabaseList()
	{
		db.usePrev();
		
		ConnectionResult cr = db.getConnectionResult();
		ArrayList<String> list = new ArrayList<String>();;
		
		if(!cr.isError()){
			String query = "SHOW DATABASES";
			QueryResult qr = db.executeQuery(query);

			if(qr.isError())
				error = "Cannot Find Database List";
			else{
				ResultSet rs = qr.getResult();
				try{
					while(rs.next())
					{
						String data = rs.getString("Database");
						list.add(data);
					}
					rs.close();
				}catch(Exception e){
					error = "Error Reading From Database List";
					e.printStackTrace();
				}
			}
			db.close();
		}
		else
		{
			error = "Cannot Connect To Database";
		}
		return list;
	}
	
	public ArrayList<String> getTableList()
	{
		db.usePrev();
		
		ConnectionResult cr = db.getConnectionResult();
		ArrayList<String> list = new ArrayList<String>();
		
		if(!cr.isError()){
			String query = "SHOW TABLES";
			QueryResult qr = db.executeQuery(query);

			if(qr.isError())
				error = "Cannot Find Table List";
			else{
				ResultSet rs = qr.getResult();
				try{
					while(rs.next())
					{
						String data = rs.getString("Tables_in_"+database);
						list.add(data);
					}
					rs.close();
				}catch(Exception e){
					error = "Error Reading From Table List";
					e.printStackTrace();
				}
			}
			db.close();
		}
		else
		{
			error = "Cannot Connect To Database";
		}
		return list;
	}
	
}
