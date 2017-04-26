package tw.com.sbi.productforecast.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;

public class ProductForecast extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LogManager.getLogger(ProductForecast.class);
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.debug("product forecast doPost.");

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		ProductForecastService productForecastService = null;
		
		String action = request.getParameter("action");
		
		if ("insert".equals(action)) {
			try {
				
				/*************************** 1.接收請求參數 **************************************/
				String group_id = request.getParameter("group_id");
				String product_name = request.getParameter("product_name");
				Float cost = Float.valueOf( request.getParameter("cost") );
				String supply_name = request.getParameter("supply_name");
				BigDecimal function_no = new BigDecimal( request.getParameter("function_no") );
				String function_name = request.getParameter("function_name");
				String function_score = request.getParameter("function_score") == null 
						|| request.getParameter("function_score") == ""? 
						"0":request.getParameter("function_score");
				BigDecimal nfunction_no = new BigDecimal( request.getParameter("nfunction_no") );
				String nfunction_name = request.getParameter("nfunction_name");
				String nfunction_score = request.getParameter("nfunction_score") == null 
						|| request.getParameter("nfunction_score") == ""? 
						"0":request.getParameter("nfunction_score");
				BigDecimal service_no = new BigDecimal( request.getParameter("service_no") );
				String service_name = request.getParameter("service_name");
				String service_score = request.getParameter("service_score") == null 
						|| request.getParameter("service_score") == ""? 
						"0":request.getParameter("service_score");
				String ref_prod = request.getParameter("ref_prod");
				
//				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date score_time = null;
				String result = null;
				BigDecimal isfinish = new BigDecimal( request.getParameter("isfinish") );
				
				logger.debug("action: Insert");
				logger.debug("group_id:" + group_id);
				logger.debug("product_name:" + product_name);
				logger.debug("cost:" + cost);
				logger.debug("function_no:" + function_no);
				logger.debug("function_name:" + function_name);
				logger.debug("function_score:" + function_score);
				logger.debug("nfunction_no:" + nfunction_no);
				logger.debug("nfunction_name:" + nfunction_name);
				logger.debug("nfunction_score:" + nfunction_score);
				logger.debug("service_no:" + service_no);
				logger.debug("service_no:" + service_name);
				logger.debug("service_score:" + service_score);
				logger.debug("score_time:" + score_time);
				logger.debug("result:" + result);
				logger.debug("isfinish:" + isfinish);
				logger.debug("ref_prod:" + ref_prod);
				
				/*************************** 2.開始新增資料 ***************************************/
				productForecastService = new ProductForecastService();
				
				ProductForecastBean productForecastBean = new ProductForecastBean();
				
				productForecastBean = productForecastService.addProductForecast(group_id, product_name, cost, function_no, function_name, function_score, nfunction_no, nfunction_name, nfunction_score, service_no, service_name, service_score, score_time, result, isfinish, ref_prod);

				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				productForecastBean.setMessage("新增成功");
				
				List<ProductForecastBean> list = new ArrayList<ProductForecastBean>();
				Gson gson = new Gson();
				list.add(productForecastBean);
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("selectByGroupId".equals(action)) {
			try {
				
				/*************************** 1.接收請求參數 **************************************/
				String group_id = request.getParameter("group_id");
				
				logger.debug("action: selectByGroupId");
				logger.debug("group_id:" + group_id);
				
				/*************************** 2.開始新增資料 ***************************************/
				productForecastService = new ProductForecastService();
				
				List<ProductForecastBean> productForecastBeanList = new ArrayList<ProductForecastBean>();
				
				productForecastBeanList = productForecastService.selectByGroupId(group_id);

				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(productForecastBeanList);
				response.getWriter().write(jsonStrList);
				logger.debug("productForecastBeanList:" + jsonStrList);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("selectByForecastId".equals(action)) {
			try {
				
				/*************************** 1.接收請求參數 **************************************/
				String forecast_id = request.getParameter("forecast_id");
				
				logger.debug("action: selectByForecastId");
				logger.debug("forecast_id:" + forecast_id);
				
				/*************************** 2.開始新增資料 ***************************************/
				productForecastService = new ProductForecastService();
				
				List<ProductForecastBean> productForecastBeanList = new ArrayList<ProductForecastBean>();
				
				productForecastBeanList = productForecastService.selectByForecastId(forecast_id);

				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(productForecastBeanList);
				response.getWriter().write(jsonStrList);
				logger.debug("productForecastBeanList:" + jsonStrList);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getNews".equals(action)) {
			String serviceStr = getServletConfig().getServletContext().getInitParameter("pythonwebservice")
					+ "/news/";
			
			logger.debug(serviceStr);
			
			HttpGet httpRequest = new HttpGet(serviceStr);
        	HttpClient client = HttpClientBuilder.create().build();
        	HttpResponse httpResponse;
        	try {
        		StringBuffer result = new StringBuffer();
        		httpResponse = client.execute(httpRequest);
    			int responseCode = httpResponse.getStatusLine().getStatusCode();
    
    	    	if(responseCode==200){
    	    		BufferedReader rd = new BufferedReader(new InputStreamReader(httpResponse.getEntity().getContent()));
        			
        	    	String line = "";
        	    	while ((line = rd.readLine()) != null) {
        	    		result.append(line);
        	    	}
        	    	
        	    	response.getWriter().write(result.toString());
        	    	
    	    	} else {
    	    		response.getWriter().write("{url:'', title: ''}");
    	    	}
  	    	
    		} catch (ClientProtocolException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} catch (UnsupportedOperationException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
		}
	}
	
	/************************* 對應資料庫表格格式 **************************************/
	@SuppressWarnings("serial")
	public class ProductForecastBean implements java.io.Serializable {

		private String forecast_id;
		private String group_id;
		private String product_name;
		private Float cost;
		private BigDecimal function_no;
		private String function_name;
		private String function_score;
		private BigDecimal nfunction_no;
		private String nfunction_name;
		private String nfunction_score;
		private BigDecimal service_no;
		private String service_name;
		private String service_score;
		private Date score_time;
		private String result;
		private BigDecimal isfinish;
		private String ref_prod;
		private String message;// for set check message
		
		public String getForecast_id() {
			return forecast_id;
		}
		public void setForecast_id(String forecast_id) {
			this.forecast_id = forecast_id;
		}
		public String getGroup_id() {
			return group_id;
		}
		public void setGroup_id(String group_id) {
			this.group_id = group_id;
		}
		public String getProduct_name() {
			return product_name;
		}
		public void setProduct_name(String product_name) {
			this.product_name = product_name;
		}
		public Float getCost() {
			return cost;
		}
		public void setCost(Float cost) {
			this.cost = cost;
		}
		public BigDecimal getFunction_no() {
			return function_no;
		}
		public void setFunction_no(BigDecimal function_no) {
			this.function_no = function_no;
		}
		public String getFunction_name() {
			return function_name;
		}
		public void setFunction_name(String function_name) {
			this.function_name = function_name;
		}
		public String getFunction_score() {
			return function_score;
		}
		public void setFunction_score(String function_score) {
			this.function_score = function_score;
		}
		public BigDecimal getNfunction_no() {
			return nfunction_no;
		}
		public void setNfunction_no(BigDecimal nfunction_no) {
			this.nfunction_no = nfunction_no;
		}
		public String getNfunction_name() {
			return nfunction_name;
		}
		public void setNfunction_name(String nfunction_name) {
			this.nfunction_name = nfunction_name;
		}
		public String getNfunction_score() {
			return nfunction_score;
		}
		public void setNfunction_score(String nfunction_score) {
			this.nfunction_score = nfunction_score;
		}
		public BigDecimal getService_no() {
			return service_no;
		}
		public void setService_no(BigDecimal service_no) {
			this.service_no = service_no;
		}
		public String getService_name() {
			return service_name;
		}
		public void setService_name(String service_name) {
			this.service_name = service_name;
		}
		public String getService_score() {
			return service_score;
		}
		public void setService_score(String service_score) {
			this.service_score = service_score;
		}
		public Date getScore_time() {
			return score_time;
		}
		public void setScore_time(Date score_time) {
			this.score_time = score_time;
		}
		public String getResult() {
			return result;
		}
		public void setResult(String result) {
			this.result = result;
		}
		public BigDecimal getIsfinish() {
			return isfinish;
		}
		public void setIsfinish(BigDecimal isfinish) {
			this.isfinish = isfinish;
		}
		public String getRef_prod() {
			return ref_prod;
		}
		public void setRef_prod(String ref_prod) {
			this.ref_prod = ref_prod;
		}
		public String getMessage() {
			return message;
		}
		public void setMessage(String message) {
			this.message = message;
		}
		
	}

	/*************************** 制定規章方法 ****************************************/
	interface productForecast_interface {
		public String insertDB(ProductForecastBean productForecastBean);

		public void updateDB(ProductForecastBean productForecastBean);

		public void deleteDB(String product_id, String user_id);
		
		public List<ProductForecastBean> selectByGroupId(String group_id);
		
		public List<ProductForecastBean> selectByForecastId(String forecast_id);
		
	}

	/*************************** 處理業務邏輯 ****************************************/
	public class ProductForecastService {
		private productForecast_interface dao;

		public ProductForecastService() {
			dao = new ProductForecastDAO();
		}
		
		public ProductForecastBean addProductForecast(String group_id, String product_name, Float cost, BigDecimal function_no, String function_name,
				String function_score, BigDecimal nfunction_no, String nfunction_name, String nfunction_score, BigDecimal service_no,
				String service_name, String service_score, Date score_time, String result, BigDecimal isfinish, String ref_prod) {
			ProductForecastBean productForecastBean = new ProductForecastBean();
			
			productForecastBean.setGroup_id(group_id);
			productForecastBean.setProduct_name(product_name);
			productForecastBean.setCost(cost);
			productForecastBean.setFunction_no(function_no);
			productForecastBean.setFunction_name(function_name);

			productForecastBean.setFunction_score(function_score);
			productForecastBean.setNfunction_no(nfunction_no);
			productForecastBean.setNfunction_name(nfunction_name);
			productForecastBean.setNfunction_score(nfunction_score);
			productForecastBean.setService_no(service_no);
			
			productForecastBean.setService_name(service_name);
			productForecastBean.setService_score(service_score);
			productForecastBean.setScore_time(score_time);
			productForecastBean.setResult(result);
			productForecastBean.setIsfinish(isfinish);
			
			productForecastBean.setRef_prod(ref_prod);
			
			String forecast_id = dao.insertDB(productForecastBean);
			
			productForecastBean.setForecast_id(forecast_id);
			
			return productForecastBean;
		}

		public List<ProductForecastBean> selectByGroupId(String group_id) {
			return dao.selectByGroupId(group_id);
		}

		public List<ProductForecastBean> selectByForecastId(String forecast_id) {
			return dao.selectByForecastId(forecast_id);
		}
				
	}
	
	/*************************** 操作資料庫 ****************************************/
	class ProductForecastDAO implements productForecast_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");

		// 會使用到的Stored procedure
		private static final String sp_insert_product_forecast = "call sp_insert_product_forecast(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		private static final String sp_select_product_forecast_by_group_id = "call sp_select_product_forecast_by_group_id(?)";
		private static final String sp_select_product_forecast_by_forecast_id = "call sp_select_product_forecast_by_forecast_id(?)";
		
		@Override
		public String insertDB(ProductForecastBean productForecastBean) {
			Connection con = null;
			PreparedStatement pstmt = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				
				CallableStatement cs = null;
				cs = con.prepareCall(sp_insert_product_forecast);

				cs.setString(1, productForecastBean.getGroup_id());
				cs.setString(2, productForecastBean.getProduct_name());
				cs.setFloat(3, productForecastBean.getCost());
				cs.setBigDecimal(4, productForecastBean.getFunction_no());
				cs.setString(5, productForecastBean.getFunction_name());
				cs.setString(6, productForecastBean.getFunction_score());
				cs.setBigDecimal(7, productForecastBean.getNfunction_no());
				cs.setString(8, productForecastBean.getNfunction_name());
				cs.setString(9, productForecastBean.getNfunction_score());
				cs.setBigDecimal(10, productForecastBean.getService_no());
				cs.setString(11, productForecastBean.getService_name());
				cs.setString(12, productForecastBean.getService_score());
				cs.setDate(13, (java.sql.Date) productForecastBean.getScore_time());
				cs.setString(14, productForecastBean.getResult());
				cs.setBigDecimal(15, productForecastBean.getIsfinish());
				cs.setString(16, productForecastBean.getRef_prod());
				
				cs.registerOutParameter(17, Types.VARCHAR);

				cs.execute();
								
				return cs.getString(17);
			
			} catch (SQLException se) {
				// Handle any SQL errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("ClassNotFoundException: " + cnfe.getMessage());
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
		public void updateDB(ProductForecastBean productForecastBean) {
			
			
		}
		
		@Override
		public void deleteDB(String product_id, String user_id) {
			
		}
		
		@Override
		public List<ProductForecastBean> selectByGroupId(String group_id) {
			List<ProductForecastBean> list = new ArrayList<ProductForecastBean>();
			ProductForecastBean productForecastBean = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_select_product_forecast_by_group_id);
				pstmt.setString(1, group_id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					productForecastBean = new ProductForecastBean();
					
					productForecastBean.setForecast_id(rs.getString("forecast_id"));
					productForecastBean.setGroup_id(rs.getString("group_id"));
					productForecastBean.setProduct_name(rs.getString("product_name"));
					productForecastBean.setCost( rs.getFloat("cost") );
					productForecastBean.setFunction_no( rs.getBigDecimal("function_no") );
					productForecastBean.setFunction_name(rs.getString("function_name"));
					productForecastBean.setFunction_score(rs.getString("function_score"));
					productForecastBean.setNfunction_no( rs.getBigDecimal("nfunction_no") );
					productForecastBean.setNfunction_name(rs.getString("nfunction_name"));
					productForecastBean.setNfunction_score(rs.getString("nfunction_score"));
					productForecastBean.setService_no( rs.getBigDecimal("service_no") );
					productForecastBean.setService_name(rs.getString("service_name"));
					productForecastBean.setService_score(rs.getString("service_score"));
					productForecastBean.setScore_time( rs.getDate("score_time") );
					productForecastBean.setResult(rs.getString("result"));
					productForecastBean.setIsfinish( rs.getBigDecimal("isfinish") );
					productForecastBean.setRef_prod( rs.getString("ref_prod") );
					
					list.add(productForecastBean); // Store the row in the list
				}
				
				
			} catch (SQLException se) {
				// Handle any driver errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("ClassNotFoundException: " + cnfe.getMessage());
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
		public List<ProductForecastBean> selectByForecastId(String forecast_id) {
			List<ProductForecastBean> list = new ArrayList<ProductForecastBean>();
			ProductForecastBean productForecastBean = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_select_product_forecast_by_forecast_id);
				pstmt.setString(1, forecast_id);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					productForecastBean = new ProductForecastBean();
					
					productForecastBean.setForecast_id(rs.getString("forecast_id"));
					productForecastBean.setGroup_id(rs.getString("group_id"));
					productForecastBean.setProduct_name(rs.getString("product_name"));
					productForecastBean.setCost( rs.getFloat("cost") );
					productForecastBean.setFunction_no( rs.getBigDecimal("function_no") );
					productForecastBean.setFunction_name(rs.getString("function_name"));
					productForecastBean.setFunction_score(rs.getString("function_score"));
					productForecastBean.setNfunction_no( rs.getBigDecimal("nfunction_no") );
					productForecastBean.setNfunction_name(rs.getString("nfunction_name"));
					productForecastBean.setNfunction_score(rs.getString("nfunction_score"));
					productForecastBean.setService_no( rs.getBigDecimal("service_no") );
					productForecastBean.setService_name(rs.getString("service_name"));
					productForecastBean.setService_score(rs.getString("service_score"));
					productForecastBean.setScore_time( rs.getDate("score_time") );
					productForecastBean.setResult(rs.getString("result"));
					productForecastBean.setIsfinish( rs.getBigDecimal("isfinish") );
					productForecastBean.setRef_prod(rs.getString("ref_prod"));
					
					list.add(productForecastBean); // Store the row in the list
				}
				
				
			} catch (SQLException se) {
				// Handle any driver errors
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("ClassNotFoundException: " + cnfe.getMessage());
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

}