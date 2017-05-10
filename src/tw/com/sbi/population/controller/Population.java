package tw.com.sbi.population.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Population extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LogManager.getLogger(Population.class);
	
	protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		final String wsPath = getServletConfig().getServletContext().getInitParameter("pythonwebservice");
		String kind = request.getParameter("kind");
    	String type = request.getParameter("type");
    	String urls = request.getParameter("url");  

    	logger.info("kind:" + kind);
    	logger.info("type:" + type);
    	logger.info("urls:" + urls);
    	
    	String encodeKind = new String(Base64.encodeBase64String(kind.getBytes()));
    	String encodeType = new String(Base64.encodeBase64String(type.getBytes()));
    	String encodeUrl = new String(Base64.encodeBase64String(urls.getBytes()));

    	String url = wsPath + "/OpenData/kind=" + encodeKind + "&type=" + encodeType + "&urls=" + encodeUrl;
    	
    	logger.debug("ws url:".concat(url));
    	HttpGet httpRequest = new HttpGet(url);
    	HttpClient client = HttpClientBuilder.create().build();
    	HttpResponse httpResponse;
    	try {
    		httpResponse = client.execute(httpRequest);
			int responseCode = httpResponse.getStatusLine().getStatusCode();

	    	if(responseCode==200){
	    		logger.debug("更新資料庫 - 成功");
    	    	response.getWriter().write("更新資料庫 - 成功");
	    	} else {
	    		logger.debug("更新資料庫 - 失敗");
	    		response.getWriter().write("更新資料庫 - 失敗"); 
	    	}	    	
		} catch (ClientProtocolException e) {
			logger.error("ClientProtocolException:".concat(e.getMessage()));
		} catch (UnsupportedOperationException e) {
			logger.error("UnsupportedOperationException:".concat(e.getMessage()));
		} catch (IOException e) {
			logger.error("IOException:".concat(e.getMessage()));
		}
	}
}