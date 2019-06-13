package com.ssm.controller;


import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class PageController {
	@RequestMapping("/")
	public String backLogin(HttpServletRequest request) {
		return "test.jsp";
	}
}
