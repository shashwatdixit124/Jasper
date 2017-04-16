package jasper.table;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jasper.helper.ConnectionResult;
import jasper.helper.JasperCookie;
import jasper.helper.JasperDb;

@WebServlet("/deleteTableContent")
public class DeleteTableContent extends HttpServlet{
	private static final long serialVersionUID = 1L;
	String dbName;
	String tname;
	String uname;
	String pass;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		tname = request.getParameter("table");
		String data = request.getParameter("data");
		
		if(!cookies.exists("uname") || !cookies.exists("uname"))
		{
			response.sendRedirect("index.jsp");
			return;
		}
		else if(dbName == null || dbName.isEmpty())
		{
			response.sendRedirect("home.jsp");
			return;
		}
		else if(tname == null || tname.isEmpty() || data == null || data.isEmpty())
		{
			response.sendRedirect("table.jsp?db="+dbName);
			return;
		}
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		long len = data.length();
		String actualData = "";
		char ch ;
		int temp;
		String str = "";
		for(int i = 0;i<len;i+=3)
		{
			str = data.substring(i, i+3);
			temp = Integer.parseInt(str);
			ch = (char)temp;
			actualData += ch;
		}
		
		JasperDb db = new JasperDb(dbName,uname,pass);
		ConnectionResult cr = db.getConnectionResult();
		if(!cr.isError()){
			String query = "DELETE FROM " + tname + " WHERE " + actualData;
			int rows = db.executeUpdate(query);
			if(rows != 0){
				notification = "<div class=\"alert alert-warning\">0 rows Affected</div>";
			}
			else{
				notification = "<div class=\"alert alert-success\">Deleted Successfully</div>";
			}
		}
		response.sendRedirect("tablecontent.jsp?db="+dbName+"&table="+tname);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		response.sendRedirect("home.jsp");
	}

}
