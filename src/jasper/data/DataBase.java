package jasper.data;

import jasper.helper.*;
import java.sql.ResultSet;
import java.util.*;

public class DataBase {

	private static String error = "";
	
	public static String getError()
	{
		return error;
	}
	
	public static ArrayList<String> getDatabaseList(String uname, String pass)
	{
		JasperDb db = new JasperDb("",uname,pass);
		
		ConnectionResult cr = db.getConnectionResult();
		ArrayList<String> list = null;
		
		if(!cr.isError()){
			String query = "SHOW DATABASES";
			QueryResult qr = db.executeQuery(query);

			if(qr.isError())
				error = "Cannot Find Database List";
			else{
				list = new ArrayList<String>();
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
	
	public static ArrayList<String> getTableList(String dbname, String uname, String pass)
	{
		JasperDb db = new JasperDb(dbname,uname,pass);
		
		ConnectionResult cr = db.getConnectionResult();
		ArrayList<String> list = null;
		
		if(!cr.isError()){
			String query = "SHOW TABLES";
			QueryResult qr = db.executeQuery(query);

			if(qr.isError())
				error = "Cannot Find Table List";
			else{
				list = new ArrayList<String>();
				ResultSet rs = qr.getResult();
				try{
					while(rs.next())
					{
						String data = rs.getString("Database");
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
