package tw.com.sbi.persona.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Persona extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final Logger logger = LogManager.getLogger(Persona.class);
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");
		String url = "";
		
		logger.debug("Action:" + action );
		
		if("persona".equals(action)){
			String sex = request.getParameter("sex");
			String age = request.getParameter("age");
			String px3 = request.getParameter("px3");
			String px4 = request.getParameter("px4");
			String px5 = request.getParameter("px5");
			String px6 = request.getParameter("px6");
			String px7 = request.getParameter("px7");
			String px8 = request.getParameter("px8");
			String px9 = request.getParameter("px9");
			
			logger.debug("sex:" + sex );
			logger.debug("age:" + age );
			logger.debug("px3:" + px3 );
			logger.debug("px4:" + px4 );
			logger.debug("px5:" + px5 );
			logger.debug("px6:" + px6 );
			logger.debug("px7:" + px7 );
			logger.debug("px8:" + px8 );
			logger.debug("px9:" + px9 );
			
			url = getServletConfig().getServletContext().getInitParameter("pythonwebservice")
				+"/persona/"
				+"sex="+new String(Base64.encodeBase64String(sex.getBytes()))
				+"&age="+new String(Base64.encodeBase64String(age.getBytes()))
				+"&px3="+new String(Base64.encodeBase64String(px3.getBytes()))
				+"&px4="+new String(Base64.encodeBase64String(px4.getBytes()))
				+"&px5="+new String(Base64.encodeBase64String(px5.getBytes()))
				+"&px6="+new String(Base64.encodeBase64String(px6.getBytes()))
				+"&px7="+new String(Base64.encodeBase64String(px7.getBytes()))
				+"&px8="+new String(Base64.encodeBase64String(px8.getBytes()))
				+"&px9="+new String(Base64.encodeBase64String(px9.getBytes()));
			
			logger.debug(url);
			
			StringBuffer result = sendRequest(url);
			response.getWriter().write(result.toString());
		} else if("marketingStrategy".equals(action)){
			String country = request.getParameter("country");
			String sex = request.getParameter("sex");
			String age = request.getParameter("age");
			String px3 = request.getParameter("px3");
			String px4 = request.getParameter("px4");
			String px5 = request.getParameter("px5");
			String px6 = request.getParameter("px6");
			String px7 = request.getParameter("px7");
			String px8 = request.getParameter("px8");
			String px9 = request.getParameter("px9");
			
			logger.debug("country:" + country );
			logger.debug("sex:" + sex );
			logger.debug("age:" + age );
			logger.debug("px3:" + px3 );
			logger.debug("px4:" + px4 );
			logger.debug("px5:" + px5 );
			logger.debug("px6:" + px6 );
			logger.debug("px7:" + px7 );
			logger.debug("px8:" + px8 );
			logger.debug("px9:" + px9 );
			
			url = getServletConfig().getServletContext().getInitParameter("pythonwebservice")
				+"/entrysrategy/"
				+"_cy="+new String(Base64.encodeBase64String(country.getBytes()))
				+"&sex="+new String(Base64.encodeBase64String(sex.getBytes()))
				+"&age="+new String(Base64.encodeBase64String(age.getBytes()))
				+"&px3="+new String(Base64.encodeBase64String(px3.getBytes()))
				+"&px4="+new String(Base64.encodeBase64String(px4.getBytes()))
				+"&px5="+new String(Base64.encodeBase64String(px5.getBytes()))
				+"&px6="+new String(Base64.encodeBase64String(px6.getBytes()))
				+"&px7="+new String(Base64.encodeBase64String(px7.getBytes()))
				+"&px8="+new String(Base64.encodeBase64String(px8.getBytes()))
				+"&px9="+new String(Base64.encodeBase64String(px9.getBytes()));
			
			logger.debug(url);
			
			StringBuffer result = sendRequest(url);
			response.getWriter().write(result.toString());
		}
	}
	
	private StringBuffer sendRequest(String url){
		HttpGet httpRequest = new HttpGet(url);
    	HttpClient client = HttpClientBuilder.create().build();
    	HttpResponse httpResponse;
    	StringBuffer result = new StringBuffer();
    	try {
    		httpResponse = client.execute(httpRequest);
			int responseCode = httpResponse.getStatusLine().getStatusCode();

	    	if(responseCode == 200){
	    		BufferedReader rd = new BufferedReader(new InputStreamReader(httpResponse.getEntity().getContent()));
    	    	String line = "";
    	    	while ((line = rd.readLine()) != null) {
    	    		result.append(line);
    	    	}	
	    		
	    		logger.debug(result);
	    	} else {
	    		logger.debug("responseCode: " + responseCode+"\nfail to get data");
	    	}    	    	
		}catch (Exception e){
			logger.debug(e.toString());
		}
    	
    	return result;
	}
}
