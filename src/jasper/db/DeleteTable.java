package jasper.db;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jasper.helper.ConnectionResult;
import jasper.helper.JasperCookie;
import jasper.helper.JasperDb;

@WebServlet("/deleteTable")
public class DeleteTable {
	
	String dbName;
	String tname;
	String uname;
	String pass;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("home.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
				
		JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		tname = request.getParameter("table");
		
		if(!cookies.exists("uname") || !cookies.exists("uname"))
			response.sendRedirect("index.jsp");
		else if(dbName == null || dbName.isEmpty())
			response.sendRedirect("home.jsp");
		else if(tname == null || tname.isEmpty())
			response.sendRedirect("table.jsp?db="+dbName);
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		
		JasperDb db = new JasperDb("",uname,pass);
		ConnectionResult cr = db.getConnectionResult();
		if(!cr.isError()){
			String query = "DROP TABLE " + tname;
			int rows = db.executeUpdate(query);
			if(rows != 0){
				notification = "<div class=\"alert alert-warning\">0 rows Affected</div>";
			}
			else{
				notification = "<div class=\"alert alert-warning\">Database Deleted Successfully</div>";
			}
			response.sendRedirect("home.jsp");
		}
	}
}
