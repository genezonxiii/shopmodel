package tw.com.sbi.productforecastpoint.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
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

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;

import tw.com.sbi.caseandevaluate.controller.Evaluate.EvaluateService;
import tw.com.sbi.vo.EvaluateVO;

public class ProductForecastPoint extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LogManager.getLogger(ProductForecastPoint.class);
      
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.debug("product forecast point doPost.");

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		ProductForecastPointService productForecastPointService = null;
		
		String action = request.getParameter("action");
		logger.debug("action: " + action);
		
		if ("insert".equals(action)) {
			try {
				
				/*************************** 1.接收請求參數 **************************************/
				String forecast_id = request.getParameter("forecast_id");
				String user_id = request.getParameter("user_id");
				Integer weight = Integer.valueOf( request.getParameter("weight") );
				String function_point = request.getParameter("function_point");
				String nfunction_point = request.getParameter("nfunction_point");
				String service_point = request.getParameter("service_point");
				String score_seq = request.getParameter("score_seq");
				
				logger.debug("forecast_id:" + forecast_id);
				logger.debug("user_id:" + user_id);
				logger.debug("weight:" + weight);
				logger.debug("function_point:" + function_point);
				logger.debug("nfunction_point:" + nfunction_point);
				logger.debug("service_point:" + service_point);
				logger.debug("score_seq:" + score_seq);
				
				/*************************** 2.開始新增資料 ***************************************/
				productForecastPointService = new ProductForecastPointService();
				productForecastPointService.addProductForecastPoint(forecast_id, user_id, weight, function_point, nfunction_point, service_point, score_seq);

				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				ProductForecastPointBean productForecastPointBean = new ProductForecastPointBean();
				productForecastPointBean.setMessage("新增成功");
				
				List<ProductForecastPointBean> list = new ArrayList<ProductForecastPointBean>();
				Gson gson = new Gson();
				list.add(productForecastPointBean);
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("update".equals(action)) {
			try {
				
				/*************************** 1.接收請求參數 **************************************/
				String forecast_id = request.getParameter("forecast_id");
				String user_id = request.getParameter("user_id");
				String function_point = request.getParameter("function_point") == null 
						|| request.getParameter("function_point") == ""? 
						"0":request.getParameter("function_point");
				String nfunction_point = request.getParameter("nfunction_point") == null 
						|| request.getParameter("nfunction_point") == ""? 
						"0":request.getParameter("nfunction_point");
				String service_point = request.getParameter("service_point") == null 
						|| request.getParameter("service_point") == ""? 
						"0":request.getParameter("service_point");
				
				logger.debug("forecast_id:" + forecast_id);
				logger.debug("user_id:" + user_id);
				logger.debug("function_point:" + function_point);
				logger.debug("nfunction_point:" + nfunction_point);
				logger.debug("service_point:" + service_point);
				
				/*************************** 2.開始新增資料 ***************************************/
				productForecastPointService = new ProductForecastPointService();
				productForecastPointService.updateProductForecastPoint(forecast_id, user_id, function_point, nfunction_point, service_point);
	
				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				ProductForecastPointBean productForecastPointBean = new ProductForecastPointBean();
				productForecastPointBean.setMessage("更新成功");
				
				List<ProductForecastPointBean> list = new ArrayList<ProductForecastPointBean>();
				Gson gson = new Gson();
				list.add(productForecastPointBean);
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
				//檢查是否全部填寫完畢
				productForecastPointService.countProductForecastPoint(forecast_id);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getPoint".equals(action)) {
			try {
				String forecastId = request.getParameter("forecast_id");
				
				logger.debug("forecast_id:" + forecastId);
				
				ProductForecastPointBean paramBean = new ProductForecastPointBean();
				paramBean.setForecast_id(forecastId);
				
				productForecastPointService = new ProductForecastPointService();
				List<ProductForecastPointBean> list = productForecastPointService.selectPointByForecastId(paramBean);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getPointDetail".equals(action)) {
			try {
				String forecastId = request.getParameter("forecast_id");
				String userId = request.getParameter("user_id");

				logger.debug("forecast_id:" + forecastId);
				logger.debug("user_id:" + userId);
				
				ProductForecastPointBean paramBean = new ProductForecastPointBean();
				paramBean.setForecast_id(forecastId);
				paramBean.setUser_id(userId);
				
				productForecastPointService = new ProductForecastPointService();
				List<ProductForecastPointBean> list = productForecastPointService.selectPointDetailByForecastId(paramBean);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				logger.debug(jsonStrList);
				response.getWriter().write(jsonStrList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	/************************* 對應資料庫表格格式 **************************************/
	@SuppressWarnings("serial")
	public class ProductForecastPointBean implements java.io.Serializable {

		private String message;// for set check message
		private String forecast_point_id;
		private String forecast_id;
		private String user_id;
		private Integer weight;
		private String function_point;
		private String nfunction_point;
		private String service_point;
		private String score_seq;
		private String v_user_name;
		private String v_function_no;
		private String v_function_name;
		private String v_nfunction_no;
		private String v_nfunction_name;
		private String v_service_no;
		private String v_service_name;
		
		public String getMessage() {
			return message;
		}
		public void setMessage(String message) {
			this.message = message;
		}
		public String getForecast_point_id() {
			return forecast_point_id;
		}
		public void setForecast_point_id(String forecast_point_id) {
			this.forecast_point_id = forecast_point_id;
		}
		public String getForecast_id() {
			return forecast_id;
		}
		public void setForecast_id(String forecast_id) {
			this.forecast_id = forecast_id;
		}
		public String getUser_id() {
			return user_id;
		}
		public void setUser_id(String user_id) {
			this.user_id = user_id;
		}
		public Integer getWeight() {
			return weight;
		}
		public void setWeight(Integer weight) {
			this.weight = weight;
		}
		public String getFunction_point() {
			return function_point;
		}
		public void setFunction_point(String function_point) {
			this.function_point = function_point;
		}
		public String getNfunction_point() {
			return nfunction_point;
		}
		public void setNfunction_point(String nfunction_point) {
			this.nfunction_point = nfunction_point;
		}
		public String getService_point() {
			return service_point;
		}
		public void setService_point(String service_point) {
			this.service_point = service_point;
		}
		public String getScore_seq() {
			return score_seq;
		}
		public void setScore_seq(String score_seq) {
			this.score_seq = score_seq;
		}
		public String getV_user_name() {
			return v_user_name;
		}
		public void setV_user_name(String v_user_name) {
			this.v_user_name = v_user_name;
		}
		public String getV_function_no() {
			return v_function_no;
		}
		public void setV_function_no(String v_function_no) {
			this.v_function_no = v_function_no;
		}
		public String getV_function_name() {
			return v_function_name;
		}
		public void setV_function_name(String v_function_name) {
			this.v_function_name = v_function_name;
		}
		public String getV_nfunction_no() {
			return v_nfunction_no;
		}
		public void setV_nfunction_no(String v_nfunction_no) {
			this.v_nfunction_no = v_nfunction_no;
		}
		public String getV_nfunction_name() {
			return v_nfunction_name;
		}
		public void setV_nfunction_name(String v_nfunction_name) {
			this.v_nfunction_name = v_nfunction_name;
		}
		public String getV_service_no() {
			return v_service_no;
		}
		public void setV_service_no(String v_service_no) {
			this.v_service_no = v_service_no;
		}
		public String getV_service_name() {
			return v_service_name;
		}
		public void setV_service_name(String v_service_name) {
			this.v_service_name = v_service_name;
		}
		
	}

	/*************************** 制定規章方法 ****************************************/
	interface productForecastPoint_interface {
		
		public void insertDB(ProductForecastPointBean productForecastBean);
		public void updateDB(ProductForecastPointBean productForecastBean);
		public void countByForecastIdDB(String forecast_id);
		public List<ProductForecastPointBean> selectPointByForecastId(ProductForecastPointBean productForecastBean);
		public List<ProductForecastPointBean> selectPointDetailByForecastId(ProductForecastPointBean productForecastBean);

	}
	
	/*************************** 處理業務邏輯 ****************************************/
	public class ProductForecastPointService {
		private productForecastPoint_interface dao;

		public ProductForecastPointService() {
			dao = new ProductForecastPointDAO();
		}
		
		public ProductForecastPointBean addProductForecastPoint(String forecast_id, String user_id, Integer weight, String function_point, String nfunction_point,
				String service_point, String score_seq) {
			ProductForecastPointBean productForecastPointBean = new ProductForecastPointBean();
			
			productForecastPointBean.setForecast_id(forecast_id);
			productForecastPointBean.setUser_id(user_id);
			productForecastPointBean.setWeight(weight);
			productForecastPointBean.setFunction_point(function_point);
			productForecastPointBean.setNfunction_point(nfunction_point);

			productForecastPointBean.setService_point(service_point);
			productForecastPointBean.setScore_seq(score_seq);
			
			dao.insertDB(productForecastPointBean);
		
			return productForecastPointBean;
		}

		public ProductForecastPointBean updateProductForecastPoint(String forecast_id, String user_id, String function_point, String nfunction_point, String service_point) {
			ProductForecastPointBean productForecastPointBean = new ProductForecastPointBean();
			
			productForecastPointBean.setForecast_id(forecast_id);
			productForecastPointBean.setUser_id(user_id);
			productForecastPointBean.setFunction_point(function_point);
			productForecastPointBean.setNfunction_point(nfunction_point);
			productForecastPointBean.setService_point(service_point);
			
			dao.updateDB(productForecastPointBean);
		
			return productForecastPointBean;
		}

		public void countProductForecastPoint(String forecast_id) {
			dao.countByForecastIdDB(forecast_id);
		}
		
		public List<ProductForecastPointBean> selectPointByForecastId(ProductForecastPointBean paramBean) {
			return dao.selectPointByForecastId(paramBean);
		}
		
		public List<ProductForecastPointBean> selectPointDetailByForecastId(ProductForecastPointBean paramBean) {
			return dao.selectPointDetailByForecastId(paramBean);
		}
		
	}

	
	/*************************** 操作資料庫 ****************************************/
	class ProductForecastPointDAO implements productForecastPoint_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		// 會使用到的Stored procedure
		private static final String sp_insert_product_forecast_point = "call sp_insert_product_forecast_point(?,?,?,?,?,?,?)";
		private static final String sp_update_product_forecast_point = "call sp_update_product_forecast_point(?,?,?,?,?)";
		private static final String sp_count_product_forecast_point = "call sp_count_product_forecast_point(?)";
		private static final String sp_select_product_forecast_by_forecast_id = "call sp_select_product_forecast_by_forecast_id(?)";
		private static final String sp_get_point_by_forecast_id = "call sp_get_point_by_forecast_id(?)";
		private static final String sp_get_point_detail_by_forecast_id = "call sp_get_point_detail_by_forecast_id(?,?)";
		
		@Override
		public void insertDB(ProductForecastPointBean productForecastPointBean) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_insert_product_forecast_point);

				cs.setString(1, productForecastPointBean.getForecast_id());
				cs.setString(2, productForecastPointBean.getUser_id());
				cs.setInt(3, productForecastPointBean.getWeight());
				cs.setString(4, productForecastPointBean.getFunction_point());
				cs.setString(5, productForecastPointBean.getNfunction_point());
				cs.setString(6, productForecastPointBean.getService_point());
				cs.setString(7, productForecastPointBean.getScore_seq());
				
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
		public void updateDB(ProductForecastPointBean productForecastPointBean) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_update_product_forecast_point);

				cs.setString(1, productForecastPointBean.getForecast_id());
				cs.setString(2, productForecastPointBean.getUser_id());
				cs.setString(3, productForecastPointBean.getFunction_point());
				cs.setString(4, productForecastPointBean.getNfunction_point());
				cs.setString(5, productForecastPointBean.getService_point());
				
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
		public void countByForecastIdDB(String forecast_id) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_count_product_forecast_point);

				cs.setString(1, forecast_id);
				
				ResultSet rs = null;
				
				Integer cnt = 0;
				rs = cs.executeQuery();
				while (rs.next()) {
					cnt = rs.getInt("cnt");
					
					logger.debug("countByForecastIdDB:getCnt" + cnt);
				}
				
				if (cnt == 0) {
					CallableStatement cs2 = null;
					cs2 = con.prepareCall(sp_select_product_forecast_by_forecast_id);

					cs2.setString(1, forecast_id);
					
					ResultSet rs2 = null;
					
					String ref_prod = "";
					rs2 = cs2.executeQuery();
					while (rs2.next()) {
						ref_prod = rs2.getString("ref_prod");
						
						logger.debug("ref_prod:" + ref_prod);
						logger.debug("ref_prod(base64):" + Base64.encodeBase64String( ref_prod.getBytes("UTF-8")) );
					}
					
					String serviceStr = getServletConfig().getServletContext().getInitParameter("pythonwebservice")
							+ "/forecast/forid="
							+ new String(Base64.encodeBase64String( forecast_id.getBytes()) )
							+ "&findc="
							+ new String(Base64.encodeBase64String( ref_prod.getBytes("UTF-8")) );
					
					logger.debug(serviceStr);
					
					HttpClient client = new HttpClient();
					HttpMethod method = null;
					
					try {
						method = new GetMethod(serviceStr);
						client.executeMethod(method);
					} catch(Exception e) {
						logger.error("WebService Error for:"+e);
					} finally {
						method.releaseConnection();
					}
					
					
				}
				
			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (UnsupportedEncodingException e1) {
				throw new RuntimeException("A database error occured. " + e1.getMessage());
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
		public List<ProductForecastPointBean> selectPointByForecastId(ProductForecastPointBean productForecastBean){
			List<ProductForecastPointBean> list = new ArrayList<ProductForecastPointBean>();
			ProductForecastPointBean pointBean = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_get_point_by_forecast_id);

				cs.setString(1, productForecastBean.getForecast_id());
				
				rs = cs.executeQuery();
				while (rs.next()) {
					pointBean = new ProductForecastPointBean();
					
					pointBean.setForecast_id(rs.getString("forecast_id") == null?"":rs.getString("forecast_id"));
					pointBean.setV_user_name(rs.getString("user_name") == null?"":rs.getString("user_name"));
					pointBean.setUser_id(rs.getString("user_id") == null?"":rs.getString("user_id"));
					pointBean.setWeight(rs.getInt("weight"));
					
					list.add(pointBean); // Store the row in the list
				}
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
			return list;
		}
		
		@Override 
		public List<ProductForecastPointBean> selectPointDetailByForecastId(ProductForecastPointBean productForecastBean){
			List<ProductForecastPointBean> list = new ArrayList<ProductForecastPointBean>();
			ProductForecastPointBean pointBean = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_get_point_detail_by_forecast_id);

				cs.setString(1, productForecastBean.getForecast_id());
				cs.setString(2, productForecastBean.getUser_id());
				
				Integer cnt = 0;
				rs = cs.executeQuery();
				while (rs.next()) {
					pointBean = new ProductForecastPointBean();
					
					pointBean.setForecast_id(rs.getString("forecast_id") == null?"":rs.getString("forecast_id"));
					pointBean.setWeight(rs.getInt("weight"));
					pointBean.setScore_seq(rs.getString("score_seq") == null?"":rs.getString("score_seq"));
					pointBean.setFunction_point(rs.getString("function_point") == null?"":rs.getString("function_point"));
					pointBean.setNfunction_point(rs.getString("nfunction_point") == null?"":rs.getString("nfunction_point"));
					pointBean.setService_point(rs.getString("service_point") == null?"":rs.getString("service_point"));
					pointBean.setV_user_name(rs.getString("user_name") == null?"":rs.getString("user_name"));
					pointBean.setV_function_no(rs.getString("function_no") == null?"":rs.getString("function_no"));
					pointBean.setV_nfunction_name(rs.getString("nfunction_name") == null?"":rs.getString("nfunction_name"));
					pointBean.setV_nfunction_no(rs.getString("nfunction_no") == null?"":rs.getString("nfunction_no"));
					pointBean.setV_function_name(rs.getString("function_name") == null?"":rs.getString("function_name"));
					pointBean.setV_service_no(rs.getString("service_no") == null?"":rs.getString("service_no"));
					pointBean.setV_service_name(rs.getString("service_name") == null?"":rs.getString("service_name"));
					
					list.add(pointBean); // Store the row in the list
				}
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
			return list;
		}
	}

}