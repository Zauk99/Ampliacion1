<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<html>
<%
session.invalidate();
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Cerrar sesión</title>
<link rel="stylesheet" href="common/general.css">
</head>
<body>
<h1>Su sesión se ha cerrado correctamente.</h1>
<br/>
<a href="index.jsp">Iniciar sesión</a>
</body>
</html>