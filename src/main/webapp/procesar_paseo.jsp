<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Obtener los parámetros del formulario
    String idPerro = request.getParameter("perro");
    String fecha = request.getParameter("fecha");
    String horaInicio = request.getParameter("HoraInicio");
    String horaFin = request.getParameter("HoraFin");

    // Verificar que los parámetros no sean nulos ni vacíos
    if (idPerro == null || fecha == null || horaInicio == null || horaFin == null ||
        idPerro.isEmpty() || fecha.isEmpty() || horaInicio.isEmpty() || horaFin.isEmpty()) {
        out.println("<h2>Error: Todos los campos deben ser completados.</h2>");
        return;
    }

    // Obtener el ID del usuario de la sesión
    String usuarioId = null;
    try {
        usuarioId = session.getAttribute("attributo1").toString();
    } catch (Exception e) {
        response.sendRedirect("nouser.jsp");
        return;  // Salir después de redirigir
    }

    // Conexión a la base de datos
    String url = "jdbc:mysql://localhost:3306/db?serverTimezone=UTC";
    String usuarioDB = "usu";
    String passwordDB = "pass";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Conectar a la base de datos
        conn = DriverManager.getConnection(url, usuarioDB, passwordDB);

        // Verificar que el perro seleccionado pertenece al usuario
        String sqlVerificarPerro = "SELECT id_dueño FROM Perros WHERE id = ?";
        pstmt = conn.prepareStatement(sqlVerificarPerro);
        pstmt.setInt(1, Integer.parseInt(idPerro));  // Convertir idPerro a entero
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int idDueño = rs.getInt("id_dueño");

            // Verificar si el perro pertenece al usuario
            if (idDueño != Integer.parseInt(usuarioId)) {
                out.println("<h2>Error: Este perro no te pertenece.</h2>");
                return;
            }
        } else {
            out.println("<h2>Error: No se encontró el perro con el ID proporcionado.</h2>");
            return;
        }

        // Verificar si ya existe el tramo con las horas proporcionadas
        String sqlVerificarTramo = "SELECT id FROM Tramos WHERE HoraInicio = ? AND HoraFin = ?";
        pstmt = conn.prepareStatement(sqlVerificarTramo);
        pstmt.setString(1, horaInicio);
        pstmt.setString(2, horaFin);
        rs = pstmt.executeQuery();

        int idTramo = -1;
        if (rs.next()) {
            // Si el tramo ya existe, obtener su id
            idTramo = rs.getInt("id");
        } else {
            // Si el tramo no existe, insertarlo
            String sqlInsertarTramo = "INSERT INTO Tramos (HoraInicio, HoraFin) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sqlInsertarTramo, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, horaInicio);
            pstmt.setString(2, horaFin);
            int filasInsertadas = pstmt.executeUpdate();

            if (filasInsertadas > 0) {
                // Obtener el id del nuevo tramo insertado
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    idTramo = rs.getInt(1); // El id generado
                }
            } else {
                out.println("<h2>Error al insertar el tramo de hora.</h2>");
                return;
            }
        }

        // Insertar el paseo en la base de datos, asociando el id_perro y el id_tramo
        String sqlInsertarPaseo = "INSERT INTO Paseos (id_perro, id_tramo, fecha) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sqlInsertarPaseo);
        pstmt.setInt(1, Integer.parseInt(idPerro));  // Convertir idPerro a entero
        pstmt.setInt(2, idTramo);  // Asociar el tramo encontrado o insertado
        pstmt.setString(3, fecha);  // Fecha del paseo

        int filasAfectadas = pstmt.executeUpdate();

        if (filasAfectadas > 0) {
            out.println("<h2>Paseo registrado exitosamente.</h2>");
        } else {
            out.println("<h2>Error al registrar el paseo. Intenta nuevamente.</h2>");
        }

    } catch (SQLException e) {
        // Capturar cualquier error de SQL y mostrarlo
        out.println("<h2>Error en la base de datos: " + e.getMessage() + "</h2>");
        e.printStackTrace();
    } catch (NumberFormatException e) {
        // Capturar error si los valores no son números válidos
        out.println("<h2>Error: Los datos proporcionados no son válidos.</h2>");
        e.printStackTrace();
    } finally {
        // Cerrar los recursos de base de datos de manera segura
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<h2>Error al cerrar la conexión de base de datos: " + e.getMessage() + "</h2>");
        }
    }
%>
<title>Passing Dogs - Registrar Perro</title>
<link rel="stylesheet" href="common/general.css">
<br><br>
<a href="bienvenido.jsp">Volver al menú principal</a>
