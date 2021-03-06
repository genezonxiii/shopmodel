package tw.com.sbi.caseandevaluate.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;
import tw.com.sbi.vo.CaseCompetitionVO;

public class CaseCompetitionEvaluation extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final Logger logger = LogManager.getLogger(CaseCompetitionEvaluation.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		EvaluateService evaluateService = null;
		
		String groupId = request.getSession().getAttribute("group_id").toString();
		logger.debug("group_id:" + groupId);

		String action = request.getParameter("action");
		logger.info("Action: " + action);
		
		if ("getCaseCompetitionNotFinish".equals(action)) {
			evaluateService = new EvaluateService();
			List<CaseCompetitionVO> list = evaluateService.selectCaseCompetitionNotFinish(groupId);
			Gson gson = new Gson();
			String jsonStrList = gson.toJson(list);
			logger.info("getCaseCompetitionNotFinish json params : " + jsonStrList);
			response.getWriter().write(jsonStrList);
			return;
		} else if ("update".equals(action)) {
			try {
				String user_id = request.getSession().getAttribute("user_id").toString();

				String competition_id = request.getParameter("competition_id");
				String evaluate_point = request.getParameter("evaluate_point");
				String evaluate_reason = request.getParameter("evaluate_reason");
				String evaluate_1_point = request.getParameter("evaluate_1_point");
				String evaluate_seq = request.getParameter("evaluate_seq");

				logger.debug("user_id:" + user_id);
				logger.debug("competition_id:" + competition_id);
				logger.debug("evaluate_point:" + evaluate_point);
				logger.debug("evaluate_reason:" + evaluate_reason);
				logger.debug("evaluate_1_point:" + evaluate_1_point);
				logger.debug("evaluate_seq:" + evaluate_seq);
				logger.debug("===========================================================================");
				evaluateService = new EvaluateService();
				evaluateService.updateEvaluateCompetition(competition_id, user_id, evaluate_point, evaluate_reason,
						evaluate_1_point, evaluate_seq);
				// 檢查是否全部填寫完畢
				evaluateService.countCase(competition_id);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	/*************************** 處理業務邏輯 ****************************************/
	public class EvaluateService {
		private evaluate_interface dao;

		public EvaluateService() {
			dao = new EvaluateDAO();
		}

		public List<CaseCompetitionVO> selectCaseCompetitionNotFinish(String groupId) {
			return dao.selectCaseCompetitionNotFinish(groupId);
		}

		public void updateEvaluateCompetition(String competition_id, String user_id, String evaluate_point,
				String evaluate_reason, String evaluate_1_point, String evaluate_seq) {
			dao.updateEvaluateCompetition(competition_id, user_id, evaluate_point, evaluate_reason, evaluate_1_point,
					evaluate_seq);
		}

		public void countCase(String competition_id) {
			dao.countByCompetitionIdDB(competition_id);
		}
	}

	/*************************** 制定規章方法 ****************************************/
	interface evaluate_interface {
		public List<CaseCompetitionVO> selectCaseCompetitionNotFinish(String groupId);

		public void updateEvaluateCompetition(String competition_id, String user_id, String evaluate_point,
				String evaluate_reason, String evaluate_1_point, String evaluate_seq);

		public void countByCompetitionIdDB(String competition_id);
	}

	/*************************** 操作資料庫 ****************************************/
	class EvaluateDAO implements evaluate_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		// 會使用到的Stored procedure
		private static final String sp_get_decision_case_competition_notfinish = "call sp_get_decision_case_competition_notfinish(?)";
		private static final String sp_update_evaluate_competition = "call sp_update_evaluate_competition(?,?,?,?,?,?)";
		private static final String sp_count_evaluate = "call sp_count_evaluate(?)";

		@Override
		public List<CaseCompetitionVO> selectCaseCompetitionNotFinish(String groupId) {
			List<CaseCompetitionVO> list = new ArrayList<CaseCompetitionVO>();
			CaseCompetitionVO caseCompetitionVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case_competition_notfinish);
				pstmt.setString(1, groupId);
				
				rs = pstmt.executeQuery();

				while (rs.next()) {
					// tb_case
					caseCompetitionVO = new CaseCompetitionVO();
					caseCompetitionVO.setCompetition_id(null2Str(rs.getString("competition_id")));
					caseCompetitionVO.setCase_id(null2Str(rs.getString("case_id")));
					caseCompetitionVO.setGroup_id(null2Str(rs.getString("group_id")));
					caseCompetitionVO.setBcircle_id(null2Str(rs.getString("bcircle_id")));
					caseCompetitionVO.setCompetition_no(null2Int(rs.getInt("competition_no")));
					caseCompetitionVO.setCompetition_name(null2Str(rs.getString("competition_name")));
					caseCompetitionVO.setEvaluate_no(null2Int(rs.getInt("evaluate_no")));
					caseCompetitionVO.setEvaluate(null2Str(rs.getString("evaluate")));
					caseCompetitionVO.setEvaluate_1_no(null2Str(rs.getString("evaluate_1_no")));
					caseCompetitionVO.setEvaluate_1(null2Str(rs.getString("evaluate_1")));
					caseCompetitionVO.setEnding_time(null2Str(rs.getString("ending_time")));
					caseCompetitionVO.setResult(null2Str(rs.getString("result")));
					caseCompetitionVO.setIsfinish(null2Int(rs.getString("isfinish")));
					// tb_city
					caseCompetitionVO.setCity_city_name(null2Str(rs.getString("city_name")));
					caseCompetitionVO.setCity_country_id(null2Str(rs.getString("country_id")));
					// tb_country
					caseCompetitionVO.setCountry_country_name(null2Str(rs.getString("country_name")));
					// tb_bcircle
					caseCompetitionVO.setBcircle_bcircle_name(null2Str(rs.getString("bcircle_name")));

					list.add(caseCompetitionVO); // Store the row in the list
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
		public void updateEvaluateCompetition(String competition_id, String user_id, String evaluate_point,
				String evaluate_reason, String evaluate_1_point, String evaluate_seq) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);

				CallableStatement cs = null;
				cs = con.prepareCall(sp_update_evaluate_competition);

				cs.setString(1, null2Str(competition_id));
				cs.setString(2, null2Str(user_id));
				cs.setString(3, null2Str(evaluate_point));
				cs.setString(4, null2Str(evaluate_reason));
				cs.setString(5, null2Str(evaluate_1_point));
				cs.setString(6, null2Str(evaluate_seq));

				cs.execute();

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

		@Override
		public void countByCompetitionIdDB(String competition_id) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);

				CallableStatement cs = null;
				cs = con.prepareCall(sp_count_evaluate);

				cs.setString(1, competition_id);

				ResultSet rs = null;

				Integer cnt = 0;
				rs = cs.executeQuery();
				while (rs.next()) {
					cnt = rs.getInt("cnt");

					logger.debug("countByCompetitionIdDB: getCnt: " + cnt);
				}

				if (cnt == 0) {

					String serviceStr = getServletConfig().getServletContext().getInitParameter("pythonwebservice")
							+ "/groupdecision/type=" + new String(Base64.encodeBase64String("3".getBytes())) + "&case="
							+ new String(Base64.encodeBase64String(competition_id.getBytes("UTF-8")));

					logger.debug(serviceStr);

					HttpClient client = new HttpClient();
					HttpMethod method = null;

					try {
						method = new GetMethod(serviceStr);
						client.executeMethod(method);
					} catch (Exception e) {
						logger.error("WebService Error for:" + e);
					} finally {
						method.releaseConnection();
					}

				}

			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (UnsupportedEncodingException e1) {
				throw new RuntimeException("A database error occured. " + e1.getMessage());
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

	private String null2Str(Object object) {
		if (object instanceof Timestamp)
			return object == null ? "" : new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(object);
		return object == null ? "" : object.toString().trim();
	}

	private Integer null2Int(Object object) {
		String s = object == null ? "0" : String.valueOf(object);
		return object == null ? 0 : Integer.valueOf(s);
	}
}
