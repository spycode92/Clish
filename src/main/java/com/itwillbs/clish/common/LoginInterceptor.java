package com.itwillbs.clish.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession httpSession = request.getSession(false);
		
		if (httpSession == null || httpSession.getAttribute("sUT") == null || httpSession.getAttribute("sId") == null) {
			request.setAttribute("msg", "접근권한이 없습니다.");
			request.setAttribute("targetURL", "/user/login");
			request.getRequestDispatcher("/WEB-INF/views/commons/result_process.jsp").forward(request, response);
			return false;
		}
		
		Integer userType = (Integer) httpSession.getAttribute("sUT");
		String uri = request.getRequestURI();
		
		if (uri.startsWith("/admin") && userType != 3) {
			request.setAttribute("msg", "관리자만 접근 가능한 페이지입니다.");
			request.setAttribute("targetURL", "/");
			request.getRequestDispatcher("/WEB-INF/views/commons/result_process.jsp").forward(request, response);
			return false;
		}
		
		if (uri.startsWith("/company") && userType != 2) {
			request.setAttribute("msg", "접근권한이 없습니다.");
			request.setAttribute("targetURL", "/");
			request.getRequestDispatcher("/WEB-INF/views/commons/result_process.jsp").forward(request, response);
			return false;
		}
		
		if (uri.startsWith("/myPage") && userType != 1) {
			request.setAttribute("msg", "접근권한이 없습니다.");
			request.setAttribute("targetURL", "/");
			request.getRequestDispatcher("/WEB-INF/views/commons/result_process.jsp").forward(request, response);
			return false;
		}
		
		return true;
	}
	
}
