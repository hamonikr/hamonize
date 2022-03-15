package com.controller;

import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.model.HostLoginInfo;
import com.util.JsonUtil;
import com.ws.WebSshHandler;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class WebSshController {
    @PostMapping("/")
    public String showIndex(Model model,HttpServletRequest request) {
        model.addAttribute("hostname", request.getParameter("hostname"));
        return "/webssh/index";
    }

    @RequestMapping(value = "/ssh", method = RequestMethod.POST)
    @ResponseBody
    public ObjectNode connect(String hostname, Integer port, String username, String password, MultipartFile privatekey) {

        WebSshHandler.websocketSessionId.increment();
        long wsId = WebSshHandler.websocketSessionId.longValue();

        HostLoginInfo hostLoginInfo = new HostLoginInfo()
                .setHostname(hostname)
                .setUsername(username)
                .setPassword(password)
                .setPort(port)
                .setPrivatekey(privatekey);
        WebSshHandler.hostLoginInfoMap.put(wsId, hostLoginInfo);
        
        ObjectNode node = JsonUtil.createObjectNode();
        node.put("status", 0);
        node.put("id", wsId);
        node.put("encoding", "utf-8");
        return node;
    }
}
