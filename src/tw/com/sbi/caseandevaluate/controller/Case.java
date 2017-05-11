package tw.com.sbi.caseandevaluate.controller;

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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;

import tw.com.sbi.productforecast.controller.ProductForecast.ProductForecastBean;
import tw.com.sbi.productforecastpoint.controller.ProductForecastPoint.ProductForecastPointBean;
import tw.com.sbi.productforecastpoint.controller.ProductForecastPoint.ProductForecastPointService;
import tw.com.sbi.vo.CaseVO;

public class Case extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final Logger logger = LogManager.getLogger(Case.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String groupId = request.getSession().getAttribute("group_id").toString();
		logger.debug("group_id:" + groupId);
		
		CaseService caseService = null;

		String action = request.getParameter("action");
		
		logger.debug("Action: " + action);
		
		if ("getCase".equals(action)) {
			try {								
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectCase(groupId);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getCaseById".equals(action)) {
			try {				
				String caseId = request.getParameter("case_id");
				logger.debug("Case Id:" + caseId);
				
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectCaseById(caseId);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getCaseNotFinish".equals(action)) {
			try {								
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectCaseNotFinish(groupId);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getCountry".equals(action)) {
			try {								
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectCountry();
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getCity".equals(action)) {
			try {
				String country = request.getParameter("country");
				
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectCity(country);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getBD".equals(action)) {
			try {
				String city = request.getParameter("city");
				
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectBD(city);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("insert".equals(action)) {
			try {
				/*************************** 1.接收請求參數 **************************************/
				String cityId = request.getParameter("city_id");
				String bcircleId = request.getParameter("bcircle_id");
				String preference = request.getParameter("preference");
				String evaluateNo = request.getParameter("evaluate_no");
				String evaluate = request.getParameter("evaluate");
				String evaluate1No = request.getParameter("evaluate_1_no");
				String evaluate1 = request.getParameter("evaluate_1");
				
				logger.debug("city_id:" + cityId);
				logger.debug("bcircle_id" + bcircleId);
				logger.debug("preference:" + preference);
				logger.debug("evaluate_no:" + evaluateNo);
				logger.debug("evaluate:" + evaluate);
				logger.debug("evaluate_1_no:" + evaluate1No);
				logger.debug("evaluate_1:" + evaluate1);
				
				/*************************** 2.開始新增資料 ***************************************/
				caseService = new CaseService();
				
				CaseVO caseVO = new CaseVO();
				
				caseVO = caseService.addCase(groupId, cityId, bcircleId, preference, evaluateNo, evaluate, evaluate1No, evaluate1);

				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				
				caseVO.setMessage("新增成功");
				
				List<CaseVO> list = new ArrayList<CaseVO>();
				list.add(caseVO);
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
			}
		}	
	
	}
	
	/*************************** 處理業務邏輯 ****************************************/
	public class CaseService {
		private case_interface dao;

		public CaseService() {
			dao = new CaseDAO();
		}

		public List<CaseVO> selectCase(String groupId) {
			return dao.selectCase(groupId);
		}

		public List<CaseVO> selectCaseById(String caseId) {
			return dao.selectCaseByCaseId(caseId);
		}

		public List<CaseVO> selectCaseNotFinish(String groupId) {
			return dao.selectCaseNotFinish(groupId);
		}

		public List<CaseVO> selectCountry() {
			return dao.selectCountry();
		}

		public List<CaseVO> selectCity(String country) {
			return dao.selectCity(country);
		}
		
		public List<CaseVO> selectBD(String city) {
			return dao.selectBD(city);
		}
		
		public CaseVO addCase(String group_id, String city_id, String bcircle_id, String preference, String evaluate_no, String evaluate,
				String evaluate_1_no, String evaluate_1) {
			CaseVO caseVO = new CaseVO();
			
			caseVO.setGroup_id(group_id);
			caseVO.setCity_id(city_id);
			caseVO.setBcircle_id(bcircle_id);
			caseVO.setPreference(preference);
			caseVO.setEvaluate_no(evaluate_no);
			
			caseVO.setEvaluate(evaluate);
			caseVO.setEvaluate_1_no(evaluate_1_no);
			caseVO.setEvaluate_1(evaluate_1);
			
			String case_id = dao.insertCase(caseVO);
			
			caseVO.setCase_id(case_id);
		
			return caseVO;
		}
	}

	/*************************** 制定規章方法 ****************************************/
	interface case_interface {
		public List<CaseVO> selectCase(String groupId);
		public List<CaseVO> selectCaseByCaseId(String caseId);
		public List<CaseVO> selectCaseNotFinish(String groupId);
		public List<CaseVO> selectCountry();
		public List<CaseVO> selectCity(String country);
		public List<CaseVO> selectBD(String city);
		
		public String insertCase(CaseVO caseVO);
	}
	
	/*************************** 操作資料庫 ****************************************/
	class CaseDAO implements case_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");
		private final String wsPath = getServletConfig().getServletContext().getInitParameter("pythonwebservice");

		// 會使用到的Stored procedure
		private static final String sp_get_decision_case = "call sp_get_decision_case(?)";
		private static final String sp_get_decision_case_by_case_id = "call sp_get_decision_case_by_case_id(?)";
		private static final String sp_get_decision_case_notfinish = "call sp_get_decision_case_notfinish(?)";
		private static final String sp_get_decision_country = "call sp_get_decision_country()";
		private static final String sp_get_decision_city = "call sp_get_decision_city(?)";
		private static final String sp_get_decision_BD = "call sp_get_decision_BD(?)";
		private static final String sp_insert_case = "call sp_insert_case(?,?,?,?,?,?,?,?,?)";
		
		@Override
		public List<CaseVO> selectCase(String groupId) {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case);
				
				pstmt.setString(1, groupId);
				
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					caseVO = new CaseVO();
					
					caseVO.setCase_id(rs.getString("case_id") == null?"":rs.getString("case_id"));
					caseVO.setGroup_id(rs.getString("group_id") == null?"":rs.getString("group_id"));
					caseVO.setCity_id(rs.getString("city_id") == null?"":rs.getString("city_id"));
					caseVO.setPreference(rs.getString("preference") == null?"":rs.getString("preference"));
					caseVO.setEvaluate_no(rs.getString("evaluate_no") == null?"":rs.getString("evaluate_no"));
					
					caseVO.setEvaluate(rs.getString("evaluate") == null?"":rs.getString("evaluate"));
					caseVO.setEvaluate_1_no(rs.getString("evaluate_1_no") == null?"":rs.getString("evaluate_1_no"));
					caseVO.setEvaluate_1(rs.getString("evaluate_1") == null?"":rs.getString("evaluate_1"));
					caseVO.setEnding_time(rs.getString("ending_time") == null?"":rs.getString("ending_time"));
					caseVO.setIsfinish(rs.getString("isfinish") == null?"":rs.getString("isfinish"));
					
					caseVO.setV_city_name(rs.getString("city_name") == null?"":rs.getString("city_name"));
					caseVO.setV_country_id(rs.getString("country_id") == null?"":rs.getString("country_id"));
					caseVO.setV_country(rs.getString("country_name") == null?"":rs.getString("country_name"));
					
					list.add(caseVO); // Store the row in the list
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
		public List<CaseVO> selectCaseByCaseId(String caseId) {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case_by_case_id);
				pstmt.setString(1, caseId);
				
				rs = pstmt.executeQuery();
				while (rs.next()) {
					caseVO = new CaseVO();
					
					caseVO.setCase_id(rs.getString("case_id") == null?"":rs.getString("case_id"));
					caseVO.setGroup_id(rs.getString("group_id") == null?"":rs.getString("group_id"));
					caseVO.setCity_id(rs.getString("city_id") == null?"":rs.getString("city_id"));
					caseVO.setPreference(rs.getString("preference") == null?"":rs.getString("preference"));
					caseVO.setEvaluate_no(rs.getString("evaluate_no") == null?"":rs.getString("evaluate_no"));
					
					caseVO.setEvaluate(rs.getString("evaluate") == null?"":rs.getString("evaluate"));
					caseVO.setEvaluate_1_no(rs.getString("evaluate_1_no") == null?"":rs.getString("evaluate_1_no"));
					caseVO.setEvaluate_1(rs.getString("evaluate_1") == null?"":rs.getString("evaluate_1"));
					caseVO.setEnding_time(rs.getString("ending_time") == null?"":rs.getString("ending_time"));
					caseVO.setResult(rs.getString("result") == null?"":rs.getString("result"));
					
					caseVO.setIsfinish(rs.getString("isfinish") == null?"":rs.getString("isfinish"));
					
					caseVO.setV_city_name(rs.getString("city_name") == null?"":rs.getString("city_name"));
					caseVO.setV_country_id(rs.getString("country_id") == null?"":rs.getString("country_id"));
					caseVO.setV_country(rs.getString("country_name") == null?"":rs.getString("country_name"));
					caseVO.setV_decision_proposal(rs.getString("decision_proposal") == null?"":rs.getString("decision_proposal"));
					
					list.add(caseVO); // Store the row in the list
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
		public List<CaseVO> selectCaseNotFinish(String groupId) {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case_notfinish);
				pstmt.setString(1, groupId);
				
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					caseVO = new CaseVO();
					
					caseVO.setCase_id(rs.getString("case_id") == null?"":rs.getString("case_id"));
					caseVO.setGroup_id(rs.getString("group_id") == null?"":rs.getString("group_id"));
					caseVO.setCity_id(rs.getString("city_id") == null?"":rs.getString("city_id"));
					caseVO.setPreference(rs.getString("preference") == null?"":rs.getString("preference"));
					caseVO.setEvaluate_no(rs.getString("evaluate_no") == null?"":rs.getString("evaluate_no"));
					
					caseVO.setEvaluate(rs.getString("evaluate") == null?"":rs.getString("evaluate"));
					caseVO.setEvaluate_1_no(rs.getString("evaluate_1_no") == null?"":rs.getString("evaluate_1_no"));
					caseVO.setEvaluate_1(rs.getString("evaluate_1") == null?"":rs.getString("evaluate_1"));
					
					caseVO.setV_city_name(rs.getString("city_name") == null?"":rs.getString("city_name"));
					caseVO.setV_country_id(rs.getString("country_id") == null?"":rs.getString("country_id"));
					caseVO.setV_country(rs.getString("country_name") == null?"":rs.getString("country_name"));
					
					list.add(caseVO); // Store the row in the list
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
		public List<CaseVO> selectCountry() {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_country);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					caseVO = new CaseVO();
					
					caseVO.setV_country_id(rs.getString("country_id") == null?"":rs.getString("country_id"));
					caseVO.setV_country(rs.getString("country_name") == null?"":rs.getString("country_name"));
					
					list.add(caseVO); // Store the row in the list
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
		public List<CaseVO> selectCity(String country) {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_city);
				pstmt.setString(1, country);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					caseVO = new CaseVO();
					
					caseVO.setCity_id(rs.getString("city_id") == null?"":rs.getString("city_id"));
					caseVO.setV_city_name(rs.getString("city_name") == null?"":rs.getString("city_name"));
					
					list.add(caseVO); // Store the row in the list
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
		public List<CaseVO> selectBD(String city) {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_BD);
				pstmt.setString(1, city);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					caseVO = new CaseVO();
					
					caseVO.setBcircle_id(rs.getString("bcircle_id") == null?"":rs.getString("bcircle_id"));
					caseVO.setV_bcircle_name(rs.getString("bcircle_name") == null?"":rs.getString("bcircle_name"));
					
					list.add(caseVO); // Store the row in the list
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
		public String insertCase(CaseVO caseVO) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_insert_case);

				cs.setString(1, caseVO.getGroup_id());
				cs.setString(2, caseVO.getCity_id());
				cs.setString(3, caseVO.getBcircle_id());
				cs.setString(4, caseVO.getPreference());
				cs.setString(5, caseVO.getEvaluate_no());
				cs.setString(6, caseVO.getEvaluate());
				cs.setString(7, caseVO.getEvaluate_1_no());
				cs.setString(8, caseVO.getEvaluate_1());
				
				cs.registerOutParameter(9, Types.VARCHAR);
				
				cs.execute();
				
				return cs.getString(9);
				
			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
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
