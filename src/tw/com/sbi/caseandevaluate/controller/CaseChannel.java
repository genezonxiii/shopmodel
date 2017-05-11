package tw.com.sbi.caseandevaluate.controller;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import tw.com.sbi.vo.CaseChannelVO;
import tw.com.sbi.vo.CaseVO;
import tw.com.sbi.vo.EvaluateChannelVO;
import tw.com.sbi.vo.UserVO;

public class CaseChannel extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final Logger logger = LogManager.getLogger(CaseChannel.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String groupId = request.getSession().getAttribute("group_id").toString();
		logger.debug("group_id:" + groupId);

		CaseService caseService = null;

		String action = request.getParameter("action");
		logger.debug("Action: " + action);
		
		if ("getDecisionCaseFinish".equals(action)) {
			try {
				caseService = new CaseService();
				List<CaseVO> list = caseService.selectCaseFinish(groupId);
				String jsonStrList = new Gson().toJson(list);
				response.getWriter().write(jsonStrList);
				return;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("selectAll".equals(action)) {
			try {
				caseService = new CaseService();
				String group_id = request.getSession().getAttribute("group_id").toString();
				List<UserVO> list = caseService.getSearchAllDB(group_id);
				String jsonStrList = new Gson().toJson(list);
				response.getWriter().write(jsonStrList);
				return;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("insert".equals(action)) {
			String[] user_rdo_arr = request.getParameterValues("user_rdo_arr[]");
			String[] user_text_arr = request.getParameterValues("user_text_arr[]");
			String decision_case_finish_json_params = request.getParameter("decision_case_finish_json_params");

			caseService = new CaseService();

			CaseVO caseVO = null;
			try {
				decision_case_finish_json_params = decision_case_finish_json_params.replace("$", "\"");
				logger.debug("decision_case_finish_json_params : " + decision_case_finish_json_params);
				logger.debug("===========================================================================");
				caseVO = new Gson().fromJson(decision_case_finish_json_params, CaseVO.class);
			} catch (JsonSyntaxException e) {
				e.printStackTrace();
			}
			if (caseVO != null) {
				String case_id = null;
				String group_id = null;
				String bcircle_id = null;
				Integer channel_no = null;
				String channel_name = null;
				Integer evaluate_no = null;
				String evaluate = null;
				String evaluate_1_no = null;
				String evaluate_1 = null;
				String result = null;
				try {
					case_id = caseVO.getCase_id() == null ? null : caseVO.getCase_id();
					group_id = request.getSession().getAttribute("group_id").toString();
					channel_no = request.getParameter("channel_no") == null ? null
							: Integer.valueOf(request.getParameter("channel_no"));
					channel_name = request.getParameter("channel_name") == null ? null
							: request.getParameter("channel_name");
					evaluate_no = request.getParameter("evaluate_no") == null ? null
							: Integer.valueOf(request.getParameter("evaluate_no"));
					evaluate = request.getParameter("evaluate") == null ? null : request.getParameter("evaluate");
					evaluate_1_no = request.getParameter("evaluate_1_no") == null ? null
							: request.getParameter("evaluate_1_no");
					evaluate_1_no = evaluate_1_no == null ? null : evaluate_1_no.replace("null", "");
					evaluate_1 = request.getParameter("evaluate_1") == null ? null : request.getParameter("evaluate_1");

					result = caseVO.getResult() == null ? null : caseVO.getResult();
					result = result == null ? null : result.split("/")[0].split(":")[1].trim();
					bcircle_id = result == null ? null : caseService.getDecisionBcircleIdByName(result);

				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
				logger.debug("===========================================================================");
				for (String string : user_rdo_arr) {
					logger.debug("user_rdo_arr params : " + string);
				}
				logger.debug("user_rdo_arr length : " + user_rdo_arr.length);
				logger.debug("===========================================================================");
				for (String string : user_text_arr) {
					logger.debug("user_text_arr params : " + string);
				}
				logger.debug("user_text_arr length : " + user_text_arr.length);
				logger.debug("===========================================================================");
				logger.debug("case_id : " + case_id);
				logger.debug("groupId : " + group_id);
				logger.debug("bcircle_id : " + bcircle_id);
				logger.debug("channel_no : " + channel_no);
				logger.debug("channel_name : " + channel_name);
				logger.debug("evaluate_no : " + evaluate_no);
				logger.debug("evaluate : " + evaluate);
				logger.debug("evaluate_1_no : " + evaluate_1_no);
				logger.debug("evaluate_1 : " + evaluate_1);
				logger.debug("result : " + result);
				logger.debug("===========================================================================");
				String channel_id = caseService.addCasechannel(case_id, group_id, bcircle_id, channel_no, channel_name,
						evaluate_no, evaluate, evaluate_1_no, evaluate_1);
				logger.debug("channel_id : " + channel_id);
				logger.debug("===========================================================================");

				int loopCount = 0;

				//if (user_rdo_arr.length == user_text_arr.length) {
					Set<String> userIdSet = new HashSet<String>();

					HashMap<String, String> authorityMap = new HashMap<String, String>();

					if (user_rdo_arr.length > 0) {
						loopCount = user_rdo_arr.length;
						for (int i = 0; i < loopCount; i++) {
							String[] userAuthority = user_rdo_arr[i].split(",");
							authorityMap.put(userAuthority[0].trim(), userAuthority[1].trim());
							userIdSet.add(userAuthority[0].trim());
						}
					}

					HashMap<String, String> weightMap = new HashMap<String, String>();

					if (user_text_arr.length > 0) {
						loopCount = user_text_arr.length;
						for (int i = 0; i < loopCount; i++) {
							String[] userWeight = user_text_arr[i].split(",");
							weightMap.put(userWeight[0].trim(), userWeight[1].trim());
							userIdSet.add(userWeight[0].trim());
						}
					}

					if (!userIdSet.isEmpty()) {
						String evaluate_reason = "";
						String evaluate_point = "";
						String evaluate_1_point = "";
						String evaluate_seq = "";

						Iterator<String> it = null;

						it = userIdSet.iterator();

						while (it.hasNext()) {
							String user_id = it.next();
							String weight = weightMap.get(user_id);
							String user_authority = authorityMap.get(user_id);
							logger.debug("user_id : {} / weight : {} / authority : {}", user_id, weight,
									user_authority);
							caseService.addEvaluatechannel(channel_id, user_id, evaluate_reason, weight, user_authority,
									evaluate_point, evaluate_1_point, evaluate_seq);
						}
						logger.debug("===========================================================================");
					}
				//}
			}
		} else if ("getCase".equals(action)) {
			try {
				caseService = new CaseService();
				List<CaseChannelVO> list = caseService.selectCase(groupId);
				String jsonStrList = new Gson().toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
				return;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getCaseById".equals(action)) {
			try {
				caseService = new CaseService();
				String channel_id = request.getParameter("channel_id");
				List<CaseChannelVO> list = caseService.selectCaseById(channel_id);
				String jsonStrList = new Gson().toJson(list);
				logger.debug("jsonStrList: " + jsonStrList);
				response.getWriter().write(jsonStrList);
				return;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getEvaluate".equals(action)) {
			try {
				caseService = new CaseService();
				String channel_id = request.getParameter("channel_id");
				List<EvaluateChannelVO> list = caseService.selectEvaluateByChannelId(channel_id);
				String jsonStrList = new Gson().toJson(list);
				logger.debug("jsonStrList: " + jsonStrList);
				response.getWriter().write(jsonStrList);
				return;
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getEvaluateDetail".equals(action)) {
			try {
				caseService = new CaseService();
				String channel_id = request.getParameter("channel_id");
				String user_id = request.getParameter("user_id");
				List<EvaluateChannelVO> list = caseService.selectEvaluateDetailById(channel_id, user_id);
				String jsonStrList = new Gson().toJson(list);
				logger.debug("jsonStrList: " + jsonStrList);
				response.getWriter().write(jsonStrList);
				return;
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

		public List<CaseChannelVO> selectCase(String groupId) {
			return dao.selectCase(groupId);
		}

		public List<CaseChannelVO> selectCaseById(String channel_id) {
			return dao.selectCaseByChannelId(channel_id);
		}

		public List<CaseVO> selectCaseFinish(String groupId) {
			return dao.selectCaseFinish(groupId);
		}

		public List<UserVO> getSearchAllDB(String group_id) {
			return dao.searchAllDB(group_id);
		}

		public String getDecisionBcircleIdByName(String bcircle_name) {
			return dao.getDecisionBcircleIdByName(bcircle_name);
		}

		public String addCasechannel(String case_id, String group_id, String bcircle_id, Integer channel_no,
				String channel_name, Integer evaluate_no, String evaluate, String evaluate_1_no, String evaluate_1) {

			CaseChannelVO channelVO = new CaseChannelVO();

			channelVO.setCase_id(case_id);
			channelVO.setGroup_id(group_id);
			channelVO.setBcircle_id(bcircle_id);
			channelVO.setChannel_no(channel_no);
			channelVO.setChannel_name(channel_name);
			channelVO.setEvaluate_no(evaluate_no);
			channelVO.setEvaluate(evaluate);
			channelVO.setEvaluate_1_no(evaluate_1_no);
			channelVO.setEvaluate_1(evaluate_1);

			String channel_id = dao.insertCasechannel(channelVO);

			return channel_id;
		}

		public void addEvaluatechannel(String channel_id, String user_id, String evaluate_reason, String weight,
				String user_authority, String evaluate_point, String evaluate_1_point, String evaluate_seq) {

			EvaluateChannelVO evaluatechannelVO = new EvaluateChannelVO();

			evaluatechannelVO.setChannel_id(channel_id);
			evaluatechannelVO.setUser_id(user_id);
			evaluatechannelVO.setEvaluate_reason(evaluate_reason);
			evaluatechannelVO.setWeight(weight);
			evaluatechannelVO.setUser_authority(user_authority);
			evaluatechannelVO.setEvaluate_point(evaluate_point);
			evaluatechannelVO.setEvaluate_1_point(evaluate_1_point);
			evaluatechannelVO.setEvaluate_seq(evaluate_seq);

			dao.insertEvaluatechannel(evaluatechannelVO);
		}

		public List<EvaluateChannelVO> selectEvaluateByChannelId(String channel_id) {
			return dao.selectEvaluateByChannelId(channel_id);
		}

		public List<EvaluateChannelVO> selectEvaluateDetailById(String channel_id, String user_id) {
			return dao.selectEvaluateDetailByChannelId(channel_id, user_id);
		}
	}

	/*************************** 制定規章方法 ****************************************/
	interface case_interface {
		public List<CaseVO> selectCaseFinish(String groupId);

		public String insertCasechannel(CaseChannelVO channelVO);

		public void insertEvaluatechannel(EvaluateChannelVO evaluatechannelVO);

		public List<UserVO> searchAllDB(String group_id);

		public String getDecisionBcircleIdByName(String bcircle_name);

		public List<EvaluateChannelVO> selectEvaluateDetailByChannelId(String channel_id, String user_id);

		public List<CaseChannelVO> selectCase(String groupId);

		public List<CaseChannelVO> selectCaseByChannelId(String channel_id);

		public List<EvaluateChannelVO> selectEvaluateByChannelId(String cchannel_id);
	}

	/*************************** 操作資料庫 ****************************************/
	class CaseDAO implements case_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		// 會使用到的Stored procedure
		private static final String sp_get_decision_case_finish = "call sp_get_decision_case_finish(?)";
		private static final String sp_insert_case_channel = "call sp_insert_case_channel(?,?,?,?,?,?,?,?,?,?)";
		private static final String sp_insert_evaluate_channel = "call sp_insert_evaluate_channel(?,?,?,?,?,?,?,?)";
		private static final String sp_selectall_user = "call sp_selectall_user(?)";
		private static final String sp_get_decision_BD_by_name = "call sp_get_decision_BD_by_name(?)";
		private static final String sp_get_decision_evaluate_channel_detail_by_channel_id = "call sp_get_decision_evaluate_channel_detail_by_channel_id(?,?)";
		private static final String sp_get_decision_case_channel = "call sp_get_decision_case_channel(?)";
		private static final String sp_get_decision_case_channel_by_channel_id = "call sp_get_decision_case_channel_by_channel_id(?)";
		private static final String sp_get_decision_evaluate_channel_by_channel_id = "call sp_get_decision_evaluate_channel_by_channel_id(?)";

		@Override
		public List<CaseVO> selectCaseFinish(String groupId) {
			List<CaseVO> list = new ArrayList<CaseVO>();
			CaseVO caseVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case_finish);
				pstmt.setString(1, groupId);
				
				rs = pstmt.executeQuery();

				while (rs.next()) {
					caseVO = new CaseVO();
					caseVO.setCase_id(rs.getString("case_id") == null ? "" : rs.getString("case_id"));
					caseVO.setGroup_id(rs.getString("group_id") == null ? "" : rs.getString("group_id"));
					caseVO.setCity_id(rs.getString("city_id") == null ? "" : rs.getString("city_id"));
					caseVO.setBcircle_id(rs.getString("bcircle_id") == null ? "" : rs.getString("bcircle_id"));
					caseVO.setPreference(rs.getString("preference") == null ? "" : rs.getString("preference"));
					caseVO.setEvaluate_no(rs.getString("evaluate_no") == null ? "" : rs.getString("evaluate_no"));
					caseVO.setEvaluate(rs.getString("evaluate") == null ? "" : rs.getString("evaluate"));
					caseVO.setEvaluate_1_no(rs.getString("evaluate_1_no") == null ? "" : rs.getString("evaluate_1_no"));
					caseVO.setEvaluate_1(rs.getString("evaluate_1") == null ? "" : rs.getString("evaluate_1"));
					caseVO.setEnding_time(rs.getString("ending_time") == null ? "" : rs.getString("ending_time"));

					String businessDistrict = rs.getString("result") == null ? ""
							: (businessDistrict = rs.getString("result").split(";")[0].split(",")[0]);
					String fraction = rs.getString("result") == null ? ""
							: (fraction = rs.getString("result").split(";")[0].split(",")[1]);
					StringBuffer strbuf = new StringBuffer();
					strbuf = businessDistrict.length() > 0 && fraction.length() > 0
							? strbuf.append("商圈為: ").append(businessDistrict).append(" / 分數為: ").append(fraction)
							: null;
					String result = strbuf == null ? "" : strbuf.toString();

					caseVO.setResult(result);
					caseVO.setIsfinish(rs.getString("isfinish") == null ? "" : rs.getString("isfinish"));
					caseVO.setV_city_name(rs.getString("city_name") == null ? "" : rs.getString("city_name"));
					caseVO.setV_country_id(rs.getString("country_id") == null ? "" : rs.getString("country_id"));
					caseVO.setV_country(rs.getString("country_name") == null ? "" : rs.getString("country_name"));

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
		public String insertCasechannel(CaseChannelVO channelVO) {
			Connection con = null;
			PreparedStatement pstmt = null;
			String channel_id = null;
			try {
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);

				CallableStatement cs = null;
				cs = con.prepareCall(sp_insert_case_channel);

				cs.setString(1, null2Str(channelVO.getCase_id()));
				cs.setString(2, null2Str(channelVO.getGroup_id()));
				cs.setString(3, null2Str(channelVO.getBcircle_id()));
				cs.setString(4, null2Str(channelVO.getChannel_no()));
				cs.setString(5, null2Str(channelVO.getChannel_name()));
				cs.setString(6, null2Str(channelVO.getEvaluate_no()));
				cs.setString(7, null2Str(channelVO.getEvaluate()));
				cs.setString(8, null2Str(channelVO.getEvaluate_1_no()));
				cs.setString(9, null2Str(channelVO.getEvaluate_1()));

				cs.registerOutParameter(10, Types.VARCHAR);

				cs.execute();
				channel_id = cs.getString(10);

				return channel_id;

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
		public void insertEvaluatechannel(EvaluateChannelVO evaluatechannelVO) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);

				CallableStatement cs = null;
				cs = con.prepareCall(sp_insert_evaluate_channel);

				cs.setString(1, null2Str(evaluatechannelVO.getChannel_id()));
				cs.setString(2, null2Str(evaluatechannelVO.getUser_id()));
				cs.setString(3, null2Str(evaluatechannelVO.getEvaluate_reason()));
				cs.setString(4, null2Str(evaluatechannelVO.getWeight()));
				cs.setString(5, evaluatechannelVO.getUser_authority());
				cs.setString(6, null2Str(evaluatechannelVO.getEvaluate_point()));
				cs.setString(7, null2Str(evaluatechannelVO.getEvaluate_1_point()));
				cs.setString(8, null2Str(evaluatechannelVO.getEvaluate_seq()));

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
		public List<UserVO> searchAllDB(String group_id) {
			List<UserVO> list = new ArrayList<UserVO>();
			UserVO UserVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_selectall_user);
				pstmt.setString(1, group_id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					UserVO = new UserVO();
					UserVO.setUser_id(rs.getString("user_id"));
					UserVO.setGroup_id(rs.getString("group_id"));
					UserVO.setUser_name(rs.getString("user_name"));
					UserVO.setEmail(rs.getString("email"));
					UserVO.setPassword(rs.getString("password"));
					UserVO.setAdministrator(rs.getString("administrator"));
					list.add(UserVO);
				}

			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				// Handle ClassNotFoundException errors
				throw new RuntimeException("A ClassNotFoundException error occured. " + cnfe.getMessage());
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
		public String getDecisionBcircleIdByName(String bcircle_name) {

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String result = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_BD_by_name);
				pstmt.setString(1, bcircle_name);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					result = rs.getString("bcircle_id");
				}

			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				// Handle ClassNotFoundException errors
				throw new RuntimeException("A ClassNotFoundException error occured. " + cnfe.getMessage());
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
			return result == null ? "" : result;
		}

		@Override
		public List<EvaluateChannelVO> selectEvaluateDetailByChannelId(String channel_id, String user_id) {
			List<EvaluateChannelVO> list = new ArrayList<EvaluateChannelVO>();
			EvaluateChannelVO evaluateChannelVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_evaluate_channel_detail_by_channel_id);
				pstmt.setString(1, channel_id);
				pstmt.setString(2, user_id);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					evaluateChannelVO = new EvaluateChannelVO();
					// tb_evaluate_channel
					evaluateChannelVO.setEvaluate_channel_id(null2Str(rs.getString("evaluate_channel_id")));
					evaluateChannelVO.setChannel_id(null2Str(rs.getString("channel_id")));
					evaluateChannelVO.setUser_id(null2Str(rs.getString("user_id")));
					evaluateChannelVO.setEvaluate_1_point(null2Str(rs.getString("evaluate_1_point")));
					// tb_case_channel
					evaluateChannelVO.setEvaluate_no(null2Str(rs.getString("evaluate_no")));
					evaluateChannelVO.setEvaluate_1_no(null2Str(rs.getString("evaluate_1_no")));
					evaluateChannelVO.setEvaluate(null2Str(rs.getString("evaluate")));
					evaluateChannelVO.setEvaluate_1(null2Str(rs.getString("evaluate_1")));
					// tb_user
					evaluateChannelVO.setUser_name(null2Str(rs.getString("user_name")));
					list.add(evaluateChannelVO);
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
		public List<CaseChannelVO> selectCase(String groupId) {
			List<CaseChannelVO> list = new ArrayList<CaseChannelVO>();
			CaseChannelVO caseChannelVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case_channel);
				pstmt.setString(1, groupId);
				
				rs = pstmt.executeQuery();

				while (rs.next()) {
					caseChannelVO = new CaseChannelVO();
					// tb_case_channel
					caseChannelVO.setChannel_id(null2Str(rs.getString("channel_id")));
					caseChannelVO.setCase_id(null2Str(rs.getString("case_id")));
					caseChannelVO.setGroup_id(null2Str(rs.getString("group_id")));
					caseChannelVO.setBcircle_id(null2Str(rs.getString("bcircle_id")));
					caseChannelVO.setChannel_no(null2Int(rs.getInt("channel_no")));
					caseChannelVO.setChannel_name(null2Str(rs.getString("channel_name")));
					caseChannelVO.setEvaluate_no(null2Int(rs.getInt("evaluate_no")));
					caseChannelVO.setEvaluate(null2Str(rs.getString("evaluate")));
					caseChannelVO.setEvaluate_1_no(null2Str(rs.getString("evaluate_1_no")));
					caseChannelVO.setEvaluate_1(null2Str(rs.getString("evaluate_1")));
					caseChannelVO.setEnding_time(null2Str(rs.getString("ending_time")));
					
					String businessDistrict = rs.getString("result") == null ? ""
							: (businessDistrict = rs.getString("result").split(";")[0].split(",")[0]);
					String fraction = rs.getString("result") == null ? ""
							: (fraction = rs.getString("result").split(";")[0].split(",")[1]);
					StringBuffer strbuf = new StringBuffer();
					strbuf = businessDistrict.length() > 0 && fraction.length() > 0
							? strbuf.append("通路為: ").append(businessDistrict).append(" / 分數為: ").append(fraction)
							: null;
					String result = strbuf == null ? "" : strbuf.toString();
					
					caseChannelVO.setResult(null2Str(result));
					caseChannelVO.setIsfinish(null2Int(rs.getString("isfinish")));
					// tb_city
					caseChannelVO.setCity_city_name(null2Str(rs.getString("city_name")));
					caseChannelVO.setCity_country_id(null2Str(rs.getString("country_id")));
					// tb_country
					caseChannelVO.setCountry_country_name(null2Str(rs.getString("country_name")));

					list.add(caseChannelVO); // Store the row in the list
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
		public List<CaseChannelVO> selectCaseByChannelId(String channel_id) {
			List<CaseChannelVO> list = new ArrayList<CaseChannelVO>();
			CaseChannelVO caseChannelVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_case_channel_by_channel_id);
				pstmt.setString(1, null2Str(channel_id));

				rs = pstmt.executeQuery();
				while (rs.next()) {
					caseChannelVO = new CaseChannelVO();
					// tb_case_channel
					caseChannelVO.setChannel_id(null2Str(rs.getString("channel_id")));
					caseChannelVO.setCase_id(null2Str(rs.getString("case_id")));
					caseChannelVO.setGroup_id(null2Str(rs.getString("group_id")));
					caseChannelVO.setBcircle_id(null2Str(rs.getString("bcircle_id")));
					caseChannelVO.setChannel_no(null2Int(rs.getInt("channel_no")));
					caseChannelVO.setChannel_name(null2Str(rs.getString("channel_name")));
					caseChannelVO.setEvaluate_no(null2Int(rs.getInt("evaluate_no")));
					caseChannelVO.setEvaluate(null2Str(rs.getString("evaluate")));
					caseChannelVO.setEvaluate_1_no(null2Str(rs.getString("evaluate_1_no")));
					caseChannelVO.setEvaluate_1(null2Str(rs.getString("evaluate_1")));
					caseChannelVO.setEnding_time(null2Str(rs.getString("ending_time")));
					caseChannelVO.setResult(null2Str(rs.getString("result")));
					caseChannelVO.setIsfinish(null2Int(rs.getString("isfinish")));
					// tb_city
					caseChannelVO.setCity_city_name(null2Str(rs.getString("city_name")));
					caseChannelVO.setV_decision_proposal(null2Str(rs.getString("decision_proposal")));
					caseChannelVO.setCity_country_id(null2Str(rs.getString("country_id")));
					// tb_country
					caseChannelVO.setCountry_country_name(null2Str(rs.getString("country_name")));

					list.add(caseChannelVO); // Store the row in the list
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
		public List<EvaluateChannelVO> selectEvaluateByChannelId(String channel_id) {
			List<EvaluateChannelVO> list = new ArrayList<EvaluateChannelVO>();
			EvaluateChannelVO evaluateChannelVO = null;

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_get_decision_evaluate_channel_by_channel_id);
				pstmt.setString(1, channel_id);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					evaluateChannelVO = new EvaluateChannelVO();
					// tb_evaluate_channel
					evaluateChannelVO.setEvaluate_channel_id(null2Str(rs.getString("evaluate_channel_id")));
					evaluateChannelVO.setChannel_id(null2Str(rs.getString("channel_id")));
					evaluateChannelVO.setUser_id(null2Str(rs.getString("user_id")));
					evaluateChannelVO.setEvaluate_reason(null2Str(rs.getString("evaluate_reason")));
					evaluateChannelVO.setWeight(null2Str(rs.getString("weight")));
					evaluateChannelVO.setUser_authority(null2Str(rs.getString("user_authority")));
					evaluateChannelVO.setEvaluate_point(null2Str(rs.getString("evaluate_point")));
					evaluateChannelVO.setEvaluate_1_point(null2Str(rs.getString("evaluate_1_point")));
					evaluateChannelVO.setEvaluate_seq(null2Str(rs.getString("evaluate_seq")));
					// tb_user
					evaluateChannelVO.setUser_name(null2Str(rs.getString("user_name")));
					list.add(evaluateChannelVO);
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
