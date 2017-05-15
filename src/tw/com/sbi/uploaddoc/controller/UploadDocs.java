package tw.com.sbi.uploaddoc.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class UploadDocs extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LogManager.getLogger(UploadDocs.class);
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		GetData getdata = new GetData();
		String action = request.getParameter("action");
		logger.debug("action: "+action);
		if ("download_ebook".equals(action)) {
			String ori = "";
			try {
				ori = request.getParameter("ebook_name");
				logger.debug("ebook_name: "+ori);
				
				String ebook_name = ori+".pdf";
				String file_path = getServletConfig().getServletContext()
									.getInitParameter("ebookpath")+"/"+ebook_name;
				
				response.setContentType("APPLICATION/PDF");
				String disHeader = "inline;Filename=\"" + ori + ".pdf" + "\"";
				response.setHeader("Content-Disposition", disHeader);

				File file = new File(file_path);
				FileInputStream fileIn = new FileInputStream(file);
				ServletOutputStream out = response.getOutputStream();
				byte[] outputByte = new byte[4096];
				while (fileIn.read(outputByte, 0, 4096) != -1) {
					out.write(outputByte, 0, 4096);
				}

				fileIn.close();
				out.flush();
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write("<html><head><title>NOT FOUND</title><meta charset='UTF-8'></head>"
										+"<body style='text-align:center;font-size:48px;color:red;'><br>找不到檔案:<br> '"
										+ori+"' 的電子書</body></html>");
			}
		}else if("download_doc".equals(action)) {
			String ori = "";
			try {
				
				String file_name = request.getParameter("file_name");
				String ori_name = request.getParameter("ori_name");
				logger.debug("file_name: "+file_name);
				logger.debug("ori_name: "+ori_name);
				
				ori = ori_name;
				String file_path = getServletConfig().getServletContext()
									.getInitParameter("uploadpath")+"/doc/"+file_name;
				File file = new File(getServletConfig().getServletContext().getInitParameter("uploadpath")+"/doc");
				if(!file.exists()){
				     file.mkdirs();
				}
				
				FileInputStream fileInput = new FileInputStream(file_path);
				int i = fileInput.available();
				byte[] content = new byte[i];
				fileInput.read(content);
				
				response.setContentType("application/octet-stream");
				String fileName_tmp = new String(ori_name.getBytes(), "ISO8859-1");
				response.setHeader("Content-Disposition","attachment;filename=\"" + fileName_tmp + "\""); 
				
				OutputStream output = response.getOutputStream();
				output.write(content);
				output.flush();
				fileInput.close();
				output.close();
				
			} catch (Exception e) {
				e.printStackTrace();
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write("<html><head><title>NOT FOUND</title><meta charset='UTF-8'></head>"
										+"<body style='text-align:center;font-size:48px;color:red;'><br>找不到檔案:<br>"
										+ori+"</body></html>");
			}
		}else if("upload_doc".equals(action)) {
			String ret = "";
			String _uid= UUID.randomUUID().toString();
			String ori_name="";
			File file_path = new File(getServletConfig().getServletContext().getInitParameter("uploadpath")+"/doc");
			if(!file_path.exists()){
				file_path.mkdirs();
			}
			String fullname = getServletConfig().getServletContext().getInitParameter("uploadpath")+"/doc/"+_uid;
			int maxFileSize = 50 * 1024 * 1024;
			int maxMemSize = 50 * 1024 * 1024;
			String contentType = request.getContentType();
			if (contentType!=null && (contentType.indexOf("multipart/form-data") >= 0)) {
			      DiskFileItemFactory factory = new DiskFileItemFactory();
			      factory.setSizeThreshold(maxMemSize);
			      String file_over=getServletConfig().getServletContext().getInitParameter("uploadpath")+"/fail";
			      factory.setRepository(new File(file_over));
			      ServletFileUpload upload = new ServletFileUpload(factory);
			      upload.setSizeMax( maxFileSize );
			      try{
			         List fileItems = upload.parseRequest(request);
			         Iterator i = fileItems.iterator();
			         while ( i.hasNext () ) 
			         {
			            FileItem fi = (FileItem)i.next();
			            if ( !fi.isFormField () ) {
			                ori_name=fi.getName();
			                String[] tmp = ori_name.split("\\.");
			                fullname += "." + tmp[tmp.length-1];
			                
			                File file ;
			                file = new File(fullname) ;
			                fi.write( file ) ;
			                ret = _uid + "." + tmp[tmp.length-1];
			            }
			         }
			      }catch(Exception ex) {
			    	  ex.printStackTrace(System.err);
			    	  ret="E_write_File:"+ex.toString();
			    	  ret = "fall";
			      }
			   }else{
				   ret = "fall";
			   }
			response.getWriter().write(ret);
			
		} else if ("select_all_uploaddoc".equals(action)) {
			String jsonList = getdata.select_all_uploaddoc();
			response.getWriter().write(jsonList);
			
		} else if ("sp_insert_upload_doc".equals(action)) {
			String title = request.getParameter("title");
			String summary = request.getParameter("summary");
			String show_name = request.getParameter("show_name");
			String store_name = request.getParameter("store_name");
			
			logger.debug("title: "+title);
			logger.debug("summary: "+summary);
			logger.debug("show_name: "+show_name);
			logger.debug("store_name: "+store_name);
			
			UploadDoc uploaddoc = new UploadDoc();
			uploaddoc.setTitle(null2str(title));
			uploaddoc.setSummary(null2str(summary));
			uploaddoc.setShow_name(null2str(show_name));
			uploaddoc.setStore_name(null2str(store_name));
			
			String jsonList = getdata.insert_uploaddoc(uploaddoc);
			if("success".equals(jsonList)){
				jsonList = getdata.select_all_uploaddoc();
			}
			response.getWriter().write(jsonList);
		} else if ("sp_update_upload_doc".equals(action)) {
			String id = request.getParameter("id");
			String title = request.getParameter("title");
			String summary = request.getParameter("summary");
			String show_name = request.getParameter("show_name");
			String store_name = request.getParameter("store_name");
			
			logger.debug("id: "+id);
			logger.debug("title: "+title);
			logger.debug("summary: "+summary);
			logger.debug("show_name: "+show_name);
			logger.debug("store_name: "+store_name);
			
			UploadDoc uploaddoc = new UploadDoc();
			uploaddoc.setId(null2str(id));
			uploaddoc.setTitle(null2str(title));
			uploaddoc.setSummary(null2str(summary));
			uploaddoc.setShow_name(null2str(show_name));
			uploaddoc.setStore_name(null2str(store_name));
			
			String jsonList = getdata.update_uploaddoc(uploaddoc);
			if("success".equals(jsonList)){
				jsonList = getdata.select_all_uploaddoc();
			}
			response.getWriter().write(jsonList);
		} else if ("sp_del_upload_doc".equals(action)) {
			String id = request.getParameter("id");
			logger.debug("id: "+id);
			
			UploadDoc uploaddoc = new UploadDoc();
			uploaddoc.setId(null2str(id));
			
			String jsonList = getdata.delete_uploaddoc(uploaddoc);
			if("success".equals(jsonList)){
				jsonList = getdata.select_all_uploaddoc();
			}else{
				response.getWriter().write("failed");
			}
			response.getWriter().write(jsonList);
		}
	}
	public class GetData{
		private final String dbURL = getServletConfig().getServletContext().getInitParameter("dbURL")
				+ "?useUnicode=true&characterEncoding=utf-8&useSSL=false";
		private final String dbUserName = getServletConfig().getServletContext().getInitParameter("dbUserName");
		private final String dbPassword = getServletConfig().getServletContext().getInitParameter("dbPassword");
		private final String sp_select_upload_doc = "call sp_select_upload_doc()";
		private final String sp_insert_upload_doc = "call sp_insert_upload_doc(?,?,?,?)";
		private final String sp_update_upload_doc = "call sp_update_upload_doc(?,?,?,?,?)";
		private final String sp_del_upload_doc = "call sp_del_upload_doc(?)";
		
		public String delete_uploaddoc(UploadDoc data) {
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_del_upload_doc);
				pstmt.setString(1, data.getId());
				
				rs = pstmt.executeQuery();
				return "success";
				
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
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
		}
		
		public String update_uploaddoc(UploadDoc data) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_update_upload_doc);

				pstmt.setString(1, data.getId());
				pstmt.setString(2, data.getTitle());
				pstmt.setString(3, data.getSummary());
				pstmt.setString(4, data.getShow_name());
				pstmt.setString(5, data.getStore_name());
				
				rs = pstmt.executeQuery();
				return "success";
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
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
		}
		
		public String insert_uploaddoc(UploadDoc data) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_insert_upload_doc);
				pstmt.setString(1, data.getTitle());
				pstmt.setString(2, data.getSummary());
				pstmt.setString(3, data.getShow_name());
				pstmt.setString(4, data.getStore_name());
				rs = pstmt.executeQuery();
				return "success";
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
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
		}
		public String select_all_uploaddoc() {
			List<UploadDoc> list= new ArrayList<UploadDoc>();
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String jsonList = "";
			try {
				Class.forName("com.mysql.jdbc.Driver");
				con = DriverManager.getConnection(dbURL, dbUserName, dbPassword);
				pstmt = con.prepareStatement(sp_select_upload_doc);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					UploadDoc uploaddoc =new UploadDoc();
					uploaddoc.setId(rs.getString("id"));
					uploaddoc.setTitle(rs.getString("title"));
					uploaddoc.setSummary(rs.getString("summary"));
					uploaddoc.setShow_name(rs.getString("show_name"));
					uploaddoc.setStore_name(rs.getString("store_name"));
					uploaddoc.setUpload_time(rs.getDate("upload_time"));
					
					list.add(uploaddoc);
				}
				Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
				jsonList = gson.toJson(list);
			} catch (SQLException se) {
				throw new RuntimeException("A database error occured. " + se.getMessage());
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("A database error occured. " + cnfe.getMessage());
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
			return jsonList;
		}
	}
	public class UploadDoc{
		private String id;
		private String title;
		private String summary;
		private String show_name;
		private String store_name;
		private Date upload_time;
		
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public String getSummary() {
			return summary;
		}
		public void setSummary(String summary) {
			this.summary = summary;
		}
		public String getShow_name() {
			return show_name;
		}
		public void setShow_name(String show_name) {
			this.show_name = show_name;
		}
		public String getStore_name() {
			return store_name;
		}
		public void setStore_name(String store_name) {
			this.store_name = store_name;
		}
		public Date getUpload_time() {
			return upload_time;
		}
		public void setUpload_time(Date upload_time) {
			this.upload_time = upload_time;
		}
	}
	
	public String null2str(Object object) {
		return object == null ? "" : object.toString();
	}
}