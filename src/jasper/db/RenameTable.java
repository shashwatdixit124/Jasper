package jasper.db;
import jasper.helper.*;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jasper.helper.*;
import java.sql.*;
/**
 * Servlet implementation class Createdb
 */
@WebServlet("/RenameTable")
public class RenameTable extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	String dbName;
	String old_tname;
	String new_tname;
	String uname;
	String pass;
	int flag = 0;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		new_tname = request.getParameter("table");
		old_tname = request.getParameter("old_table");
		
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
			String query = "RENAME TABLE " + dbName + "." + old_tname + " TO " + dbName + "." + new_tname;
			int rows = db.executeUpdate(query);
			
			
			QueryResult qr = db.executeQuery("SHOW TABLES IN " + dbName);
			if(!qr.isError())
			{
		
				ResultSet rs = qr.getResult();
				try {
				while(rs.next())
				{
					String tname = rs.getString("Tables_in_"+dbName);
					if (tname.equals(new_tname)) {
						flag = 1;
						break;
					}
			
				}
				} catch(SQLException ex) {
                    System.err.println("SQLException: " + ex.getMessage());
				}
				notification = "<div class=\"alert alert-success\">" + query + ";</div>";
				if (flag == 1) {
					notification = "<div class=\"alert alert-success\">" + query + ";</div>";
					
				}else {
					
					notification = "<div class=\"alert alert-error\">" + query + ";</div>";
				}
				
				
			}
			
			request.getSession().setAttribute("message", notification);
			response.sendRedirect("table.jsp?db="+dbName);
		}
		
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("home.jsp");
	}

}
