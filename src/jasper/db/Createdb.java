package jasper.db;

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
@WebServlet("/Createdb")
public class Createdb extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	String dbName;
	String uname;
	String pass;
	int dbCreateStatus;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		JasperCookie cookies = new JasperCookie(request);
		
		if(!cookies.exists("uname") || !cookies.exists("uname")){
			response.sendRedirect("index.jsp");
		}
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		
		dbName = request.getParameter("db-name");
	

		
		
		
		JasperDb db = new JasperDb("",uname,pass);
		ConnectionResult cr = db.getConnectionResult();
		if(!cr.isError()){
			String query = "CREATE DATABASE " + dbName;
			QueryResult qr = db.executeQuery(query);
			if(qr.isError())	{
				
				response.sendRedirect("home.jsp?dbCreateStatus=0");
			  
			}
			else{
				 
				response.sendRedirect("home.jsp?dbCreateStatus&db=" + dbName); 
			 
			}
			
		} else {
			response.getWriter().append("Could not connect");
			
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
