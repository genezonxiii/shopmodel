package tw.com.sbi.agent.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;

import tw.com.sbi.vo.AgentAuthVO;
import tw.com.sbi.vo.AgentVO;
import tw.com.sbi.vo.ProductVO;

public class AgentAuth extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LogManager.getLogger(AgentAuth.class);
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		AgentAuthService agentAuthService = null;

		String groupId = request.getSession().getAttribute("group_id").toString();
		String action = request.getParameter("action");
		
		if ("selectAll".equals(action)) {
			try {								
				agentAuthService = new AgentAuthService();
				List<AgentAuthVO> list = agentAuthService.getAgentAuthByGroupId(groupId);
				logger.debug("list.size(): " + list.size());
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getProductInfo".equals(action)) {
			logger.debug("enter getProductInfo function");
			try {								
				agentAuthService = new AgentAuthService();
				List<ProductVO> list = agentAuthService.getProductByGroupId(groupId);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getAgentInfo".equals(action)) {
//			logger.debug("enter getAgentInfo function");
			try {				
				agentAuthService = new AgentAuthService();
				
				List<AgentVO> list = agentAuthService.getAgentByGroupId(groupId);

//				logger.debug("getAgentInfo: " + list.toString());
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("insert".equals(action)) {
			logger.debug("enter agentauth insert method");
			try {
				String agentId = request.getParameter("agent_id");
				String productId = request.getParameter("product_id");
				String regionCode = request.getParameter("region_code");
				String authQuantity = request.getParameter("auth_quantity");
				String saleQuantity = request.getParameter("sale_quantity");
				String registerQuantity = request.getParameter("register_quantity");
				String seed = request.getParameter("seed");
				
				agentAuthService = new AgentAuthService();
				List<AgentAuthVO> list = agentAuthService.addAgentAuth(groupId, agentId, productId, regionCode, authQuantity, saleQuantity, registerQuantity, seed);

				logger.debug("insert list: " + list.toString());
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("update".equals(action)) {
			logger.debug("enter agent update method");
			try {				
				String agentId = request.getParameter("agent_id");
				String productId = request.getParameter("product_id");
				String regionCode = request.getParameter("region_code");
				String authQuantity = request.getParameter("auth_quantity");
				String saleQuantity = request.getParameter("sale_quantity");
				String registerQuantity = request.getParameter("register_quantity");
				String seed = request.getParameter("seed");
				
				agentAuthService = new AgentAuthService();
				
				List<AgentAuthVO> list = agentAuthService.updateAgent(groupId, agentId, productId, regionCode, authQuantity, saleQuantity, registerQuantity, seed);

				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("delete".equals(action)) {
			try {
				String agentId = request.getParameter("agent_id");
				String productId = request.getParameter("product_id");
				
				agentAuthService = new AgentAuthService();
				
				List<AgentAuthVO> list = agentAuthService.deleteAgentAuth(groupId, agentId, productId);

				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/*************************** 處理業務邏輯 ****************************************/
	public class AgentAuthService {
		private agent_interface dao;

		public AgentAuthService() {
			dao = new AgentDAO();
		}

		public List<AgentAuthVO> getAgentAuthByGroupId(String groupId){
			return dao.getAgentAuthByGroupId(groupId);
		}
		
		public List<ProductVO> getProductByGroupId(String groupId) {
			return dao.getProductByGroupId(groupId);
		}
		
		public List<AgentVO> getAgentByGroupId(String groupId) {
			return dao.getAgentByGroupId(groupId);
		}
		
		public List<AgentAuthVO> addAgentAuth(String groupId, String agentId, String productId, String regionCode, String authQuantity, String saleQuantity, String registerQuantity, String seed) {
			AgentAuthVO agentAuthVO = new AgentAuthVO();
			
			agentAuthVO.setGroup_id(groupId);
			agentAuthVO.setAgent_id(agentId);
			agentAuthVO.setProduct_id(productId);
			agentAuthVO.setRegion_code(regionCode);
			agentAuthVO.setRegion_code(regionCode);
			agentAuthVO.setAuth_quantity(authQuantity);
			agentAuthVO.setSale_quantity(saleQuantity);
			agentAuthVO.setRegister_quantity(registerQuantity);
			agentAuthVO.setSeed(seed);

			dao.insertDB(agentAuthVO);
			return dao.getAgentAuthByGroupId(groupId);
		}
		
		public List<AgentAuthVO> updateAgent(String groupId, String agentId, String productId, String regionCode, String authQuantity, String saleQuantity, String registerQuantity, String seed){
			AgentAuthVO agentAuthVO = new AgentAuthVO();

			agentAuthVO.setGroup_id(groupId);
			agentAuthVO.setAgent_id(agentId);
			agentAuthVO.setProduct_id(productId);
			agentAuthVO.setRegion_code(regionCode);
			agentAuthVO.setAuth_quantity(authQuantity);
			agentAuthVO.setSale_quantity(saleQuantity);
			agentAuthVO.setRegister_quantity(registerQuantity);
			agentAuthVO.setSeed(seed);
			
			dao.updateDB(agentAuthVO);
			return dao.getAgentAuthByGroupId(groupId);
		}
		
		public List<AgentAuthVO> deleteAgentAuth(String groupId, String agentId, String productId){
			dao.deleteDB(groupId, agentId, productId);
			return dao.getAgentAuthByGroupId(groupId);
		}
	}
	
	/*************************** 制定規章方法 ****************************************/
	interface agent_interface {
		public void insertDB(AgentAuthVO agentAuthVO);

		public void updateDB(AgentAuthVO agentAuthVO);

		public void deleteDB(String groupId, String agentId, String productId);
		
		public List<ProductVO> getProductByGroupId(String groupId);
		
		public List<AgentVO> getAgentByGroupId(String groupId);
		
		public List<AgentAuthVO> getAgentAuthByGroupId(String groupId);
	}
	
	/*************************** 操作資料庫 ****************************************/
	class AgentDAO implements agent_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		// 會使用到的Stored procedure
		private static final String sp_get_agent_auth_1_by_group = "call sp_get_agent_auth_1_by_group(?)";
//		private static final String sp_get_agent_auth_2_by_group = "call sp_get_agent_auth_2_by_group(?,?,?)";
		private static final String sp_get_product_by_group = "call sp_get_product_by_group(?)";
		private static final String sp_get_agent_by_group = "call sp_get_agent_by_group(?)";
		private static final String sp_insert_agent_auth = "call sp_insert_agent_auth(?,?,?,?,?,?,?,?)";
		private static final String sp_update_agent_auth = "call sp_update_agent_auth(?,?,?,?,?,?,?,?)";
		private static final String sp_delete_agent_auth = "call sp_delete_agent_auth(?,?,?)";


		@Override
		public List<ProductVO> getProductByGroupId(String groupId) {
			List<ProductVO> list = new ArrayList<ProductVO>();
			ProductVO productVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_product_by_group);
				pstmt.setString(1, groupId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					productVO = new ProductVO();
					
					productVO.setGroup_id(groupId);
					productVO.setPhoto(rs.getString("photo"));
					productVO.setProduct_id(rs.getString("product_id"));
					productVO.setProduct_spec(rs.getString("product_spec"));
					productVO.setSeed(rs.getString("seed"));
					
					list.add(productVO); // Store the row in the list
				}				
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
		public List<AgentVO> getAgentByGroupId(String groupId) {
			List<AgentVO> list = new ArrayList<AgentVO>();
			AgentVO agentVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_agent_by_group);
				pstmt.setString(1, groupId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					agentVO = new AgentVO();
					
					agentVO.setGroup_id(groupId);
					agentVO.setAgent_id(rs.getString("agent_id"));
					agentVO.setAgent_name(rs.getString("agent_name"));
					agentVO.setWeb_site(rs.getString("web_site"));
					agentVO.setRegion_code(rs.getString("region_code"));
					agentVO.setContact_mail(rs.getString("contact_mail"));
					agentVO.setContact_phone(rs.getString("contact_phone"));
					agentVO.setSeed(rs.getString("seed"));
					
					list.add(agentVO); // Store the row in the list
				}				
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
		public List<AgentAuthVO> getAgentAuthByGroupId(String groupId) {
			List<AgentAuthVO> list = new ArrayList<AgentAuthVO>();
			AgentAuthVO agentAuthVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_agent_auth_1_by_group);
				pstmt.setString(1, groupId);
				
				rs = pstmt.executeQuery();
				while (rs.next()) {
					agentAuthVO = new AgentAuthVO();
					
					agentAuthVO.setGroup_id(groupId);
					agentAuthVO.setAgent_id(rs.getString("agent_id"));
					agentAuthVO.setAgent_name(rs.getString("agent_name"));
					agentAuthVO.setProduct_id(rs.getString("product_id"));
					agentAuthVO.setProduct_spec(rs.getString("product_spec"));
					agentAuthVO.setRegion_code(rs.getString("region_code"));
					agentAuthVO.setAuth_quantity(rs.getString("auth_quantity"));
					agentAuthVO.setSale_quantity(rs.getString("sale_quantity"));
					agentAuthVO.setRegister_quantity(rs.getString("register_quantity"));
					agentAuthVO.setSeed(rs.getString("seed"));
					
					list.add(agentAuthVO); // Store the row in the list
				}				
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
		public void insertDB(AgentAuthVO agentAuthVO) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_insert_agent_auth);

				cs.setString(1, agentAuthVO.getProduct_id());
				cs.setString(2, agentAuthVO.getAgent_id());
				cs.setString(3, agentAuthVO.getGroup_id());
				cs.setString(4, agentAuthVO.getRegion_code());
				cs.setString(5, agentAuthVO.getAuth_quantity());
				cs.setString(6, agentAuthVO.getSale_quantity());
				cs.setString(7, agentAuthVO.getRegister_quantity());
				cs.setString(8, agentAuthVO.getSeed());
				cs.execute();
			
			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
			} finally {
				// Clean up JDBC resources
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
		}
		
		@Override
		public void updateDB(AgentAuthVO agentAuthVO) {
			logger.debug("enter updateDB method");
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_update_agent_auth);

				cs.setString(1, agentAuthVO.getProduct_id());
				cs.setString(2, agentAuthVO.getAgent_id());
				cs.setString(3, agentAuthVO.getGroup_id());
				cs.setString(4, agentAuthVO.getRegion_code());
				cs.setString(5, agentAuthVO.getAuth_quantity());
				cs.setString(6, agentAuthVO.getSale_quantity());
				cs.setString(7, agentAuthVO.getRegister_quantity());
				cs.setString(8, agentAuthVO.getSeed());
				cs.execute();
			
			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
			} finally {
				// Clean up JDBC resources
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
		}
		
		@Override
		public void deleteDB(String groupId, String agentId, String productId) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_delete_agent_auth);

				cs.setString(1, productId);
				cs.setString(2, agentId);
				cs.setString(3, groupId);

				cs.execute();
			
			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
			} finally {
				// Clean up JDBC resources
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
		}		
	}
}