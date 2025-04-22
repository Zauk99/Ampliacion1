<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tus Paseos</title>
<link rel="stylesheet" href="common/general.css">
</head>
<body>
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

	<h2>Tus Paseos</h2>

	<div class="tabla-centrada">
		<%
		String url = "jdbc:mysql://localhost:3306/PassingDogs?serverTimezone=UTC";
		String usuarioDB = "iwuegfuewbf";
		String passwordDB = "oihuwhgfuwhfushfshf8w";

		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			int idUsuario = Integer.parseInt(session.getAttribute("attributo1").toString());

			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(url, usuarioDB, passwordDB);

			String sql = "SELECT Perros.nombre AS nombre_perro, Paseos.fecha, Tramos.HoraInicio, Tramos.HoraFin "
			+ "FROM Paseos " + "JOIN Perros ON Paseos.id_perro = Perros.id "
			+ "JOIN Tramos ON Paseos.id_tramo = Tramos.id " + "WHERE Perros.id_dueño = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, idUsuario);
			rs = stmt.executeQuery();

			boolean hayResultados = false;

			if (rs.isBeforeFirst()) {
				hayResultados = true;
		%>
		<table class="tabla-centrada">
			<tr>
				<th>Nombre del Perro</th>
				<th>Fecha</th>
				<th>Hora de Inicio</th>
				<th>Hora de Fin</th>
			</tr>
			<%
			while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("nombre_perro")%></td>
				<td><%=rs.getDate("fecha")%></td>
				<td><%=rs.getString("HoraInicio")%></td>
				<td><%=rs.getString("HoraFin")%></td>
			</tr>
			<%
			}
			%>
		</table>
		<%
		}

		if (!hayResultados) {
		%>
		<div class="mensaje">Aún no has solicitado ningún paseo.</div>
		<%
		}

		} catch (Exception e) {
		%>
		<div class="mensaje">
			Error al obtener los paseos:
			<%=e.getMessage()%></div>
		<%
		} finally {
		try {
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
		}
		try {
			if (stmt != null)
				stmt.close();
		} catch (SQLException e) {
		}
		try {
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
		}
		}
		%>
	</div>

	<br>
	<br>
	<a href="bienvenido.jsp">Volver al menú principal</a>

</body>
</html>
