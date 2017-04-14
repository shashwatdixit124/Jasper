<%@ page import="java.sql.*,jasper.helper.*" %> 

<html>
<head>
<title>Jasper</title>
<link rel="stylesheet" href="/Jasper/css/bootstrap.min.css" type="text/css">
<style>
h1{
	text-align: center;
}
@media(min-width:768px)
{
	body{
		background-color: #f9f9f9;
	}
	#center-div{
		box-shadow: 0px 0px 5px rgb(200,200,200);
		background-color: #fff;
	}
}
#form-internal{
	padding: 30px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-xs-12 col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3" id="center-div">
				<div class="row">
					<div id="form-internal">
						<h1>Jasper</h1>
				
<% 
if(request.getMethod().equals("POST")) 
{
	String uname = request.getParameter("username");
	String pass = request.getParameter("password");
	JasperDb db = new JasperDb("",uname,pass);
	ConnectionResult cr = db.getConnectionResult();
	if(!cr.isError())
	{
		JasperCookie.addCookieToResponse("uname",uname,response);
		JasperCookie.addCookieToResponse("pass",pass,response);
		response.sendRedirect("home.jsp");
	}
	
	if(cr.isConnectionError()){
%>

						<div class="alert alert-danger"> Wrong Username or Password ! </div>
			
<%
	}
	else if(cr.isJDBCError()){
%>

						<div class="alert alert-danger"> Cannot Connect to JDBC </div>
		
<%		
	}	
	db.close();
}
%>

						 <form class="form-horizontal" action="./" method="POST">
						  <div class="form-group">
						    <label class="control-label col-sm-2" for="uname" >Username:</label>
						    <div class="col-sm-10">
						      <input type="text" class="form-control" id="uname" placeholder="Enter username" name="username">
						    </div>
						  </div>
						  <div class="form-group">
						    <label class="control-label col-sm-2" for="pwd">Password:</label>
						    <div class="col-sm-10">
						      <input type="password" class="form-control" id="pwd" placeholder="Enter password" name="password">
						    </div>
						  </div>
						  <div class="form-group">
						    <div class="col-sm-offset-2 col-sm-10">
						      <button type="submit" class="btn btn-default">Submit</button>
						    </div>
						  </div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>