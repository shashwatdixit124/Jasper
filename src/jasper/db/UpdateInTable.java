package jasper.db;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jasper.helper.JasperCookie;
import jasper.helper.JasperDb;
import jasper.helper.QueryResult;

@WebServlet("/updateInTable")
public class UpdateInTable extends HttpServlet{
	private static final long serialVersionUID = 1L;
	String uname;
    String pass;
    String dbName;
    String tname;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		tname = request.getParameter("tname");
		String data = request.getParameter("data");
		
		if(!cookies.exists("uname") || !cookies.exists("uname")){
			response.sendRedirect("index.jsp");
			return;
		}else if(dbName == null || dbName.isEmpty()) {
			response.sendRedirect("home.jsp");
			return;
		}else if(tname == null || tname.isEmpty() || data == null || data.isEmpty()){
			response.sendRedirect("table.jsp?db="+dbName);
			return;
		}
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		JasperDb db = new JasperDb("information_schema",uname,pass);
		JasperDb db1 = new JasperDb(dbName, uname, pass);
		String query = "";
		if(db.getConnectionResult().isError())
		{
			notification = "<div class=\"alert alert-danger\">"+
								"Error Reading Database information_schema <br>"+
							"</div>";
			request.getSession().setAttribute("message", notification);
			response.sendRedirect("tablecontent.jsp?db=" + dbName + "&table=" + tname);
			return;
		}
		QueryResult qr = db.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+dbName+"\" and TABLE_NAME = \""+tname+"\"");
		if(!qr.isError())
		{
			ResultSet rs = qr.getResult();
			try {
				while(rs.next())
				{
					String name = rs.getString("COLUMN_NAME");
					String is_nullable = rs.getString("IS_NULLABLE");
					String value = request.getParameter(name);
					String data_type = rs.getString("DATA_TYPE");
					
					if (value != null) {
						if(!is_nullable.equalsIgnoreCase("NO") && value.isEmpty())
							query = query + name + "=NULL" + ", ";
						else if(data_type.equals("tinyint"))
							query = query + name + "=" + value + ", ";
						else
							query = query + name + "='" + value + "'" + ", ";
					}
				}
			} catch(SQLException ex) {
				notification = "<div class=\"alert alert-danger\">"+
									"SQLError ("+ex.getSQLState()+") <br>"+
									ex.getMessage()+
								"</div>";
                System.err.println("SQLException: " + ex.getMessage());
                response.sendRedirect("tablecontent.jsp?db=" + dbName + "&table=" + tname);
                return;
			}

			query = query.substring(0, query.length()-2);
			
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
			
			query = "UPDATE `" + tname + "` SET "+query+ " WHERE " +actualData;
			System.out.println(query);
			int rows = db1.executeUpdate(query);
			if(rows == 0){
				notification = "<div class=\"alert alert-danger\">"+
									"Error Inserting Row<br>"+
									query+";"+
								"</div>";
			}
			else{
				notification = "<div class=\"alert alert-success\">"+
									"Row Inserted<br>"+
									query+";"+
								"</div>";
			}
			request.getSession().setAttribute("message", notification);
		}
		else{
			notification = "<div class=\"alert alert-danger\">"+
								"Error Reading Database information_schema <br>"+
								query+";"+
							"</div>";
		}
		request.getSession().setAttribute("message", notification);
		response.sendRedirect("tablecontent.jsp?db=" + dbName + "&table=" + tname);
		
    }
}
