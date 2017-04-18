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
											<div class="col-xs-2 action-widget border-right" data-toggle="modal" data-target="#createTable">
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
						<div class="col-xs-12">
							<div id="notification">
<% if(errorNotification != null && !errorNotification.isEmpty()) { out.print(errorNotification); }%>
							</div>
						</div>
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
													<a title="Edit" href="#">
														<div class="col-xs-6 table-action border-right">
															<span class="glyphicon glyphicon-pencil"></span>
														</div>
													</a>
													<a title="Delete" href="#" data-toggle="modal" data-target="#deleteTable" onclick="deletehelp(this);" id="<% out.print(tname); %>">
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

						<div class="modal fade" id="createTable" role="dialog">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Create Table</h4>
									</div>
									<form class="form-horizontal" action="createTable" method="POST" id="create-table-form">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
												</div>
											</div>
											<div class="form-group">
												<div class="col-xs-12">

													<label for="table-name">Table Name : </label>
													<input type="text" placeholder="Ex: UsersTable" id="table-name" name="table" required>

												</div>
											</div>
											<div class="form-group">
												<div id="column-list" class="col-xs-12">

<table class="table table-stripped col-xs-12">
	<tr>
		<th>Name</th>
	    <th>Type</th>
	    <th>Length/Values</th>
	    <th>Default</th>
	    <th>Attributes</th>
	    <th><abbr title="Can be NULL if checked, NOT NULL if unchecked">Null</abbr></th>
	    <th>Index</th>
	    <th><abbr title="AUTO_INCREMENT">A_I</abbr></th>
	</tr>
	<tr class="ct-column">
		<td class="center">
			<input id="field_0_1" name="field_name" maxlength="64" class="textfield" title="Column" size="10" value="" type="text">
		</td>
		<td class="center">
			<select class="column_type" name="field_type" id="field_0_2">
				<option title="A 4-byte integer, signed range is -2,147,483,648 to 2,147,483,647, unsigned range is 0 to 4,294,967,295">INT</option>
				<option title="A variable-length (0-65,535) string, the effective maximum length is subject to the maximum row size">VARCHAR</option>
				<option title="A TEXT column with a maximum length of 65,535 (2^16 - 1) characters, stored with a two-byte prefix indicating the length of the value in bytes">TEXT</option>
				<option title="A date, supported range is 1000-01-01 to 9999-12-31">DATE</option>
				<optgroup label="Numeric">
					<option title="A 1-byte integer, signed range is -128 to 127, unsigned range is 0 to 255">TINYINT</option>
					<option title="A 2-byte integer, signed range is -32,768 to 32,767, unsigned range is 0 to 65,535">SMALLINT</option>
					<option title="A 3-byte integer, signed range is -8,388,608 to 8,388,607, unsigned range is 0 to 16,777,215">MEDIUMINT</option><option title="A 4-byte integer, signed range is -2,147,483,648 to 2,147,483,647, unsigned range is 0 to 4,294,967,295">INT</option>
					<option title="An 8-byte integer, signed range is -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807, unsigned range is 0 to 18,446,744,073,709,551,615">BIGINT</option>
					<option disabled="disabled">-</option>
					<option title="A fixed-point number (M, D) - the maximum number of digits (M) is 65 (default 10), the maximum number of decimals (D) is 30 (default 0)">DECIMAL</option>
					<option title="A small floating-point number, allowable values are -3.402823466E+38 to -1.175494351E-38, 0, and 1.175494351E-38 to 3.402823466E+38">FLOAT</option>
					<option title="A double-precision floating-point number, allowable values are -1.7976931348623157E+308 to -2.2250738585072014E-308, 0, and 2.2250738585072014E-308 to 1.7976931348623157E+308">DOUBLE</option>
					<option title="Synonym for DOUBLE (exception: in REAL_AS_FLOAT SQL mode it is a synonym for FLOAT)">REAL</option><option disabled="disabled">-</option>
					<option title="A bit-field type (M), storing M of bits per value (default is 1, maximum is 64)">BIT</option>
					<option title="A synonym for TINYINT(1), a value of zero is considered false, nonzero values are considered true">BOOLEAN</option>
					<option title="An alias for BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE">SERIAL</option>
				</optgroup>
				<optgroup label="Date and time">
					<option title="A date, supported range is 1000-01-01 to 9999-12-31">DATE</option>
					<option title="A date and time combination, supported range is 1000-01-01 00:00:00 to 9999-12-31 23:59:59">DATETIME</option>
					<option title="A timestamp, range is 1970-01-01 00:00:01 UTC to 2038-01-09 03:14:07 UTC, stored as the number of seconds since the epoch (1970-01-01 00:00:00 UTC)">TIMESTAMP</option>
					<option title="A time, range is -838:59:59 to 838:59:59">TIME</option>
					<option title="A year in four-digit (4, default) or two-digit (2) format, the allowable values are 70 (1970) to 69 (2069) or 1901 to 2155 and 0000">YEAR</option>
				</optgroup>
				<optgroup label="String">
					<option title="A fixed-length (0-255, default 1) string that is always right-padded with spaces to the specified length when stored">CHAR</option>
					<option title="A variable-length (0-65,535) string, the effective maximum length is subject to the maximum row size">VARCHAR</option>
					<option disabled="disabled">-</option>
					<option title="A TEXT column with a maximum length of 255 (2^8 - 1) characters, stored with a one-byte prefix indicating the length of the value in bytes">TINYTEXT</option>
					<option title="A TEXT column with a maximum length of 65,535 (2^16 - 1) characters, stored with a two-byte prefix indicating the length of the value in bytes">TEXT</option>
					<option title="A TEXT column with a maximum length of 16,777,215 (2^24 - 1) characters, stored with a three-byte prefix indicating the length of the value in bytes">MEDIUMTEXT</option>
					<option title="A TEXT column with a maximum length of 4,294,967,295 or 4GiB (2^32 - 1) characters, stored with a four-byte prefix indicating the length of the value in bytes">LONGTEXT</option>
					<option disabled="disabled">-</option>
					<option title="Similar to the CHAR type, but stores binary byte strings rather than non-binary character strings">BINARY</option>
					<option title="Similar to the VARCHAR type, but stores binary byte strings rather than non-binary character strings">VARBINARY</option>
					<option disabled="disabled">-</option>
					<option title="A BLOB column with a maximum length of 255 (2^8 - 1) bytes, stored with a one-byte prefix indicating the length of the value">TINYBLOB</option>
					<option title="A BLOB column with a maximum length of 16,777,215 (2^24 - 1) bytes, stored with a three-byte prefix indicating the length of the value">MEDIUMBLOB</option>
					<option title="A BLOB column with a maximum length of 65,535 (2^16 - 1) bytes, stored with a two-byte prefix indicating the length of the value">BLOB</option>
					<option title="A BLOB column with a maximum length of 4,294,967,295 or 4GiB (2^32 - 1) bytes, stored with a four-byte prefix indicating the length of the value">LONGBLOB</option>
					<option disabled="disabled">-</option>
					<option title="An enumeration, chosen from the list of up to 65,535 values or the special '' error value">ENUM</option><option title="A single value chosen from a set of up to 64 members">SET</option>
				</optgroup>
				<optgroup label="Spatial">
					<option title="A type that can store a geometry of any type">GEOMETRY</option>
					<option title="A point in 2-dimensional space">POINT</option>
					<option title="A curve with linear interpolation between points">LINESTRING</option>
					<option title="A polygon">POLYGON</option>
					<option title="A collection of points">MULTIPOINT</option>
					<option title="A collection of curves with linear interpolation between points">MULTILINESTRING</option>
					<option title="A collection of polygons">MULTIPOLYGON</option>
					<option title="A collection of geometry objects of any type">GEOMETRYCOLLECTION</option>
				</optgroup>
			</select>
		</td>
		<td class="center">
			<input id="field_0_3" name="field_length" size="8" value="" class="textfield" type="text">
		</td>
		<td class="center">
			<select name="field_default_type" id="field_0_4" class="default_type" onChange="default_input(this);">
				<option value="NONE" selected="selected">None</option>
	            <option value="USER_DEFINED">As defined:</option>
	            <option value="NULL">NULL</option>
	            <option value="CURRENT_TIMESTAMP">CURRENT_TIMESTAMP</option>
            </select>
			<input name="field_default_value" size="12" placeholder="Default Value" value="" class="textfield default_value" style="display: none;" type="text"  id="field_default_value">
		</td>
		<td class="center">
			<select style="width: 7em;" name="field_attribute" id="field_0_5">
				<option value="" selected="selected"></option>
	            <option value="BINARY">BINARY</option>
	            <option value="UNSIGNED">UNSIGNED</option>
	            <option value="UNSIGNED ZEROFILL">UNSIGNED ZEROFILL</option>
	            <option value="on update CURRENT_TIMESTAMP">on update CURRENT_TIMESTAMP</option>
            </select>
        </td>
		<td class="center">
			<input name="field_null" id="field_0_6" value="NULL0" class="allow_null" type="checkbox">
		</td>
	    <td class="center">
	    	<select name="field_key" id="field_0_7" data-index="">
		    	<option value="none_0">---</option>
			    <option value="primary_0" title="Primary">PRIMARY</option>
			    <option value="unique_0" title="Unique">UNIQUE</option>
			    <option value="index_0" title="Index">INDEX</option>
	            <option value="fulltext_0" title="Fulltext">FULLTEXT</option>
	        	<option value="spatial_0" title="Spatial">SPATIAL</option>
        	</select>
        </td>
		<td class="center">
			<input name="field_extra" id="field_0_8" value="AUTO_INCREMENT" type="checkbox">
		</td>
	</tr>
</table>

												</div>
											</div>
											<div class="modal-footer">
												<div class="form-group">
													<div class="col-xs-12">
														<input type="button" onClick="add_coloumn_to_table()" value="Add Column" class="btn btn-default btn-lg add-coloumn-btn">
														<input type="submit" value="Create" class="btn btn-default btn-lg">
													</div>
												</div>
											</div>
										</div>
									</form>									
								</div>
							</div>
						</div>
						
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
												    <input type="submit" value="Delete" class="btn btn-default btn-lg col-xs-12">
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
										<h4 class="modal-title">Delete <b><span id="delete-table-form-table-name"></span></b></h4>
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
												    <input type="submit" value="Delete" class="btn btn-default btn-lg col-xs-12">
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
	
	var null_counter = 0;
	var newCol = $(".ct-column").last().clone().addClass("hidden-column");
	null_counter = null_counter+1;
	newCol.find("#field_0_6")[0].value="NULL"+null_counter;
	console.log(newCol);
	console.log(newCol.find("#field_0_6"));
	newCol = newCol[0];
	newCol.style.display = "none";
	
	var hiddenCol = $(".ct-column").parent().append(newCol).children();
	
	
	function add_coloumn_to_table(){
		var hidden = $(".hidden-column").last().clone().removeClass("hidden-column");
		
		hidden.find("#field_0_6")[0].value="NULL"+null_counter;
		null_counter = null_counter+1;
		console.log(hidden);
		hidden = hidden[0];
		hidden.style.display = "";
		$(".ct-column").parent().append(hidden);
	}
	
	function default_input(e) {

		if(e.value == "USER_DEFINED")
			$(e).parent().children()[1].style.display = "";
		else
			$(e).parent().children()[1].style.display = "none";

	}
	
	</script>
</body>
</html>
