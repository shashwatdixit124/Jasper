<%@ page import="java.sql.*,jasper.helper.*" %> 

<%
	String errorNotification = (String)session.getAttribute("message");
	session.removeAttribute("message");
	String uname = null;
	String pass = null;

	String dbname = null;
	dbname = request.getParameter("db");
	
	JasperCookie cookies = new JasperCookie(request,response);
	
	if(!cookies.exists("uname") || !cookies.exists("uname")){
		response.sendRedirect("index.jsp");
	}else if(dbname == null || dbname.isEmpty())
		response.sendRedirect("home.jsp");
	
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
										<a href="#">
											<div class="col-xs-2 action-widget border-right">
												<div class="row">
													<div class="col-xs-12 action-icon">
														<span class="glyphicon glyphicon-plus"></span>
													</div>
													<div class="col-xs-12 action-text">
														Create Table
													</div>
												</div>
											</div>
										</a>
										<div class="col-xs-2 action-widget border-right" data-toggle="modal" data-target="#deleteDatabase">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-trash"></span>
												</div>
												<div class="col-xs-12 action-text">
													Delete Database
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
if(dbname != null && !dbname.isEmpty())
{
	db = new JasperDb(dbname,uname,pass);
	if(db.getConnectionResult().isError())
	{
		response.sendRedirect("home.jsp");
	}
	QueryResult qr = db.executeQuery("SHOW TABLES");
	if(!qr.isError())
	{
%>
						<div class="col-xs-12">
							<div  id="table-list">
<%
		ResultSet rs = qr.getResult();
		while(rs.next())
		{
			String tname = rs.getString("Tables_in_"+dbname);
	
%>
					
							
									<div class ="col-xs-12 table-elem height-50" >
										<div class="row">
											<a href="tablecontent.jsp?db=<% out.print(dbname); %>&table=<% out.print(tname); %>">
												<div class="col-xs-12 col-sm-8 col-md-10 table-name">
													<% out.print(tname); %>
												</div>
											</a>
											<div class="col-xs-12 col-sm-4 col-md-2">
												<div class="row">
													<a href="#">
														<div class="col-xs-6 table-action border-right">
															<span class="glyphicon glyphicon-pencil"></span>
														</div>
													</a>
													<a href="#" data-toggle="modal" data-target="#deleteTable" onclick="deletehelp(this);" id="<% out.print(tname); %>">
														<div class="col-xs-6 table-action">
															<span class="glyphicon glyphicon-trash"></span>
														</div>
													</a>
												</div>
											</div>
										</div>
									</div> 
						
<%		} %>
							</div>
						</div>
<%
	}
} 
%>
						<div class="modal fade" id="deleteDatabase" role="dialog">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Delete <b><% out.print(dbname); %></b></h4>
									</div>
									<div class="modal-body">
										<div class="alert alert-warning">This Action cannot be Undone.</div>
									</div>
									<div class="modal-footer">
										<form class="form-horizontal" action="deleteDatabase" method="POST">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
												    <input type="submit" value="Delete" class="btn btn-default col-xs-12">
												</div>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						
						<div class="modal fade" id="deleteTable" role="dialog">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Delete <b><span id="delete-table-form-table-name">hi</span></b></h4>
									</div>
									<div class="modal-body">
										<div class="alert alert-warning">This Action cannot be Undone.</div>
									</div>
									<div class="modal-footer">
										<form class="form-horizontal" action="deleteTable" method="POST">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden" name="table" id="deletetable">
												    <input type="submit" value="Delete" class="btn btn-default col-xs-12">
												</div>
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
	</div>
	<script type="text/javascript">
	function deletehelp(e) {
		var tableName = document.getElementById("delete-table-form-table-name");
		tableName.innerHTML = e.id;
		var x = document.getElementById("deletetable");
		x.value = e.id;
	}
	
	</script>
</body>
</html>
