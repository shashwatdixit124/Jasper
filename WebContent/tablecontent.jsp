<%@ page import="java.sql.*,jasper.helper.*,java.util.*" %> 

<%
	String errorNotification = null;
	String uname = null;
	String pass = null;

	String dbname = null;
	dbname = request.getParameter("db");
	String tname = null;
	tname = request.getParameter("table");
	
	JasperCookie cookies = new JasperCookie(request,response);
	
	if(!cookies.exists("uname") || !cookies.exists("uname")){
		response.sendRedirect("index.jsp");
	}else if(dbname == null || dbname.isEmpty())
		response.sendRedirect("home.jsp");
	else if(tname == null || tname.isEmpty())
		response.sendRedirect("table.jsp?db="+dbname);
	
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
							<a href="logout.jsp">
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
<% if(errorNotification != null && !errorNotification.isEmpty()) {%>
						<div class="col-xs-12">
							<div id="notification">
								<% out.print(errorNotification); %>
							</div>
						</div>
					
<% } %>
<%
if(dbname != null && !dbname.isEmpty() && tname != null && !tname.isEmpty())
{
	List<String> columns = new ArrayList<String>();
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
								<table class="table table-stripped">
									<tr>
<%
		ResultSet rs = qr.getResult();
		while(rs.next())
		{
			String name = rs.getString("COLUMN_NAME");
			columns.add(name);
%>				
										<th><% out.print(name); %></th>
						
<%		} %>
										<th></th>
										<th></th>
										</tr>
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
		while(rs.next())
		{
%>
										<tr>
<%
			Iterator itr=columns.iterator();
			while(itr.hasNext())
			{
				String column = (String)itr.next();
				String val = rs.getString(column);
				out.println("<td>"+val+"</td>");
			}
%>
										<td class="table-content-action border-right"><span class="glyphicon glyphicon-pencil"></span></td>
										<td class="table-content-action"><span class="glyphicon glyphicon-trash"></span></td>
										</tr>
<%
		}
		rs.close();
		db.close();
	}
	
}
%>
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
										<div class="alert alert-danger">This Action cannot be Undone.</div>
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
						<div class="modal fade" id="insertInTable" role="dialog">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Insert</h4>
									</div>
									<form class="form-horizontal" action="InsertInTable" method="POST">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden" value="<% out.print(tname); %>" name="tname">
												
												<% 	List<String> columns = new ArrayList<String>();
														db = new JasperDb("information_schema",uname,pass);
														if(db.getConnectionResult().isError())
														{
															response.sendRedirect("home.jsp");
														}
														QueryResult qr = db.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+dbname+"\" and TABLE_NAME = \""+tname+"\"");
														if(!qr.isError())
														{
															
															ResultSet rs = qr.getResult();
															while(rs.next())
															{
																String name = rs.getString("COLUMN_NAME");
																String is_nullable = rs.getString("IS_NULLABLE");
																columns.add(name);							
														%>		
															<label for="<% out.print(name); %>"><% out.print(name); %>: </label>
															<input type="text" name="<% out.print(name); %>" id="<% out.print(name); %>" placeholder="<%if (is_nullable.equals("NO")) {out.print("Can't be empty");} else {out.print("can be empty");}  %>" <% if (is_nullable.equals("NO")) {out.print("required");} else {out.print("required");}  %>>		
														
														<% 					
															} 
															rs.close();
															db.close();
														}
														
													
										%>			
													
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<input type="submit" value="Insert" class="btn btn-default col-xs-12">
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
	<script type="text/javascript" src="script.js"></script>
</body>
</html>
