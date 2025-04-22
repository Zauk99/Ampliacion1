<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
String usuario = "";
try { 
    //AQUI VA EL CONTROL DE SESION
    usuario = session.getAttribute("attributo2").toString();
    String acceso = session.getAttribute("attributo1").toString();

    // Comprobamos si el acceso (id del usuario) es menor que 1
    if (!acceso.equals("1")) {
        response.sendRedirect("nouser.jsp");
    }
} catch (Exception e) {
    // Si ocurre cualquier excepción, redirigir al usuario a la página 'nouser.jsp'
    response.sendRedirect("nouser.jsp");
}


// Variables de conexión
	String url = "jdbc:mysql://localhost:3306/PassingDogs?serverTimezone=UTC";
		String usuarioDB = "iwuegfuewbf";
		String passwordDB = "oihuwhgfuwhfushfshf8w";
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Passing Dogs - Registro de Paseo</title>
    <link rel="stylesheet" href="common/general.css">
</head>
<body>
    <h2>Registro de Paseo para tu Perro</h2>
    
    <form action="procesar_paseo.jsp" method="post">
        <label for="perro">Perro:</label>
        <select id="perro" name="perro" required>
            <option value="">Selecciona un Perro</option>
            <%
                try {
                    // Conectar a la base de datos y obtener los perros del usuario
                    conn = DriverManager.getConnection(url, usuarioDB, passwordDB);
                    String sql = "SELECT id, nombre FROM Perros WHERE id_dueño = (SELECT id FROM Usuarios WHERE usuario = ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, usuario); // Filtrar por el nombre de usuario
                    rs = pstmt.executeQuery();

                    // Llenar el desplegable con los perros registrados
                    while (rs.next()) {
                        int idPerro = rs.getInt("id");
                        String nombrePerro = rs.getString("nombre");
            %>
                <option value="<%= idPerro %>"><%= nombrePerro %></option>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<h2>Error al cargar los perros: " + e.getMessage() + "</h2>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </select><br><br>
        
        <label for="fecha">Fecha del Paseo:</label>
        <input type="date" id="fecha" name="fecha" required><br><br>
        
        <label for="hora_inicio">Hora de Inicio:</label>
        <input type="time" id="HoraInicio" name="HoraInicio" required><br><br>
        
        <label for="hora_fin">Hora de Fin:</label>
        <input type="time" id="HoraFin" name="HoraFin" required><br><br>
        
        <input type="submit" value="Registrar Paseo">
    </form>
    
    <br>
    <br>
    <a href="bienvenido.jsp">Volver al menú principal</a>
</body>
</html>
