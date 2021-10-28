package com.controller;
import java.util.List;

import com.model.SvrlstVo;
import com.mapper.ISvrlstMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

@Controller
public class ManualController {

	@Autowired
	private ISvrlstMapper svrlstMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/manual/admin", method = RequestMethod.GET)
	public String admin_manual(Model model) throws Exception {

		List<SvrlstVo> serverlist = svrlstMapper.getVpnSvrlstList();

		System.out.println("serverlist====" + serverlist);

		for (SvrlstVo vos : serverlist) {

			if (vos.getSvr_nm().equals("APTURL")) {

				System.out.println(vos.getSvr_nm() + "," + vos.getSvr_ip() + ":" + vos.getSvr_port());
				model.addAttribute("ip", vos.getSvr_ip());
				model.addAttribute("port", vos.getSvr_port());
			}
		}

		return "/main/admin_manual";

	}

	
	@RequestMapping(value = "/manual/user", method = RequestMethod.GET)
	public String user_manual(Model model) throws Exception {

		List<SvrlstVo> serverlist = svrlstMapper.getVpnSvrlstList();

		System.out.println("serverlist====" + serverlist);

		for (SvrlstVo vos : serverlist) {

			if (vos.getSvr_nm().equals("APTURL")) {

				System.out.println(vos.getSvr_nm() + "," + vos.getSvr_ip() + ":" + vos.getSvr_port());
				model.addAttribute("ip", vos.getSvr_ip());
				model.addAttribute("port", vos.getSvr_port());
			}
		}

		return "/main/user_manual";

	}

	
}
