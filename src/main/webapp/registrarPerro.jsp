<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String usuario = "";
try { // Control de sesión
    usuario = session.getAttribute("attributo2").toString();
    String acceso = session.getAttribute("attributo1").toString();
    if (!acceso.equals("1") && !acceso.equals("2")) {
        response.sendRedirect("nouser.jsp");
    }
} catch (Exception e) {
    response.sendRedirect("nouser.jsp");
}
String usuarioId = session.getAttribute("attributo1").toString();

if (request.getMethod().equals("POST")) {
    String nombre = request.getParameter("nombre");
    String raza = request.getParameter("raza");
    String fechaNacimiento = request.getParameter("fechaNacimiento");
    
    String url = "jdbc:mysql://localhost:3306/db?serverTimezone=UTC";
    String usuarioDB = "usu";
    String passwordDB = "pass";
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, passwordDB);
        String sql = "INSERT INTO Perros (id_dueño, nombre, raza, fechaNacimiento) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(usuarioId));
        pstmt.setString(2, nombre);
        pstmt.setString(3, raza);
        pstmt.setString(4, fechaNacimiento);
        pstmt.executeUpdate();
        out.println("<h2>Perro registrado exitosamente</h2>");
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
        e.printStackTrace();
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passing Dogs - Registrar Perro</title>
    <link rel="stylesheet" href="common/general.css">
</head>
<body>
    <h2>Registrar un Nuevo Perro</h2>
    <form method="post">
        <label for="nombre">Nombre del Perro:</label>
        <input type="text" id="nombre" name="nombre" required>
        <br><br>
        <label for="raza">Raza del Perro:</label>
        <input type="text" id="raza" name="raza" required>
        <br><br>
        <label for="fechaNacimiento">Fecha de Nacimiento:</label>
        <input type="date" id="fechaNacimiento" name="fechaNacimiento" required>
        <br><br>
        <input type="submit" value="Registrar">
    </form>
    <br><br>
    <a href="bienvenido.jsp">Volver al menú principal</a>
</body>
</html>
