package jasper.db;


import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jasper.helper.ConnectionResult;
import jasper.helper.JasperCookie;
import jasper.helper.JasperDb;

@WebServlet("/createTable")
public class CreateTable extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	String dbName;
	String uname;
	String pass;
	String tname;
	
	protected String getType(int type){
		return null;
	} 
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		tname = request.getParameter("table");
		
		if(!cookies.exists("uname") || !cookies.exists("uname")){
			response.sendRedirect("index.jsp");
			return;
		}else if(dbName == null || dbName.isEmpty()) {
			response.sendRedirect("home.jsp");
			return;
		}else if(tname == null || tname.isEmpty()){
			response.sendRedirect("table.jsp?db="+dbName);
			return;
		}
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		String data = "";
		
		JasperDb db = new JasperDb(dbName,uname,pass);
		ConnectionResult cr = db.getConnectionResult();
		if(cr.isError())
		{
			notification = "<div class=\"alert alert-danger\">"+
								"SQLError ("+cr.getMessage()+") "+
							"</div>";
			request.getSession().setAttribute("message", notification);
			response.sendRedirect("table.jsp?db="+dbName);
			return;
		}
		
		/*ArrayList<String> name = new ArrayList<String>();
		ArrayList<String> type = new ArrayList<String>();
		ArrayList<String> length = new ArrayList<String>();
		ArrayList<String> default_type = new ArrayList<String>();
		ArrayList<String> default_value = new ArrayList<String>();
		ArrayList<String> attribute = new ArrayList<String>();
		ArrayList<String> allow_null = new ArrayList<String>();
		ArrayList<String> key = new ArrayList<String>();
		ArrayList<String> auto_inc = new ArrayList<String>();*/
		
		String[] names = request.getParameterValues("field_name");
		String[] types = request.getParameterValues("field_type");
		String[] lengths = request.getParameterValues("field_length");
		String[] default_types = request.getParameterValues("field_default_type");
		String[] default_values = request.getParameterValues("field_default_value");
		String[] attributes = request.getParameterValues("field_attribute");
		String[] nulls = request.getParameterValues("field_null");
		String[] keys = request.getParameterValues("field_key");
		String[] auto_incs = request.getParameterValues("field_extra");
		String primary_key = "";
		String index_key = "";
		String unique_key = "";
		
		String query = "CREATE TABLE `"+tname+"` ( ";
		String html_query = "CREATE TABLE `"+tname+"` <br>(<br>&nbsp;&nbsp;&nbsp;&nbsp;";
		String col = "";
		try{
			int size = names.length;
			for(int i=0;i<size;i++)
			{
				col = "";
				if(names[i]==null || "".equals(names[i])){
					continue;
				}
				col += names[i] + " ";

				if(lengths[i].isEmpty())
					col += types[i]+ " ";
				else
					col += types[i]+"("+lengths[i]+") ";
				

				boolean has_null = false;
				if(nulls!=null){
					System.out.println("checking for null");
					System.out.println(nulls.length);
					System.out.println("Checking for null");
					for(int j=0;j<nulls.length;j++){
						System.out.println(nulls[j]);
						if(("NULL"+Integer.toString(i)).equals(nulls[j]))
						{
							has_null = true;
							break;
						}
					}
				}
				if(!has_null){
					col += "NOT NULL ";
				}
				
				if(default_types[i].equals("NONE"))
				{
					// do nothing
				}
				else if(default_types[i].equals("USER_DEFINED") && !default_values[i].isEmpty())
				{
					col += "DEFAULT "+default_values[i]+" ";
				}
				else {
					col += "DEFAULT "+default_types[i]+" ";
				}

				if(!attributes[i].isEmpty())
				{
					col += attributes[i] + " ";
				}				

				if(keys[i].equals("PRIMARY"))
				{
					if(primary_key.isEmpty())
						primary_key += "`"+names[i]+"`";
					else
						primary_key += ", `"+names[i]+"`";
				}
				else if(keys[i].equals("INDEX"))
				{
					if(index_key.isEmpty())
						index_key += "`"+names[i]+"`";
					else
						index_key += ", `"+names[i]+"`";
				}
				else if(keys[i].equals("UNIQUE"))
				{
					if(unique_key.isEmpty())
						unique_key += "`"+names[i]+"`";
					else
						unique_key += ", `"+names[i]+"`";
				}
				
				query += col;
				html_query+=col;
				if(i < size-1 && size != 2)
				{
					query += ",";
					html_query+= ",<br>&nbsp;&nbsp;&nbsp;&nbsp;";
				}
			}
			
			if(!primary_key.isEmpty()){
				query += ", PRIMARY KEY ( "+primary_key+" )";
				html_query += ",<br>&nbsp;&nbsp;&nbsp;&nbsp;PRIMARY KEY( "+primary_key+" )";
			}
			if(!index_key.isEmpty()){
				query += ", INDEX KEY "+dbName+"_"+tname+"_"+"index"+" ( "+index_key+" )";
				html_query += ",<br>&nbsp;&nbsp;&nbsp;&nbsp;INDEX KEY "+dbName+"_"+tname+"_"+"index"+" ( "+index_key+" )";
			}
			if(!unique_key.isEmpty()){
				query += ", UNIQUE KEY "+dbName+"_"+tname+"_"+"index"+" ( "+unique_key+" )";
				html_query += ",<br>&nbsp;&nbsp;&nbsp;&nbsp;UNIQUE KEY "+dbName+"_"+tname+"_"+"index"+" ( "+unique_key+" )";
			}
			
			query += " )";
			html_query += "<br>)";
		}catch(ArrayIndexOutOfBoundsException e){
			e.printStackTrace();
		}
		
		int rows = db.executeUpdate(query);
		System.out.println(rows);
		notification = "<div class ='alert alert-success'>"+html_query+";</div>";
		request.getSession().setAttribute("message", notification);
		response.sendRedirect("table.jsp?db="+dbName);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.sendRedirect("home.jsp");
	}
}
