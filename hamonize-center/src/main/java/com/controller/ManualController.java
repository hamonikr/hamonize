package com.controller;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ManualController {



	
	@RequestMapping(value = "/manual/user", method = RequestMethod.GET)
	public String user_manual(Model model) throws Exception {

		return "/main/user_manual";

	}

	
}
