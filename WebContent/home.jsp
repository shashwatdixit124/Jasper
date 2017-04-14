<%@ page import="java.sql.*" %> 

<%
	boolean uname_exists = false;
	boolean pass_exists = false;
	String uname = null;
	String pass = null;
	Cookie cookie = null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	if(cookies != null)
	{
		for (int i = 0; i < cookies.length; i++){
			cookie = cookies[i];
			if(!uname_exists && (cookie.getName( )).compareTo("uname") == 0 ){
				uname_exists = true;
				uname = cookie.getValue();
			}
			if(!pass_exists && (cookie.getName( )).compareTo("pass") == 0 ){
				pass_exists = true;
				pass = cookie.getValue();
			}
		}
		
		if(!uname_exists || !pass_exists)
		{
			response.sendRedirect("index.jsp");
		}
		
	}
	else
	{
		response.sendRedirect("index.jsp");
	}
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
Connection conn = null;
Statement stmt = null;
try{
   
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost/", uname, pass);
	stmt = conn.createStatement();
	String query = "SHOW DATABASES";
	ResultSet rs = stmt.executeQuery(query);
	while(rs.next())
	{
		String db = rs.getString("Database");
%>
							<h4 class="col-xs-12 height-30 db"><% out.print(db); %></h4>
<%
	}
}catch(SQLException se){
	
}finally{
	try{
		if(stmt!=null)
			stmt.close();
	}catch(SQLException se){
		se.printStackTrace();
	}
	try{
		if(conn!=null)
			conn.close();
	}catch(SQLException se){
		se.printStackTrace();
	}
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