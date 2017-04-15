<%@ page import="java.sql.*,jasper.helper.*" %> 

<%
	String errorNotification = null;
	String uname = null;
	String pass = null;

	String dbname = null;
	dbname = request.getParameter("db");
	
	JasperCookie cookies = new JasperCookie(request);
	
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
</head>
<body>
	<div class="container-fluid">
		<div class="row">
		
			<!-- Side Bar for showing databases -->
			<div class="col-xs-12 col-md-3 col-lg-2" id="sidebar">
				<div class="row">
					<h1 class="height-70 margin-0" id="jasper">Jasper</h1>
					<div class="col-xs-12" id="db-list">
						<div class="row">
<%
JasperDb db = new JasperDb("",uname,pass);
ConnectionResult cr = db.getConnectionResult();
if(!cr.isError()){
	String query = "SHOW DATABASES";
	QueryResult qr = db.executeQuery(query);

	if(qr.isError())
		errorNotification = "Cannot Find Database List";
	else{
		ResultSet rs = qr.getResult();
		while(rs.next())
		{
			String data = rs.getString("Database");
%>
							<a href="home.jsp?db=<% out.print(data); %>" ><h4 class="col-xs-12 height-30 db"><% out.print(data); %></h4></a>
<%
		}
		rs.close();
	}
	db.close();
}
%>

						</div>
					</div>
					<div class="col-xs-12 " id="create-db-area">
						<button class="col-xs-12 btn btn-default" id="create-db-btn">Create</button>
					</div>
				</div>
			</div>
			
			<!-- Main View for  -->
			<div class="col-xs-12 col-md-9 col-md-offset-3 col-lg-10 col-lg-offset-2" id="main-view">
				<div class="row">
					<div class="col-xs-12 height-70" id="action-bar">
						<div class="container-fluid">
							<ul class="action-bar-item">
								<div class="row">
									<li class="col-xs-2"><a href="#">Create Table</a></li>
									<li class="col-xs-2"><a href="#">Drop Database</a></li>
									<li class="col-xs-2 col-xs-offset-6"><a href="#">Logout</a></li>
								</div>
							</ul>
						</div>
					</div>
					<div id="content">
<% if(errorNotification != null && !errorNotification.isEmpty()) {%>
						<div class="col-xs-12">
							<div id="notification">
								<div class="alert alert-danger"> <% out.print(errorNotification); %> </div>
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
					
							
									<div class ="col-xs-12 table height-50" >
										<div class="row">
											<a href="#">
												<div class="col-xs-12 col-sm-8 col-md-10 table-name">
													<% out.print(tname); %>
												</div>
											</a>
											<div class="col-xs-12 col-sm-4 col-md-2">
												<div class="row">
													<a href="#">
														<div class="col-xs-6 table-action">
															Edit
														</div>
													</a>
													<a href="#">
														<div class="col-xs-6 table-action">
															Delete
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
} else { 
%>
						<div class="col-xs-12">
							<div  id="welcome-note">
								<h3>Welcome to Jasper</h3>
								<h5>New Way of handling your Databases</h5>
							</div>
						</div>
<% } %>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>