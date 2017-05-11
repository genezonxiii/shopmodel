package tw.com.sbi.serviceregister.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;

public class ServiceRegister extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LogManager.getLogger(ServiceRegister.class);
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs = null;
		
		String action = request.getParameter("action");
		logger.debug("Action:".concat(action));
		if("insert_reg".equals(action)){
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				cs = con.prepareCall("call sp_insert_service_register(?,?,?,?,?,?,?,?)");
				
				cs.setString(1, request.getParameter("service_id"));
				cs.setString(2, request.getParameter("product_id"));
				cs.setString(3, request.getParameter("cust_name"));
				cs.setString(4, request.getParameter("cust_tel"));
				cs.setString(5, request.getParameter("cust_mobile"));
				cs.setString(6, request.getParameter("cust_address"));
				cs.setString(7, request.getParameter("purchase_date"));
				cs.registerOutParameter(8, Types.BOOLEAN);
				
				cs.execute();
				String returnParam = cs.getString(8);
				
				Map map = new HashMap();
				map.put("success", true);
				map.put("info", returnParam);
				JSONObject result = new JSONObject(map);
				
				response.getWriter().write(result.toString());
			} catch (SQLException se) {
				// Handle any driver errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
			} finally {
				// Clean up JDBC resources
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException se) {
						se.printStackTrace(System.err);
					}
				}
				if (cs != null) {
					try {
						cs.close();
					} catch (SQLException se) {
						se.printStackTrace(System.err);
					}
				}
				if (con != null) {
					try {
						con.close();
					} catch (Exception e) {
						e.printStackTrace(System.err);
					}
				}
			}
		}
		//#############
	}
}
