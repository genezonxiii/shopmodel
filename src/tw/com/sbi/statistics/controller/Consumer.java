package tw.com.sbi.statistics.controller;

import java.io.IOException;
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

import tw.com.sbi.vo.ConsumerVO;

public class Consumer extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final Logger logger = LogManager.getLogger(Consumer.class);
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		ConsumerService consumerService = null;

		String action = request.getParameter("action");
		
		logger.debug("Action: " + action);

		if ("getCity".equals(action)) {
			try {								
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectCity();
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getLayer".equals(action)) {
			try {
				String city = request.getParameter("city");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectLayer(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getType".equals(action)) {
			try {
				String city = request.getParameter("city");
				String layer = request.getParameter("layer");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setLayer(layer);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectType(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getItem".equals(action)) {
			try {
				String city = request.getParameter("city");
				String layer = request.getParameter("layer");
				String type = request.getParameter("type");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setLayer(layer);
				paramVO.setType(type);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectItem(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getSubItem".equals(action)) {
			try {
				String city = request.getParameter("city");
				String layer = request.getParameter("layer");
				String type = request.getParameter("type");
				String item = request.getParameter("item");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setLayer(layer);
				paramVO.setType(type);
				paramVO.setItem(item);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectSubItem(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getSubItemVariableName".equals(action)) {
			try {
				String city = request.getParameter("city");
				String layer = request.getParameter("layer");
				String type = request.getParameter("type");
				String item = request.getParameter("item");
				String subitem = request.getParameter("subitem");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setLayer(layer);
				paramVO.setType(type);
				paramVO.setItem(item);
				paramVO.setSubItem(subitem);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectSubItemVariableName(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getVariableName".equals(action)) {
			try {
				String city = request.getParameter("city");
				String layer = request.getParameter("layer");
				String type = request.getParameter("type");
				String item = request.getParameter("item");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setLayer(layer);
				paramVO.setType(type);
				paramVO.setItem(item);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectVariableName(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getYear".equals(action)) {
			try {
				String city = request.getParameter("city");
				String variableName = request.getParameter("variable_name");
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setVariableName(variableName);

				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectYear(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if ("getChart".equals(action)) {
			try {
				String city = request.getParameter("city");
				String variableName = request.getParameter("variable_name");
				String year = request.getParameter("year");
				String subItem = request.getParameter("subItem");
				
				logger.debug("city:".concat(city));
				logger.debug("variableName:".concat(variableName));
				logger.debug("year:".concat(year));
				logger.debug("subItem:".concat(subItem));
				
				ConsumerVO paramVO = new ConsumerVO();
				paramVO.setCity(city);
				paramVO.setVariableName(variableName);
				paramVO.setSubItem(subItem);
				paramVO.setYear(year);
				
				consumerService = new ConsumerService();
				List<ConsumerVO> list = consumerService.selectChart(paramVO);
				
				Gson gson = new Gson();
				String jsonStrList = gson.toJson(list);
				response.getWriter().write(jsonStrList);
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		
	}
	
	/*************************** ���平���摩 ****************************************/
	public class ConsumerService {
		private consumer_interface dao;

		public ConsumerService() {
			dao = new ConsumerDAO();
		}
		
		public List<ConsumerVO> selectCity() {
			return dao.selectCity();
		}

		public List<ConsumerVO> selectLayer(ConsumerVO paramVO) {
			return dao.selectLayer(paramVO);
		}

		public List<ConsumerVO> selectType(ConsumerVO paramVO) {
			return dao.selectType(paramVO);
		}

		public List<ConsumerVO> selectItem(ConsumerVO paramVO) {
			return dao.selectItem(paramVO);
		}

		public List<ConsumerVO> selectSubItem(ConsumerVO paramVO) {
			return dao.selectSubItem(paramVO);
		}

		public List<ConsumerVO> selectSubItemVariableName(ConsumerVO paramVO) {
			return dao.selectSubItemVariableName(paramVO);
		}

		public List<ConsumerVO> selectVariableName(ConsumerVO paramVO) {
			return dao.selectVariableName(paramVO);
		}

		public List<ConsumerVO> selectYear(ConsumerVO paramVO) {
			return dao.selectYear(paramVO);
		}

		public List<ConsumerVO> selectChart(ConsumerVO paramVO) {
			return dao.selectChart(paramVO);
		}
	}

	/*************************** �摰��瘜� ****************************************/
	interface consumer_interface {
		public List<ConsumerVO> selectCity();
		public List<ConsumerVO> selectLayer(ConsumerVO paramVO);
		public List<ConsumerVO> selectType(ConsumerVO paramVO);
		public List<ConsumerVO> selectItem(ConsumerVO paramVO);
		public List<ConsumerVO> selectSubItem(ConsumerVO paramVO);
		public List<ConsumerVO> selectSubItemVariableName(ConsumerVO paramVO);
		public List<ConsumerVO> selectVariableName(ConsumerVO paramVO);
		public List<ConsumerVO> selectYear(ConsumerVO paramVO);
		public List<ConsumerVO> selectChart(ConsumerVO paramVO);
	}
	
	/*************************** �����澈 ****************************************/
	class ConsumerDAO implements consumer_interface {
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");
		private final String wsPath = getServletConfig().getServletContext().getInitParameter("pythonwebservice");

		// ��蝙����tored procedure
		private static final String sp_consumer_city = "call sp_consumer_city()";
		private static final String sp_consumer_Layer = "call sp_consumer_Layer(?)";
		private static final String sp_consumer_Type = "call sp_consumer_Type(?,?)";
		private static final String sp_consumer_Item = "call sp_consumer_Item(?,?,?)";
		private static final String sp_consumer_SubItem = "call sp_consumer_SubItem(?,?,?,?)";
		private static final String sp_consumer_SubItemVariableName = "call sp_consumer_SubItemVariableName(?,?,?,?,?)";
		private static final String sp_consumer_VariableName = "call sp_consumer_VariableName(?,?,?,?)";
		private static final String sp_consumer_Year = "call sp_consumer_Year(?,?)";
		private static final String sp_consumer_Chart = "call sp_consumer_Chart(?,?,?,?)";
		
		@Override
		public List<ConsumerVO> selectCity() {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_city);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setCity(rs.getString("City") == null?"":rs.getString("City"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectLayer(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_Layer);
				pstmt.setString(1, paramVO.getCity());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setLayer(rs.getString("Layer") == null?"":rs.getString("Layer"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectType(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_Type);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getLayer());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setType(rs.getString("Type") == null?"":rs.getString("Type"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectItem(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_Item);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getLayer());
				pstmt.setString(3, paramVO.getType());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setItem(rs.getString("Item") == null?"":rs.getString("Item"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectSubItem(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_SubItem);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getLayer());
				pstmt.setString(3, paramVO.getType());
				pstmt.setString(4, paramVO.getItem());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setSubItem(rs.getString("SubItem") == null?"":rs.getString("SubItem"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectSubItemVariableName(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_SubItemVariableName);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getLayer());
				pstmt.setString(3, paramVO.getType());
				pstmt.setString(4, paramVO.getItem());
				pstmt.setString(5, paramVO.getSubItem());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setVariableName(rs.getString("VariableName") == null?"":rs.getString("VariableName"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectVariableName(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_VariableName);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getLayer());
				pstmt.setString(3, paramVO.getType());
				pstmt.setString(4, paramVO.getItem());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setVariableName(rs.getString("VariableName") == null?"":rs.getString("VariableName"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectYear(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_Year);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getVariableName());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setYear(rs.getString("Year") == null?"":rs.getString("Year"));
					
					list.add(consumerVO); // Store the row in the list
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
		public List<ConsumerVO> selectChart(ConsumerVO paramVO) {
			List<ConsumerVO> list = new ArrayList<ConsumerVO>();
			ConsumerVO consumerVO = null;
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_consumer_Chart);
				pstmt.setString(1, paramVO.getCity());
				pstmt.setString(2, paramVO.getVariableName());
				pstmt.setString(3, paramVO.getSubItem());
				pstmt.setString(4, paramVO.getYear());
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					consumerVO = new ConsumerVO();
					
					consumerVO.setVariableName(rs.getString("VariableName") == null?"":rs.getString("VariableName"));
					consumerVO.setCity(rs.getString("City") == null?"":rs.getString("City"));
					consumerVO.setYear(rs.getString("Year") == null?"":rs.getString("Year"));
					consumerVO.setData(rs.getString("Data") == null?"":rs.getString("Data"));
					
					list.add(consumerVO); // Store the row in the list
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
}
