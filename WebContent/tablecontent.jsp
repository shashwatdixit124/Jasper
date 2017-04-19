<%@ page import="java.sql.*,jasper.helper.*,java.util.*" %> 

<%
	String errorNotification = (String)session.getAttribute("message");
	session.removeAttribute("message");
	
	boolean isTableEmpty = false;
	
	String uname = null;
	String pass = null;

	String dbname = null;
	dbname = request.getParameter("db");
	String tname = null;
	tname = request.getParameter("table");
	
	JasperCookie cookies = new JasperCookie(request,response);
	
	if(!cookies.exists("uname") || !cookies.exists("uname")){
		response.sendRedirect("index.jsp");
		return;
	}else if(dbname == null || dbname.isEmpty()){
		response.sendRedirect("home.jsp");
		return;
	}
	else if(tname == null || tname.isEmpty()){
		response.sendRedirect("table.jsp?db="+dbname);
		return;
	}
	
	uname = cookies.getValue("uname");
	pass = cookies.getValue("pass");
	
%>

<html>
<head>
<title>Jasper</title>
<link rel="stylesheet" type="text/css" href="/Jasper/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/Jasper/css/template.css">
<script src="/Jasper/js/jquery.min.js"></script>
<script src="/Jasper/js/bootstrap.min.js"></script>
</head>
<body>
	<div class="container-fluid">
		<div class="row">
		
			<!-- Side Bar for showing databases -->
			<div class="col-xs-2 sidebar">
				<div class="row">
					<h1 class="height-70 margin-0" id="jasper">Jasper</h1>
					<div class="col-xs-12" id="navigation-list">
						<div class="row">
							<a href="home.jsp">
								<div class="col-xs-6 navigation-widget border-bottom border-right">
									<div class="row">
										<div class="col-xs-12 navigation-icon">
											<span class="glyphicon glyphicon-home"></span>
										</div>
										<div class="col-xs-12 navigation-text">
											Home
										</div>
									</div>
								</div>
							</a>
							<a href="logout">
								<div class="col-xs-6 navigation-widget border-bottom">
									<div class="row">
										<div class="col-xs-12 navigation-icon">
											<span class="glyphicon glyphicon-log-out"></span>
										</div>
										<div class="col-xs-12 navigation-text">
											Logout
										</div>
									</div>
								</div>
							</a>
						</div>
					</div>
					<div class="col-xs-12" id="db-list">
						<div class="row">
<%
JasperDb db = new JasperDb("",uname,pass);
ConnectionResult cr = db.getConnectionResult();
if(!cr.isError()){
	String query = "SHOW DATABASES";
	QueryResult qr = db.executeQuery(query);

	if(qr.isError())
		errorNotification = "<div class=\"alert alert-danger\">Cannot Find Database List</div>";
	else{
		ResultSet rs = qr.getResult();
		while(rs.next())
		{
			String data = rs.getString("Database");
%>
							<a href="table.jsp?db=<% out.print(data); %>" ><h4 class="col-xs-12 height-30 db <% if(data.equals(dbname)) out.print("active"); %>"><% out.print(data); %></h4></a>
<%
		}
		rs.close();
	}
	db.close();
}
%>

						</div>
					</div>
				</div>
			</div>
			
			<!-- Main View for  -->
			<div class="col-xs-10 col-xs-offset-2" id="main-view">
				<div class="row">
					<div class="col-xs-12 action-bar">
						<div class="container-fluid">
							<div class="row">
								<div class="col-xs-12" id="action-list">
									<div class="row">
										<div class="col-xs-2 action-widget border-right"  data-toggle="modal" data-target="#insertInTable">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-plus"></span>
												</div>
												<div class="col-xs-12 action-text">
													Insert
												</div>
											</div>
										</div>
										<div class="col-xs-2 action-widget border-right" data-toggle="modal" data-target="#showStructure">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-list-alt"></span>
												</div>
												<div class="col-xs-12 action-text">
													Show Structure
												</div>
											</div>
										</div>
										<div class="col-xs-2 action-widget border-right" data-toggle="modal" data-target="#renameTable">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-pencil"></span>
												</div>
												<div class="col-xs-12 action-text">
													Rename Table
												</div>
											</div>
										</div>
										<div class="col-xs-2 action-widget border-right" data-toggle="modal" data-target="#deleteTable">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-trash"></span>
												</div>
												<div class="col-xs-12 action-text">
													Delete Table
												</div>
											</div>
										</div>										
									</div>
								</div>
							</div>
						</div>
					</div>
					<div id="content">
						<div class="col-xs-12">
							<div id="notification">
<% if(errorNotification != null && !errorNotification.isEmpty()) { out.print(errorNotification); }%>
							</div>
						</div>
<%
if(dbname != null && !dbname.isEmpty() && tname != null && !tname.isEmpty())
{
	List<String> columns = new ArrayList<String>();
	List<String> data_types = new ArrayList<String>();
	
	db = new JasperDb("information_schema",uname,pass);
	if(db.getConnectionResult().isError())
	{
		response.sendRedirect("home.jsp");
	}
	QueryResult qr = db.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+dbname+"\" and TABLE_NAME = \""+tname+"\"");
	if(!qr.isError())
	{
%>
						<div class="col-xs-12">
							<div  class="col-xs-12 table-content">
								<table class="table">
									<tr>
<%
		ResultSet rs = qr.getResult();
		if (!rs.isBeforeFirst() ) {    
		    response.sendRedirect("table.jsp?db="+dbname); 
		}
		while(rs.next())
		{
			String name = rs.getString("COLUMN_NAME");
			String type = rs.getString("DATA_TYPE");
			String nullable = rs.getString("IS_NULLABLE");
			columns.add(name);
			data_types.add(type);
%>				
										<th><% out.print(name); %></th>
						
<%		} %>
										<th></th>
										<th></th>
										</tr>
										<tbody>
<%
		rs.close();
		db.close();
	}
	db = new JasperDb(dbname,uname,pass);
	if(db.getConnectionResult().isError())
	{
		response.sendRedirect("home.jsp");
	}
	qr = db.executeQuery("SELECT * FROM "+tname);
	if(!qr.isError())
	{
		ResultSet rs = qr.getResult();
		if(rs.isBeforeFirst())
		{
			while(rs.next())
			{
%>
										<tr>
<%
				Iterator itr = columns.iterator();
				Iterator itr2 = data_types.iterator();
				String where_clause = "";
				boolean is_null = false;
				String column =null;
				String type =null;
				String val =null;
				while(itr.hasNext())
				{
					column = (String)itr.next();
					type = (String)itr2.next();
					val = rs.getString(column);
					is_null = rs.wasNull();
					if(is_null)
					{
						where_clause += column+" IS NULL";
					} 
					else if(type.equals("tinyint"))
					{
						where_clause += column+"="+val;
					}
					else
					{
						where_clause += column+"='"+val+"'";
					}
					
					if(itr.hasNext())
					{
						where_clause += " and ";
					}
					
					if(is_null)
						out.println("<td class='table-data-value' id='"+column+"'>NULL</td>");
					else
						out.println("<td class='table-data-value' id='"+column+"'>"+val+"</td>");
				}
				long len = where_clause.length();
				String convData = "";
				char ch ;
				int temp;
				String str = "";
				for(int i = 0;i<len;i++)
				{
					ch = where_clause.charAt(i);
					temp = (int)ch;
					str = Integer.toString(temp);
					if(str.length() == 2)
						str = "0" + str;
					else if(str.length() == 1)
						str = "00" + str;
					convData += str;
				}
%>
											<td class="table-content-action">
												<div title="Edit" id="<% out.print(convData); %>" data-toggle="modal" data-target="#editTableContent" onClick="updateEditForm(this)">
													<div class="table-content-action-icon">
														<span class="glyphicon glyphicon-pencil"></span>
													</div>
												</div>
											</td>
											<td class="table-content-action">
												<a title="Delete" href="deleteInTable?<% out.print("db="+dbname+"&table="+tname+"&data="+convData); %>">
													<div class="table-content-action-icon">
														<span class="glyphicon glyphicon-trash"></span>
													</div>
												</a>
											</td>
											
										</tr>
<%
			}
		}
		else{
			isTableEmpty = true;
		}
		rs.close();
		db.close();
	}
	
}
%>
									</tbody>
								</table>
							</div>
						</div>
						<div class="modal fade" id="deleteTable" role="dialog">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Delete <b><% out.print(dbname+"."+tname); %></b></h4>
									</div>
									<div class="modal-body">
										<div class="alert alert-warning"><span class="glyphicon glyphicon-warning-sign"></span> &nbsp;This Action cannot be Undone.</div>
									</div>
									<div class="modal-footer">
										<form class="form-horizontal" action="deleteTable" method="POST">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden" value="<% out.print(tname); %>" name="table">
												    <input type="submit" value="Delete" class="btn btn-default col-xs-12">
												</div>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						
<%
String tableForInserting = "";
db = new JasperDb("information_schema",uname,pass);
if(db.getConnectionResult().isError())
{
	session.setAttribute("message", "<div class='alert alert-danger'>Error in Connecting to Database information_schema</div>");
	response.sendRedirect("home.jsp");
}
QueryResult qr = db.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+dbname+"\" and TABLE_NAME = \""+tname+"\"");
if(!qr.isError())
{
	tableForInserting += "<table class='col-xs-12'>";
	ResultSet rs = qr.getResult();
	while(rs.next())
	{
		String name = rs.getString("COLUMN_NAME");
		String is_nullable = rs.getString("IS_NULLABLE");
		String col_type = rs.getString("COLUMN_TYPE");
		String data_type = rs.getString("DATA_TYPE");
		tableForInserting += "<tr>";
		tableForInserting += "<td><label for='" + name + "'> " + name + "</label></td>";
		tableForInserting += "<td><span class='col-type'> [ " + col_type + " ] </span></td>";
		String placeHolder = null;
		String required = "";
		if (is_nullable.equals("NO")) {placeHolder = "Can't be empty";} else { placeHolder = "can be empty";}
		if (is_nullable.equals("NO")) {required = "required";}
		
		if (data_type.equals("date")) {
			tableForInserting += "<td><input type='date' name='"+name+"' id='"+name+"' placeholder=\"" +placeHolder+ "\" " +required+ " ></td>";
			
		} else if (data_type.equals("timestamp")) {
			tableForInserting += "<td><input type='datetime-local' name='"+name+"' id='"+name+"' placeholder=\"" +placeHolder+ "\" " +required+ " ></td>";
		} else {
		tableForInserting += "<td><input type='text' name='"+name+"' id='"+name+"' placeholder=\"" +placeHolder+ "\" " +required+ " ></td>";
		}
		tableForInserting += "</tr>";
	}
	tableForInserting += "</table>";
	rs.close();
	db.close();
}
%>
						
						<div class="modal fade" id="insertInTable" role="dialog">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Insert</h4>
									</div>
									<form class="form-horizontal" action="insertInTable" method="POST" id="insert-into-table-form">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden" value="<% out.print(tname); %>" name="table">
												</div>
											</div>
											<div class="form-group">
												<div class="col-xs-12">
													
												<% out.print(tableForInserting); %>
													
												</div>
											</div>
											<div class="modal-footer">
												<div class="form-group">
													<div class="col-xs-12">
														<input type="submit" value="Insert" class="btn btn-default">
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
						
						<div class="modal fade" id="editTableContent" role="dialog">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Update</h4>
									</div>
									<form class="form-horizontal" action="updateInTable" method="POST" id="update-into-table-form">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden" value="<% out.print(tname); %>" name="tname">
													<input type="hidden" name="data" id="where-clause">
												</div>
											</div>
											<div class="form-group">
												<div class="col-xs-12">
														
													<% out.print(tableForInserting); %>
														
												</div>
											</div>
											<div class="modal-footer">
												<div class="form-group">
													<div class="col-xs-12">
														<input type="submit" value="Update" class="btn btn-default">
													</div>
												</div>
											</div>
										</div>
									</form>
								</div>
							</div>
						</div>
						
						<div class="modal fade" id="showStructure" role="dialog">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Table Structure</h4>
									</div>
									<div class="modal-body">
										<table class='table table-stripped col-xs-12'>
											<tr>
												<th>Field</th>
												<th>Type</th>
												<th>Null</th>
												<th>Key</th>
												<th>Default</th>
												<th>Extra</th>
											</tr>
										
<%
db = new JasperDb(dbname,uname,pass);
if(db.getConnectionResult().isError())
{
	session.setAttribute("message", "<div class='alert alert-danger'>Error in Connecting to Database "+dbname+"</div>");
	response.sendRedirect("home.jsp");
}
qr = db.executeQuery("DESC "+tname);
if(!qr.isError())
{
	ResultSet rs = qr.getResult();
	while(rs.next())
	{		
		String field = rs.getString("Field");
		String type = rs.getString("Type");
		String isNull = rs.getString("Null");
		String key = rs.getString("Key");
		String default_val = rs.getString("Default");
		String extra = rs.getString("Extra");
%>
											<tr>
											<td><% out.print(field); %></td>
											<td><% out.print(type); %></td>
											<td><% out.print(isNull); %></td>
											<td><% out.print(key); %></td>
											<td><% out.print(default_val); %></td>
											<td><% out.print(extra); %></td>
											</tr>
<%
	}
	rs.close();
	db.close();
}
%>
										</table>
									</div>
								</div>
							</div>
						</div>
						
						<div class="modal fade" id="renameTable" role="dialog">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Rename Table</h4>
									</div>
									<form class="form-horizontal" action="RenameTable" method="POST">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden"  name="old_table" value="<% out.print(tname); %>">
													<input id="rename-table-name" class="col-xs-12" type="text" placeholder="New Name" name="table" required>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<input type="submit" value="Rename" class="btn btn-default col-xs-12">
										</div>
									</form>
								</div>
							</div>
						</div>
						
					</div>
				</div>
			</div>
		</div>
	</div>
<%
	if(isTableEmpty)
	{
%>
	<script type="text/javascript">
		var notification_area = document.getElementById("notification");
		notification_area.innerHTML += "<div class=\"alert alert-warning\">Empty Table</div>";
	</script>
<%
	}
%>

	<script type="text/javascript">
		function updateEditForm(e)
		{
			$.each($(e).parent().parent().children("td.table-data-value"),function(key,value){
				$("#update-into-table-form").find("input#"+value.id)[0].value = value.innerHTML
			});
			$("#update-into-table-form").find("input")[2].value = e.id;
			console.log($("#update-into-table-form").find("input")[2]);
		}
	</script>
</body>
</html>
