<%@ page import="java.sql.*,jasper.helper.*" %> 

<%
	String errorNotification = null;
	String uname = null;
	String pass = null;
	JasperCookie cookies = new JasperCookie(request);
	
	if(!cookies.exists("uname") || !cookies.exists("uname")){
		response.sendRedirect("index.jsp");
	}
	
	uname = cookies.getValue("uname");
	pass = cookies.getValue("pass");
	
%>

<html>
<head>
<title>Jasper | Welcome</title>
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
							<h4 class="col-xs-12 height-30 db"><% out.print(data); %></h4>
<%
		}
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
			<div class="col-xs-12 col-md-9 col-lg-10" id="main-view">
				<div class="row">
				
<% if(errorNotification != null && !errorNotification.isEmpty()) {%>

					<div class="col-xs-12">
						<div id="notification">
							<div class="alert alert-danger"> <% out.print(errorNotification); %> </div>
						</div>
					</div>
					
<% } %>

					<div class="col-xs-12">
						<div  id="welcome-note">
							<h3>Welcome to Jasper</h3>
							<h5>New Way of handling your Databases</h5>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>