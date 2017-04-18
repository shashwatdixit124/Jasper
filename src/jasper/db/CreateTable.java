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
		
		if(!cookies.exists("uname") || !cookies.exists("uname")){
			response.sendRedirect("index.jsp");
			return;
		}else if(dbName == null || dbName.isEmpty()) {
			response.sendRedirect("home.jsp");
			return;
		}
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		String data = "";
		
		tname = request.getParameter("table");
		
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
		
		try{
		for(int i=0;i<names.length;i++)
		{
//			name.add(names[i]);
//			type.add(types[i]);
//			length.add(lengths[i]);
//			default_type.add(default_types[i]);
//			default_value.add(default_values[i]);
//			attribute.add(attributes[i]);
//			allow_null.add(allow_nulls[i]);
//			key.add(keys[i]);
//			auto_inc.add(auto_incs[i]);
			
			System.out.println("Coloumn "+i);
			if(names[i]==null)
				continue;
			System.out.println("Name : " + names[i]);
			if(types[i]==null)
				System.out.println("Type : NULL");
			else
				System.out.println("Type : "+types[i]);
			if(lengths[i]==null)
				System.out.println("Length : NULL");
			else
				System.out.println("Length : "+lengths[i]);
			if(default_types[i]==null)
				System.out.println("Default Type : NULL");
			else
				System.out.println("Default Type : "+default_types[i]);
			if(default_values[i]==null)
				System.out.println("Default Value : NULL");
			else
				System.out.println("Default Value : "+default_values[i]);
			if(attributes[i]==null)
				System.out.println("Attribute : NULL");
			else
				System.out.println("Attribute : "+attributes[i]);
			if(nulls[i] == null)
				System.out.println("NULL : NOT NULL");
			else
				System.out.println("NULL : NULL");
			if(keys[i]==null)
				System.out.println("Index : NULL");
			else
				System.out.println("Index : "+keys[i]);
			if(auto_incs[i]==null)
				System.out.println("A_I : NULL");
			else
				System.out.println("A_I : "+auto_incs[i]);
			
			
			
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		
		response.sendRedirect("table.jsp?db="+dbName);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.sendRedirect("home.jsp");
	}
}
