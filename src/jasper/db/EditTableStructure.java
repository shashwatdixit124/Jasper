package jasper.db;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import jasper.helper.ConnectionResult;
import jasper.helper.JasperCookie;
import jasper.helper.JasperDb;

@WebServlet("/editTableStructure")
public class EditTableStructure extends HttpServlet{
	private static final long serialVersionUID = 1L;

	String dbName;
	String tname;
	String uname;
	String pass;
	String action;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		JasperCookie cookies = new JasperCookie(request,response);
		
		dbName = request.getParameter("db");
		tname = request.getParameter("table");
		action = request.getParameter("edit-action");
		
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
		else if(!"ADD".equals(action) && !"CHANGE".equals(action) && !"DROP".equals(action)){
			response.sendRedirect("tablecontent.jsp?db="+dbName+"&table="+tname);
			return;
		}
		
		uname = cookies.getValue("uname");
		pass = cookies.getValue("pass");
		
		String notification = null;
		String query = "";
		
		JasperDb db = new JasperDb(dbName,uname,pass);
		ConnectionResult cr = db.getConnectionResult();
		if(cr.isError())
		{
			notification = "<div class=\"alert alert-danger\">"+
								"SQLError ("+cr.getMessage()+") "+
							"</div>";
			request.getSession().setAttribute("message", notification);
			response.sendRedirect("tablecontent.jsp?db="+dbName+"&table="+tname);
			return;
		}
		else
		{
			if(action.equals("DROP"))
			{
				String col = request.getParameter("drop_column_name");
				query = "ALTER TABLE `"+tname+"` DROP COLUMN `"+col+"`";
				db.executeUpdate(query);
			}
			else if(action.equals("ADD"))
			{
				String colName = request.getParameter("add_after_column_name");
				String col = "";
				String name = request.getParameter("field_name_add");
				String type = request.getParameter("field_type_add");
				String default_type = request.getParameter("field_default_type_add");
				String default_value = request.getParameter("field_default_value_add");
				String length = request.getParameter("field_length_add");
				String isNull = request.getParameter("field_null_add");
				String attribute = request.getParameter("field_attribute_add");
				String auto_inc = request.getParameter("field_extra_add");
				
				System.out.println(name);
				System.out.println(type);
				System.out.println(length);
				System.out.println(default_type);
				System.out.println(default_value);
				System.out.println(isNull);
				System.out.println(attribute);
				System.out.println(auto_inc);
				
				
				
				if(name != null)
				{
					query = "ALTER TABLE `"+tname+"` ADD `"+name+"` ";
				}
				else
				{
					notification = "<div class='alert alert-danger'>No Column Name Specified</div>";
					request.getSession().setAttribute("message", notification);
					response.sendRedirect("tablecontent.jsp?db="+dbName+"&table="+tname);
					return;
				}

				if(length != null)
				{
					if(length.isEmpty())
						col += type+ " ";
					else
						col += type+"("+length+") ";
				}
				
				if(auto_inc!=null)
				{
					col += "AUTO_INCREMENT ";
				}
				
				if(isNull == null){
					col += "NOT NULL ";
				}
				
				if(default_type != null)
				{
					if(default_type.equals("NONE"))
					{
						// do nothing
					}
					else if(default_type.equals("USER_DEFINED"))
					{
						if(default_value == null)
							col += "DEFAULT '"+default_value+"' ";
						else if(!default_value.isEmpty())
							col += "DEFAULT '"+default_value+"' ";
						else
							col += "DEFAULT '' ";
					}
					else
					{
						col += "DEFAULT "+default_type+" ";
					}
				}

				if(attribute != null)
				{
					col += attribute + " ";
				}

				if("".equals(colName))
					query += col;
				else if(colName == null)
					query += col;
				else if(colName.equals("FIRST"))
					query += col+" FIRST";
				else
					query += col+" AFTER `"+colName+"`";
				
				db.executeUpdate(query);
				
			}
			else if(action.equals("CHANGE"))
			{
				String colName = request.getParameter("add_after_column_name");
				String col = "";
				String name = request.getParameter("field_name_change");
				String type = request.getParameter("field_type_change");
				String default_type = request.getParameter("field_default_type_change");
				String default_value = request.getParameter("field_default_value_change");
				String length = request.getParameter("field_length_change");
				String isNull = request.getParameter("field_null_change");
				String attribute = request.getParameter("field_attribute_change");
				String auto_inc = request.getParameter("field_extra_change");
				
				query = "ALTER TABLE `"+tname;
						
				if(name == null)
				{
					query += "` MODIFY "+colName+" ";
				}
				else if("".equals(name))
				{
					query += "` MODIFY "+colName+" ";
				}
				else
				{
					query += "` CHANGE "+colName+" "+name+" ";
				}
				col += name + " ";
				
				if(length != null)
				{
					if(length.isEmpty())
						col += type+ " ";
					else
						col += type+"("+length+") ";
				}
				
				if(auto_inc!=null)
				{
					col += "AUTO_INCREMENT ";
				}
				
				if(isNull == null){
					col += "NOT NULL ";
				}
				
				if(default_type != null)
				{
					if(default_type.equals("NONE"))
					{
						// do nothing
					}
					else if(default_type.equals("USER_DEFINED"))
					{
						if(default_value == null)
							col += "DEFAULT '"+default_value+"' ";
						else if(!default_value.isEmpty())
							col += "DEFAULT '"+default_value+"' ";
						else
							col += "DEFAULT '' ";
					}
					else
					{
						col += "DEFAULT "+default_type+" ";
					}
				}

				if(attribute != null)
				{
					col += attribute + " ";
				}

				query += col ;
				
				db.executeUpdate(query);
			}
			db.close();
		}
		notification = "<div class='alert' style='background-color:#fcfcfc; border: 1px solid #777;'>"+query+";</div>";
		request.getSession().setAttribute("message", notification);
		response.sendRedirect("tablecontent.jsp?db="+dbName+"&table="+tname);
	
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect("home.jsp");
	}
}
