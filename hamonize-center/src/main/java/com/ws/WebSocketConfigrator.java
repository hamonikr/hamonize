package com.ws;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

public class WebSocketConfigrator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
        HttpSession httpSession = (HttpSession) request.getHttpSession();

        if (httpSession == null) {
            return;
        }
        //HttpSession에 저장된 ClientIP를 ServerEndpointConfig에 넣으면 키워드가 이전과 다를 수 있습니다.
        config.getUserProperties().put("ClientIP", httpSession.getAttribute("ClientIP"));
    }
}
