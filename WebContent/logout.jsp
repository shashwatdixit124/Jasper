<%@ page import="jasper.helper.*" %> 
<%

JasperCookie cookies = new JasperCookie(request,response);
cookies.remove("uname");
cookies.remove("pass");
response.sendRedirect("index.jsp");

%>