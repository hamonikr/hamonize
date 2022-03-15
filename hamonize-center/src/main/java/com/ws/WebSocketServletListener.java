package com.ws;

import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@WebListener()
public class WebSocketServletListener implements ServletRequestListener {
    @Override
    public void requestDestroyed(ServletRequestEvent servletRequestEvent) {

    }

    @Override
    public void requestInitialized(ServletRequestEvent servletRequestEvent) {
        HttpServletRequest request = (HttpServletRequest) servletRequestEvent.getServletRequest();
        HttpSession session = request.getSession();
        // HttpServletRequest의 IP 주소를 HttpSession에 입력합니다. 키워드는 임의적일 수 있습니다. 여기에 ClientIP가 있습니다.
        session.setAttribute("ClientIP", servletRequestEvent.getServletRequest().getRemoteAddr());
    }
}
