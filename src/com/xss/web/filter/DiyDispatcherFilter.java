package com.xss.web.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.DispatcherServlet;

import com.xss.web.cache.SuffixCache;
import com.xss.web.service.SuffixService;
import com.xss.web.util.RequestUtil;
import com.xss.web.util.SpringContextHelper;

@SuppressWarnings("serial")
public class DiyDispatcherFilter extends DispatcherServlet implements Filter{

	
	String [] languages={"ASP.NET","ASP","PHP/5.4.27","JScript","VB.NET","VBScript","CGI","Python","Perl","JAVA","ELanguage"};
	List<String> languageList=Arrays.<String>asList(languages);
	
	String [] servers={"Microsoft-IIS/10.0","Microsoft-IIS/9.0","Microsoft-IIS/9.5","Microsoft-IIS/3.0","Microsoft-IIS/3.5",
			"Microsoft-IIS/2.0","Microsoft-IIS/2.5",
			"WebSOS-Server/2.0","WebSOS-Server/3.0","WebSOS-Server/9.0",
			"Hacker-Server/2.0","Hacker-Server/3.0","Hacker-Server/4.0","Hacker-Server/8.0","Hacker-Server/9.0",
			"Hacker-Server/2.5","Hacker-Server/3.5","Hacker-Server/4.5","Hacker-Server/8.5","Hacker-Server/9.5",
			"ASP-Server/2.5","ASP-Server/3.5","ASP-Server/4.5","ASP-Server/5.5",
			"Xampp-Server/2.5","Xampp-Server/3.5","Xampp-Server/5.5","Xampp-Server/6.0","Xampp-Server/8.5",
	};
	List<String> serverList=Arrays.<String>asList(servers);
	
	public void baseFilter(HttpServletRequest req,HttpServletResponse res){
		try {
			loadBasePath(req);
			res.setContentType("text/html;charset=UTF-8");
			req.setCharacterEncoding("UTF-8");
			res.setCharacterEncoding("UTF-8");
			Collections.shuffle(languageList);
			String XPBy=languageList.get(0);
			res.setHeader("X-Powered-By", XPBy);
			Collections.shuffle(serverList);
			String server=serverList.get(0);
			res.setHeader("Server", server);
		} catch (Exception e) {
		}
	}
	
	
	public DiyDispatcherFilter(){
		super();
	}
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req=(HttpServletRequest)request;
		HttpServletResponse res=(HttpServletResponse)response;
		baseFilter(req, res);
		SuffixCache suffixCache=SpringContextHelper.getBean(SuffixCache.class);
		List<String> suffixs=suffixCache.loadSpringSuffixs();
		List<String> staList = suffixCache.loadStaSuffix();
		String suffix=RequestUtil.getURLSuffix(req);
		if (staList.contains(suffix)) {
			res.setHeader("Cache-Control", "max-age=600");
			chain.doFilter(req, res);
			return;
		}
		String defSuffix = suffixCache.loadDefSuffix();
		req.setAttribute("defSuffix", defSuffix);
		if(suffixs.contains(suffix)){
			service(req, res);
			return;
		}
		chain.doFilter(req, res);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		super.init(new ServletFilter(filterConfig));
	}
	private void loadBasePath(HttpServletRequest request) {
		String path = request.getContextPath();
		String basePath = request.getScheme()
				+ "://"
				+ request.getServerName()
				+ (request.getServerPort() == 80 ? "" : ":"
						+ request.getServerPort()) + path + "/";
		request.getSession().setAttribute("basePath", basePath);
		request.setAttribute("basePath", basePath);
	}
	private static class ServletFilter  implements ServletConfig,FilterConfig{

		private FilterConfig filterConfig;
		
		public ServletFilter(FilterConfig filterConfig){
			this.filterConfig=filterConfig;
		}
		public String getFilterName() {
			return filterConfig.getFilterName();
		}

		public String getInitParameter(String s) {
			return filterConfig.getInitParameter(s);
		}

		public Enumeration<String> getInitParameterNames() {
			return filterConfig.getInitParameterNames();
		}

		public ServletContext getServletContext() {
			return filterConfig.getServletContext();
		}

		public String getServletName() {
			return filterConfig.getFilterName();
		}

	}

}
