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
										<div class="col-xs-2 action-widget border-right" data-toggle="modal" data-target="#editStructureAlternate">
											<div class="row">
												<div class="col-xs-12 action-icon">
													<span class="glyphicon glyphicon-cog"></span>
												</div>
												<div class="col-xs-12 action-text">
													Edit Structure
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
List<String> columns = new ArrayList<String>();
List<String> data_types = new ArrayList<String>();

db = new JasperDb("information_schema",uname,pass);
if(db.getConnectionResult().isError())
{
	session.setAttribute("message", "<div class='alert alert-danger'>Error in Connecting to Database information_schema</div>");
	response.sendRedirect("home.jsp?db="+dbname);
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
						
<%	} %>
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
	session.setAttribute("message", "<div class='alert alert-danger'>Error in Connecting to Database "+dbname+"</div>");
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
	response.sendRedirect("home.jsp?db="+dbname);
}
qr = db.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+dbname+"\" and TABLE_NAME = \""+tname+"\"");
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
	response.sendRedirect("home.jsp?db="+dbname);
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
		if(rs.wasNull())
			default_val = null;
		String extra = rs.getString("Extra");
%>
											<tr>
											<td><% out.print(field); %></td>
											<td><% out.print(type); %></td>
											<td><% out.print(isNull); %></td>
											<td><% out.print(key); %></td>
											<td><% if(default_val!=null) out.print(default_val); else out.print("NULL"); %></td>
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
						
<%
db = new JasperDb("information_schema",uname,pass);
if(db.getConnectionResult().isError())
{
	session.setAttribute("message", "<div class='alert alert-danger'>Error in Connecting to Database information_schema</div>");
	response.sendRedirect("home.jsp?db="+dbname);
}
qr = db.executeQuery("select * from COLUMNS where TABLE_SCHEMA = \""+dbname+"\" and TABLE_NAME = \""+tname+"\"");

ArrayList<String> names = new ArrayList<String>();
ArrayList<String> types = new ArrayList<String>();
ArrayList<String> lengths = new ArrayList<String>();
ArrayList<String> default_type = new ArrayList<String>();
ArrayList<String> default_value = new ArrayList<String>();
ArrayList<String> attributes = new ArrayList<String>();
ArrayList<String> isNullable = new ArrayList<String>();
ArrayList<String> keys = new ArrayList<String>();
ArrayList<String> isAutoInc = new ArrayList<String>();

int colNo = 0;

String columnOptionList = "<select name=\"column_name\" id='selectColumnName'><option value='' selected='selected'>Select Column</option>";

if(!qr.isError())
{
	ResultSet rs = qr.getResult();
	while(rs.next())
	{
		String name = rs.getString("COLUMN_NAME");
		columnOptionList += "<option value='"+name+"'>"+name+"</option>";
		names.add(name);
		types.add(rs.getString("DATA_TYPE").toUpperCase());
		
		// finding length of column
		String col_type = rs.getString("COLUMN_TYPE");
		int index1 = col_type.indexOf('(');
		int index2 = col_type.indexOf(')');
		if(index1 != index2)
		{
			String length = col_type.substring(index1+1, index2);
			lengths.add(length);
		}
		else
		{
			lengths.add(null);
		}
		
		// finding default value
		String def = rs.getString("COLUMN_DEFAULT");
		if(rs.wasNull())
		{
			default_type.add("NULL");
			default_value.add(null);
		}
		else
		{
			if("CURRENT_TIMESTAMP".equals(def))
			{
				default_type.add("CURRENT_TIMESTAMP");
				default_value.add(null);
			}
			else
			{
				default_type.add("USER_DEFINED");
				default_value.add(def);
			}
		}
		
		// finding attributes
		String attr = rs.getString("EXTRA");
		if(rs.wasNull() || attr == null)
		{
			attributes.add("");
			isAutoInc.add(null);
		}
		else if("auto_increment".equals(attr))
		{
			attributes.add("");
			isAutoInc.add("AUTO_INCREMENT");
		}
		else
		{
			attributes.add(attr);
			isAutoInc.add(null);
		}
		
		String isNull = rs.getString("IS_NULLABLE");
		isNullable.add(isNull);
		
		// finding keys
		String key = rs.getString("COLUMN_KEY");
		if("PRI".equals(key))
		{
			keys.add("PRIMARY");
		}
		else if("MUL".equals(key))
		{
			keys.add("INDEX");
		}
		else if("UNI".equals(key))
		{
			keys.add("UNIQUE");
		}
		else
		{
			keys.add("none_0");
		}
		
		colNo++;
	}
	columnOptionList += "</select>";
}
db.close();
%>
						<div class="modal fade" id="editStructure" role="dialog">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Create Table</h4>
									</div>
									<form class="form-horizontal" action="editStructure" method="POST" id="edit-table-structure-form">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden" value="<% out.print(tname); %>" name="table">
												</div>
											</div>
											<div class="form-group">
												<div id="column-list" class="col-xs-12">
													<table class="table table-stripped col-xs-12" id="editStructureTable">
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
																	<option title="Empty String Literal" value="NONE" selected="selected">None</option>
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
																    <option value="PRIMARY" title="Primary">PRIMARY</option>
																    <option value="UNIQUE" title="Unique">UNIQUE</option>
																    <option value="INDEX" title="Index">INDEX</option>
													        	</select>
													        </td>
															<td class="center">
																<input name="field_extra" id="field_0_8" value="AI0" type="checkbox">
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
						
						<div class="modal fade" id="editStructureAlternate" role="dialog">
							<div class="modal-dialog modal-lg">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Rename Table</h4>
									</div>
									<form class="form-horizontal" action="#" method="POST" id="edit-table-structure-alt-form">
										<div class="modal-body">
											<div class="form-group">
												<div class="col-xs-12">
													<input type="hidden" value="<% out.print(dbname); %>" name="db">
													<input type="hidden"  name="old_table" value="<% out.print(tname); %>">
													<input id="edit-action" type="hidden" value="ADD" name="edit-action">
												</div>
											</div>
											<div class="form-group">
												<div class="col-xs-12">
													<ul class="nav nav-tabs" id="edit-form-nav-tabs">
													  <li onClick="addColumnClicked()" class="active"><a href="#">Add Column</a></li>
													  <li onClick="changeColumnClicked()"><a href="#">Change Column</a></li>
													  <li onClick="dropColumnClicked()"><a href="#">Drop Column</a></li>
													</ul>
												</div>
											</div>
											<div class="form-group" id="addColumnForm">
											<div class="select-column-div">Add Column After : <% out.print(columnOptionList); %></div>
											<div class="col-xs-12">
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
												<tr class="et-column">
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
															<option title="Empty String Literal" value="NONE" selected="selected">None</option>
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
														<input name="field_null" id="field_0_6" value="NULL" class="allow_null" type="checkbox">
													</td>
												    <td class="center">
												    	<select name="field_key" id="field_0_7" data-index="">
													    	<option value="none_0">---</option>
														    <option value="PRIMARY" title="Primary">PRIMARY</option>
														    <option value="UNIQUE" title="Unique">UNIQUE</option>
														    <option value="INDEX" title="Index">INDEX</option>
											        	</select>
											        </td>
													<td class="center">
														<input name="field_extra" id="field_0_8" value="AI" type="checkbox">
													</td>
												</tr>
												</table>
												</div>
											</div>
											<div class="form-group" id="changeColumnForm" style="display:none;">
												<div class="select-column-div">Select Column To Change : <% out.print(columnOptionList); %></div>
												<div class="col-xs-12">
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
												<tr class="et-column">
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
															<option title="Empty String Literal" value="NONE" selected="selected">None</option>
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
														<input name="field_null" id="field_0_6" value="NULL" class="allow_null" type="checkbox">
													</td>
												    <td class="center">
												    	<select name="field_key" id="field_0_7" data-index="">
													    	<option value="none_0">---</option>
														    <option value="PRIMARY" title="Primary">PRIMARY</option>
														    <option value="UNIQUE" title="Unique">UNIQUE</option>
														    <option value="INDEX" title="Index">INDEX</option>
											        	</select>
											        </td>
													<td class="center">
														<input name="field_extra" id="field_0_8" value="AI" type="checkbox">
													</td>
												</tr>
												</table>
												</div>
											</div>
											<div onClick="dropColumnClicked()" class="form-group" id="dropColumnForm" style="display:none;">
												<div class="select-column-div"> Select Column To Drop : <% out.print(columnOptionList); %></div>
											</div>
										</div>
										<div class="modal-footer">
											<input type="submit" value="Submit" class="btn btn-default btn-lg">
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
		}
		
		var first_col = null;
		var null_counter = 0;

<%

int col_counter = 1;

out.print("\n\n// Setting column 1 \n\n");
out.print("first_col = $(\".ct-column\").last();\n");
out.print("first_col.find(\"#field_0_1\")[0].value=\""+names.get(0)+"\";\n");
if(lengths.get(0)!=null)
	out.print("first_col.find(\"#field_0_3\")[0].value=\""+lengths.get(0)+"\";\n");
if(isNullable.get(0).equals("YES"))
	out.print("first_col.find(\"#field_0_6\")[0].checked=\"checked\";\n");
if(isAutoInc.get(0)!=null)
	out.print("first_col.find(\"#field_0_8\")[0].checked=\"checked\";\n");
out.print("\n$.each(first_col.find(\"#field_0_2\").find(\"option\"),function(key,value){if(value.innerHTML == \""+types.get(0)+"\")value.selected=\"selected\";});");
out.print("\n$.each(first_col.find(\"#field_0_4\").find(\"option\"),function(key,value){if(value.value == \""+default_type.get(0)+"\")value.selected=\"selected\";});");
if(default_type.get(0).equals("USER_DEFINED"))
{
	out.print("first_col.find(\"#field_0_4\").next()[0].style.display=\"\";");
	out.print("first_col.find(\"#field_0_4\").next()[0].value=\""+default_value.get(0)+"\";");
}
out.print("\n$.each(first_col.find(\"#field_0_5\").find(\"option\"),function(key,value){if(value.value == \""+attributes.get(0)+"\")value.selected=\"selected\";});");
out.print("\n$.each(first_col.find(\"#field_0_7\").find(\"option\"),function(key,value){if(value.value == \""+keys.get(0)+"\")value.selected=\"selected\";});");

%>

// creating hidden column

var newCol = $(".ct-column").last().clone().addClass("hidden-column");

// Setting hidden column

null_counter = null_counter+1;
newCol.find("#field_0_1")[0].value="";
newCol.find("#field_0_2").find("option").first()[0].checked="checked";
newCol.find("#field_0_3")[0].value="";
newCol.find("#field_0_4").find("option").first()[0].checked="checked";
newCol.find("#field_0_5").find("option").first()[0].checked="checked";
newCol.find("#field_0_6")[0].value="NULL"+null_counter;
newCol.find("#field_0_6")[0].checked="";
newCol.find("#field_0_7").find("option").first()[0].checked="checked";
newCol.find("#field_0_8")[0].value="AI"+null_counter;
newCol.find("#field_0_8")[0].checked="";
newCol = newCol[0];
newCol.style.display = "none";
$(".ct-column").parent().append(newCol);

var hidden_col = null;
<%
while(col_counter < colNo)
{	
%>
	
	null_counter = null_counter+1;

<%
	out.print("\n\n// Setting column "+(col_counter+1)+" \n\n");
	out.print("hidden_col = $(\".hidden-column\").last().clone().removeClass(\"hidden-column\");\n");
	out.print("hidden_col.find(\"#field_0_6\")[0].value=\"NULL\"+null_counter;\n");
	out.print("hidden_col.find(\"#field_0_8\")[0].value=\"AI\"+null_counter;\n");

	out.print("hidden_col.find(\"#field_0_1\")[0].value=\""+names.get(col_counter)+"\";\n");

	if(lengths.get(col_counter)!=null)
		out.print("hidden_col.find(\"#field_0_3\")[0].value=\""+lengths.get(col_counter)+"\";\n");

	if(isNullable.get(col_counter).equals("YES"))
		out.print("hidden_col.find(\"#field_0_6\")[0].checked=\"checked\";\n");

	if(isAutoInc.get(col_counter)!=null)
		out.print("hidden_col.find(\"#field_0_8\")[0].checked=\"checked\";\n");

	out.print("\n$.each(hidden_col.find(\"#field_0_2\").find(\"option\"),function(key,value){if(value.innerHTML == \""+types.get(col_counter)+"\")value.selected=\"selected\";});");
	out.print("\n$.each(hidden_col.find(\"#field_0_4\").find(\"option\"),function(key,value){if(value.value == \""+default_type.get(col_counter)+"\")value.selected=\"selected\";});");
	if(default_type.get(col_counter).equals("USER_DEFINED"))
	{
		out.print("\nhidden_col.find(\"#field_0_4\").next()[0].style.display=\"\";");
		out.print("\nhidden_col.find(\"#field_0_4\").next()[0].value=\""+default_value.get(col_counter)+"\";");
	}
	out.print("\n$.each(hidden_col.find(\"#field_0_5\").find(\"option\"),function(key,value){if(value.value == \""+attributes.get(col_counter)+"\")value.selected=\"selected\";});");
	out.print("\n$.each(hidden_col.find(\"#field_0_7\").find(\"option\"),function(key,value){if(value.value == \""+keys.get(col_counter)+"\")value.selected=\"selected\";});");
	
%>

hidden_col = hidden_col[0];
hidden_col.style.display = "";
$(".ct-column").parent().append(hidden_col);

<%
	col_counter++;
}
%>		
		function add_coloumn_to_table(){
			var hidden = $(".hidden-column").last().clone().removeClass("hidden-column");
			null_counter = null_counter+1;
			hidden.find("#field_0_6")[0].value="NULL"+null_counter;
			hidden.find("#field_0_8")[0].value="AI"+null_counter;
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
		
		function addColumnClicked(){
			$("#addColumnForm")[0].style.display = "";
			$("#changeColumnForm")[0].style.display = "none";
			$("#dropColumnForm")[0].style.display = "none";
			$("#edit-form-nav-tabs").children().first().addClass("active");
			$("#edit-form-nav-tabs").children().first().next().removeClass("active");
			$("#edit-form-nav-tabs").children().last().removeClass("active");
		}
		function changeColumnClicked(){
			$("#addColumnForm")[0].style.display = "none";
			$("#changeColumnForm")[0].style.display = "";
			$("#dropColumnForm")[0].style.display = "none";
			$("#edit-form-nav-tabs").children().first().removeClass("active");
			$("#edit-form-nav-tabs").children().first().next().addClass("active");
			$("#edit-form-nav-tabs").children().last().removeClass("active");
		}
		function dropColumnClicked(){
			$("#addColumnForm")[0].style.display = "none";
			$("#changeColumnForm")[0].style.display = "none";
			$("#dropColumnForm")[0].style.display = "";
			$("#edit-form-nav-tabs").children().first().removeClass("active");
			$("#edit-form-nav-tabs").children().first().next().removeClass("active");
			$("#edit-form-nav-tabs").children().last().addClass("active");
		}
		
		$(document).ready(function(){
			$("#changeColumnForm").children().first().change(function(){
				$.each($("#editStructureTable").find(".ct-column"),function(key,value){
					if($(value).find("#field_0_1").val() == $("#changeColumnForm").find("#selectColumnName").val()){
						var column = $("#changeColumnForm");
						value = $(value);
						column.find("#field_0_1").val(value.find("#field_0_1").val());
						column.find("#field_0_2").val(value.find("#field_0_2").val());
						column.find("#field_0_3").val(value.find("#field_0_3").val());
						column.find("#field_0_4").val(value.find("#field_0_4").val());
						column.find("#field_0_4").next().val(value.find("#field_0_4").next().val());
						default_input(column.find("#field_0_4")[0]);
						column.find("#field_0_5").val(value.find("#field_0_5").val());
						column.find("#field_0_6").prop("checked",value.find("#field_0_6").prop("checked"));
						column.find("#field_0_7").val(value.find("#field_0_7").val());
						column.find("#field_0_8").prop("checked",value.find("#field_0_8").prop("checked"));		
					}
				});
			});
		});
		
	</script>
</body>
</html>
