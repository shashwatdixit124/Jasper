<%@ page import="java.sql.*,jasper.helper.*" %> 

<%
	String errorNotification = null;
	String uname = null;
	String pass = null;
	
	JasperCookie cookies = new JasperCookie(request,response);
	
	if(!cookies.exists("uname") || !cookies.exists("uname")){
		response.sendRedirect("index.jsp");
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
							<a href="table.jsp?db=<% out.print(data); %>" ><h4 class="col-xs-12 height-30 db"><% out.print(data); %></h4></a>
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
										<div class="col-xs-2 action-widget border-bottom border-right"  data-toggle="modal" data-target="#createDatabase">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-plus"></span>
												</div>
												<div class="col-xs-12 action-text">
													Create Database
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
						<div class="col-xs-12">
							<div  id="welcome-note">
								<h3>Welcome to Jasper</h3>
								<h5>New Way of handling your Databases</h5>
							</div>
						</div>
						<div class="modal fade" id="createDatabase" role="dialog">
							<div class="modal-dialog modal-sm">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Create Database</h4>
									</div>
									<form class="form-horizontal" action="createDatabase" method="POST">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input class="col-xs-12" type="text" placeholder="Database name" name="db" required>
												</div>
											</div>
										</div>
										<div class="modal-footer">
											<input type="submit" value="Create" class="btn btn-default col-xs-12">
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
