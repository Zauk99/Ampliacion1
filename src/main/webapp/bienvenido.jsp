<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
//aquí pongo todo el código java que quiera que mi servidor ejecute.

String usuario = "";
try { //AQUI VA EL CONTROL DE SESION
	usuario = session.getAttribute("attributo2").toString();
	String acceso = session.getAttribute("attributo1").toString();
	if (!acceso.equals("1") && !acceso.equals("2"))
		response.sendRedirect("nouser.jsp");
} catch (Exception e) {
	response.sendRedirect("nouser.jsp");
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Passing Dogs</title>
<link rel="stylesheet" href="common/general.css">
</head>
<body>
	<h1>
		Bienvenido <%=usuario%></h1>
	<hr />
	<a href="registrarPerro.jsp">Registrar perro</a>
	<br>
	<br>
	<a href="paseos.jsp">Contratar un servicio de paseo</a>
	<br />
	<br />
	<a href="cerrarsesion.jsp">Cerrar sesión</a>
</body>
</html>