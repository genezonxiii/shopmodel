package tw.com.sbi.login.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;

import tw.com.sbi.vo.MenuVO;

public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
//	private static final int WIDTH = 120; // 圖片寬度
//	private static final int HEIGHT = 30; // 圖片高度
	
	private static final Logger logger = LogManager.getLogger(Login.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		logger.debug("Login doPost");
		
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");
		HttpSession session = request.getSession(true);
		LoginVO message = null;
		LoginService loginService = null;
		Gson gson = null;

		if ("login".equals(action)) {
			String groupName = request.getParameter("group_name");
			String username = request.getParameter("user_name");
			String password = request.getParameter("pswd");
			String validateCode = request.getParameter("validateCode").trim();
			Object checkcode = session.getAttribute("checkcode");
			
			logger.debug("groupName:" + groupName);
			logger.debug("username:" + username);
			
			if (!checkcode.equals(convertToCapitalString(validateCode))) {
				message = new LoginVO();
				message.setMessage("code_failure");
				gson = new Gson();
				String jsonStrList = gson.toJson(message);
				response.getWriter().write(jsonStrList);
				return;
			} else {
				loginService = new LoginService();
				List<LoginVO> list = loginService.selectlogin(groupName, username, password);
				if (list.size() != 0) {
					session.setAttribute("sessionID", session.getId());
					session.setAttribute("user_id", list.get(0).getUser_id());
					session.setAttribute("group_id", list.get(0).getGroup_id());
					session.setAttribute("user_name", list.get(0).getUser_name());
					session.setAttribute("role", list.get(0).getRole());
					session.setAttribute("privilege", list.get(0).getPrivilege());
					
					logger.debug("sessionID:"+ session.getId());
					logger.debug("user_id:"+ list.get(0).getUser_id());
					logger.debug("group_id:"+ list.get(0).getGroup_id());
					logger.debug("user_name:"+ list.get(0).getUser_name());
					logger.debug("role:"+ list.get(0).getRole());
					logger.debug("privilege:"+ list.get(0).getPrivilege());
					
					String menuListStr = loginService.getMenuListToString();
					session.setAttribute("menu", menuListStr);
					
					message = new LoginVO();
					message.setMessage("success");
				} else {
					message = new LoginVO();
					message.setMessage("failure");
				}
				gson = new Gson();
				String jsonStrList = gson.toJson(message);
				response.getWriter().write(jsonStrList);
			}
		}
		
		if ("check_user_exist".equals(action)) {
			String groupName = request.getParameter("group_name");
			String username = request.getParameter("user_name");
			
			logger.debug("groupName:" + groupName);
			logger.debug("username:" + username);

			loginService = new LoginService();
			if(!loginService.checkuser(groupName, username)){
				message = new LoginVO();
				message.setMessage("user_failure");
				gson = new Gson();
				String jsonStrList = gson.toJson(message);
				response.getWriter().write(jsonStrList);
			} else {
				message = new LoginVO();
				message.setMessage("success");
				gson = new Gson();
				String jsonStrList = gson.toJson(message);
				response.getWriter().write(jsonStrList);
			}
		}
		if ("logout".equals(action)) {
			session.setAttribute("sessionID", null);
			session.setAttribute("user_id", null);
			session.setAttribute("group_id", null);
			session.setAttribute("user_name", null);
		}
	}

	/**
	 * 將一個字符串中的小寫字母轉換為大寫字母
	 * 
	 * */
	public static String convertToCapitalString(String src) {
		char[] array = src.toCharArray();
		int temp = 0;
		for (int i = 0; i < array.length; i++) {
			temp = (int) array[i];
			if (temp <= 122 && temp >= 97) { // array[i]为小写字母
				array[i] = (char) (temp - 32);
			}
		}
		return String.valueOf(array);
	}

	/************************* 對應資料庫表格格式 **************************************/
	@SuppressWarnings("serial")
	public class LoginVO implements java.io.Serializable {

		private String email;
		private String password;
		private String user_id;
		private String group_id;
		private String user_name;
		private int role;
		private String privilege;
		private String message;// for set check message

		public String getEmail() {
			return email;
		}

		public void setEmail(String email) {
			this.email = email;
		}

		public String getPassword() {
			return password;
		}

		public void setPassword(String password) {
			this.password = password;
		}

		public String getUser_id() {
			return user_id;
		}

		public void setUser_id(String user_id) {
			this.user_id = user_id;
		}

		public String getGroup_id() {
			return group_id;
		}

		public void setGroup_id(String group_id) {
			this.group_id = group_id;
		}

		public String getUser_name() {
			return user_name;
		}

		public void setUser_name(String user_name) {
			this.user_name = user_name;
		}

		public int getRole() {
			return role;
		}

		public void setRole(int role) {
			this.role = role;
		}

		public String getPrivilege() {
			return privilege;
		}

		public void setPrivilege(String privilege) {
			this.privilege = privilege;
		}

		public String getMessage() {
			return message;
		}

		public void setMessage(String message) {
			this.message = message;
		}

	}

	/*************************** 制定規章方法 ****************************************/

	interface login_interface {

		public List<LoginVO> loginDB(String groupName, String p_user_name, String p_password);

		public Boolean checkuser(String groupName, String p_user_name);
		
		public List<MenuVO> getMainMenuDB();

		public List<MenuVO> getSubMenuDB(String id);
	}

	/*************************** 處理業務邏輯 ****************************************/
	public class LoginService {
		private login_interface dao;

		public LoginService() {
			dao = new loginDAO();
		}

		public List<LoginVO> selectlogin(String groupName, String p_user_name, String p_password) {
			return dao.loginDB(groupName, p_user_name, p_password);
		}

		public Boolean checkuser(String groupName, String p_user_name) {
			return dao.checkuser(groupName, p_user_name);
		}

		public List<MenuVO> getMenuList() {
			List<MenuVO> main = null;
			
			logger.debug("getMainMenu start");
			
			main = dao.getMainMenuDB();
			logger.debug("getMainMenu end");
			
			for (int i = 0; i < main.size(); i++) {
				List<MenuVO> subMenu = null;
				
				logger.debug("get subMenu start:" + main.get(i).getId());
				
				subMenu = setSubMenu( main.get(i).getId() );
				main.get(i).setSubMenu(subMenu);
				
				logger.debug("get subMenu end");
			};
			
			return main;
		}
		
		public List<MenuVO> setSubMenu(String parent_id){
			List<MenuVO> temp = null;
			
			temp = dao.getSubMenuDB(parent_id);
			
			if (temp == null) {
				return null;
			} else {
				for(int i = 0; i < temp.size(); i++) {
					List<MenuVO> tempSub = null;
					tempSub = setSubMenu( temp.get(i).getId() );
					temp.get(i).setSubMenu(tempSub);
				}
			}
			return temp;
		}
		
		public String getMenuListToString() {
			List<MenuVO> list = getMenuList();

			logger.debug("result getMenu list size: " + list.size());

			Gson gson = new Gson();
			String jsonStrList = gson.toJson(list);
			
			return jsonStrList;
		}
	}

	/*************************** 操作資料庫 ****************************************/
	class loginDAO implements login_interface {
		// 會使用到的Stored procedure
		private static final String sp_login = "call sp_login_test(?,?,?)";
		private static final String sp_checkuser = "call sp_checkuser_test(?,?,?)";
		private static final String sp_get_main_menu = "call sp_get_main_menu()";
		private static final String sp_get_submenu_by_parent_id = "call sp_get_submenu_by_parent_id(?)";
		
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		@Override
		public List<LoginVO> loginDB(String groupName, String p_user_name, String p_password) {
			List<LoginVO> list = new ArrayList<LoginVO>();
			LoginVO LoginVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_login);
				pstmt.setString(1, groupName);
				pstmt.setString(2, p_user_name);
				pstmt.setString(3, p_password);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					LoginVO = new LoginVO();
					LoginVO.setUser_id(rs.getString("uid"));
					LoginVO.setGroup_id(rs.getString("gid"));
					LoginVO.setUser_name(rs.getString("user"));
					LoginVO.setRole(Integer.parseInt(rs.getString("role")));
					LoginVO.setPrivilege(rs.getString("privilege"));
					
					logger.info("User_id: " + rs.getString("uid"));
					logger.info("Group_id: " + rs.getString("gid"));
					logger.info("User_name: " + rs.getString("user"));
					logger.info("Role: " + rs.getString("role"));
					logger.info("Privilege: " + rs.getString("privilege"));
					
					list.add(LoginVO);
				}
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
				// Clean up JDBC resources
			} finally {
				if (pstmt != null) {
					try {
						pstmt.close();
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
			return list;

		}

		@Override
		public Boolean checkuser(String groupName, String p_user_name) {
			Connection con = null;
			CallableStatement cs = null;
			Boolean rs = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				cs = con.prepareCall(sp_checkuser);
				cs.setString(1, groupName);
				cs.setString(2, p_user_name);
				cs.registerOutParameter(3, Types.BOOLEAN);
				
				cs.execute();
				rs = cs.getBoolean(3);
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
				// Clean up JDBC resources
			} finally {
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
			return rs;
		}
		
		@Override
		public List<MenuVO> getMainMenuDB() {
			List<MenuVO> list = new ArrayList<MenuVO>();

			MenuVO menuVO = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_main_menu);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					menuVO = new MenuVO();
					
					menuVO.setId(null2str(rs.getString("id")));
					menuVO.setMenuName(null2str(rs.getString("menu_name")));
					menuVO.setUrl(null2str(rs.getString("url")));
					menuVO.setSeqNo(null2str(rs.getString("seq_no")));
					menuVO.setParentId(null2str(rs.getString("parent_id")));
					menuVO.setPhotoPath(null2str(rs.getString("photo_path")));
					
					list.add(menuVO); // Store the row in the list
				}
				// Handle any driver errors
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
				// Clean up JDBC resources
			} finally {
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException se) {
						se.printStackTrace(System.err);
					}
				}
				if (pstmt != null) {
					try {
						pstmt.close();
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
			return list;
		}

		@Override
		public List<MenuVO> getSubMenuDB(String parent_id) {
			List<MenuVO> list = new ArrayList<MenuVO>();

			MenuVO menuVO = null;
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_submenu_by_parent_id);
				pstmt.setString(1, parent_id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					menuVO = new MenuVO();
					
					menuVO.setId(null2str(rs.getString("id")));
					menuVO.setMenuName(null2str(rs.getString("menu_name")));
					menuVO.setUrl(null2str(rs.getString("url")));
					menuVO.setSeqNo(null2str(rs.getString("seq_no")));
					menuVO.setParentId(null2str(rs.getString("parent_id")));
					menuVO.setPhotoPath(null2str(rs.getString("photo_path")));
					
					list.add(menuVO); // Store the row in the list
				}
				// Handle any driver errors
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
				// Clean up JDBC resources
			} finally {
				if (rs != null) {
					try {
						rs.close();
					} catch (SQLException se) {
						se.printStackTrace(System.err);
					}
				}
				if (pstmt != null) {
					try {
						pstmt.close();
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
			return list;
		}
	}
	
	public String null2str(Object object) {
		return object == null ? "" : object.toString();
	}
}