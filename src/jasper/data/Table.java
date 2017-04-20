package jasper.data;

import jasper.helper.*;
import java.sql.ResultSet;
import java.util.*;

public class Table {

	private String error = "";
	private String database = "";
	private String table = "";
	private String user = "";
	private String pass = "";
	
	private JasperDb db;
	
	public Table(String dbname,String tname,String uname,String passwd)
	{
		database = dbname;
		table = tname;
		user = uname;
		pass = passwd;
		db = new JasperDb(database,user,pass);
		System.out.println(database+"."+table);
	}
	
	public String getErrorMessage()
	{
		return error;
	}
	
	public String getInsertTableHTML()
	{
		String tableForInserting = "";
		if(db.getConnectionResult().isError())
		{
			error = "Error in Connecting to Database "+database;
			return "";
		}
		else
		{
			JasperDb db1 = new JasperDb("information_schema",user,pass); 
			QueryResult qr = db1.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+database+"\" and TABLE_NAME = \""+table+"\"");
			if(!qr.isError())
			{
				tableForInserting = "<table class='col-xs-12'>";
				ResultSet rs = qr.getResult();
				try{
					while(rs.next())
					{
						String name = rs.getString("COLUMN_NAME");
						String is_nullable = rs.getString("IS_NULLABLE");
						String col_type = rs.getString("COLUMN_TYPE");
						String data_type = rs.getString("DATA_TYPE");
						String col_default = rs.getString("COLUMN_DEFAULT");
						tableForInserting += "<tr>";
						tableForInserting += "<td><label for='" + name + "'> " + name + "</label></td>";
						tableForInserting += "<td><span class='col-type'> [ " + col_type + " ] </span></td>";
						String placeHolder = null;
						String required = "";
						
						if (is_nullable.equals("NO"))
						{
							if(!rs.wasNull() && !"NULL".equals(col_default))
								placeHolder = "can be empty";
							else
								placeHolder = "can't be empty";
						}
						else
						{
							placeHolder = "can be empty";
						}
						
						if (is_nullable.equals("NO")) 
						{
							if(rs.wasNull() || "NULL".equals(col_default))
								required = "required";
						}
						
						if (data_type.equals("date")) {
							tableForInserting += "<td><input type='date' name='"+name+"' id='"+name+"' placeholder=\"" +placeHolder+ "\" " +required+ " ></td>";
							
						}
						else if (data_type.equals("timestamp")) {
							tableForInserting += "<td><input type='datetime-local' name='"+name+"' id='"+name+"' placeholder=\"" +placeHolder+ "\" " +required+ " ></td>";
						}
						else {
							tableForInserting += "<td><input type='text' name='"+name+"' id='"+name+"' placeholder=\"" +placeHolder+ "\" " +required+ " ></td>";
						}
						tableForInserting += "</tr>";
					}
					rs.close();
				}
				catch(Exception e){
					error = "Error in Reading Data From "+table;
					e.printStackTrace();
				}
				tableForInserting += "</table>";
				db1.close();
			}
		}
		
		return tableForInserting;
	}
	
	@Override
	protected void finalize(){
		db.close();
	}
	
	public String getDescriptionHTML()
	{
		String tableForDesc = "";
		db.usePrev();
		QueryResult qr = db.executeQuery("DESC "+table);
		if(!qr.isError())
		{
			tableForDesc = "<table class='table table-stripped col-xs-12'>";
			tableForDesc += "<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>";
			ResultSet rs = qr.getResult();
			try{
				while(rs.next())
				{
					String field = rs.getString("Field");
					String type = rs.getString("Type");
					String isNull = rs.getString("Null");
					String key = rs.getString("Key");
					String default_val = rs.getString("Default");
					if(rs.wasNull())
						default_val = null;
					String extra = rs.getString("Extra");
					tableForDesc += "<tr>";
					tableForDesc += "<td>"+field+"</td>";
					tableForDesc += "<td>"+type+"</td>";
					tableForDesc += "<td>"+isNull+"</td>";
					tableForDesc += "<td>"+key+"</td>";
					if(default_val != null)
						tableForDesc += "<td>"+default_val+"</td>";
					else
						tableForDesc += "<td>NULL</td>";
					tableForDesc += "<td>"+extra+"</td>";
					tableForDesc += "</tr>";
			
				}
				rs.close();
			}
			catch(Exception e)
			{
				error = "Error in Reading Data From "+table;
				e.printStackTrace();
			}
			db.close();
			tableForDesc += "</table>";
		}
		return tableForDesc;
	}
	
}
