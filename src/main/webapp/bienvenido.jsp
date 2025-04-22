<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
String usuario = "";
try { 
    //AQUI VA EL CONTROL DE SESION
    usuario = session.getAttribute("attributo2").toString();
    String acceso = session.getAttribute("attributo1").toString();

    // Comprobamos si el acceso (id del usuario) es menor que 1
    if (Integer.parseInt(acceso) < 1) {
        response.sendRedirect("nouser.jsp");
    }
} catch (Exception e) {
    // Si ocurre cualquier excepción, redirigir al usuario a la página 'nouser.jsp'
    response.sendRedirect("nouser.jsp");
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Passing Dogs</title>
<link rel="stylesheet" href="common/general.css">
</head>
<body>
	<h1>Bienvenido <%=usuario%></h1>
	<hr />
	<a href="registrarPerro.jsp">Registrar perro</a>
	<br>
	<br>
	<a href="paseos.jsp">Contratar un servicio de paseo</a>
	<br />
	<br />
	<a href="ver_paseos.jsp">Ver Paseos</a>
	<br>
	<br>
	<a href="cerrarsesion.jsp">Cerrar sesión</a>
</body>
</html>