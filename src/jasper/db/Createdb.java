package jasper.db;
import jasper.helper.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jasper.helper.*;

/**
 * Servlet implementation class Createdb
 */
@WebServlet("/createDatabase")
public class Createdb extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	String dbName;
	String uname;
	String pass;
	int dbCreateStatus;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		
		if(!cookies.exists("uname") || !cookies.exists("uname")){
			response.sendRedirect("index.jsp");
		}else if(dbName == null || dbName.isEmpty())
			response.sendRedirect("home.jsp");
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		
		JasperDb db = new JasperDb("",uname,pass);
		ConnectionResult cr = db.getConnectionResult();
		if(!cr.isError()){
			String query = "CREATE DATABASE " + dbName;
			int rows = db.executeUpdate(query);
			if(rows != 0){
				notification = "<div class=\"alert alert-warning\">0 rows Affected</div>";
			}
			else{
				notification = "<div class=\"alert alert-warning\">Database Created Successfully</div>";
			}
			response.sendRedirect("home.jsp");
		}
		
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("home.jsp");
	}

}
