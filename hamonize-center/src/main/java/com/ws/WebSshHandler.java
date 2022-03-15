package com.ws;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.LongAdder;

import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import com.fasterxml.jackson.databind.JsonNode;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.model.HostLoginInfo;
import com.util.JsonUtil;

import org.springframework.stereotype.Component;

@ServerEndpoint(value = "/ssh/ssh/{id}", configurator = WebSocketConfigrator.class)
@Component
public class WebSshHandler {


    public static LongAdder onlineCount = new LongAdder();

    public static LongAdder websocketSessionId = new LongAdder();

    public static Map<Long, HostLoginInfo> hostLoginInfoMap = new ConcurrentHashMap<>();

    private static CopyOnWriteArraySet<WebSshHandler> webSocketSet = new CopyOnWriteArraySet<>();

    private Session session;

    private StringBuilder dataToDst = new StringBuilder();


    private static JSch jsch = new JSch();

    private com.jcraft.jsch.Session jschSession;

    private Channel channel;

    private InputStream inputStream;

    private OutputStream outputStream;

    private Thread thread;

    @OnOpen
    public void onOpen(final Session session, @PathParam("id") Long id) throws JSchException, IOException, EncodeException, InterruptedException {
        this.session = session;
        webSocketSet.add(this);
        onlineCount.increment();
        System.out.println("새링크 " + session.getUserProperties().get("ClientIP") + " 현재 온라인 번호는" + onlineCount.longValue());

        HostLoginInfo hostLoginInfo = hostLoginInfoMap.get(id);

        jschSession = jsch.getSession(hostLoginInfo.getUsername(), hostLoginInfo.getHostname(), hostLoginInfo.getPort());
        jschSession.setPassword(hostLoginInfo.getPassword());

        java.util.Properties config = new java.util.Properties();
        config.put("StrictHostKeyChecking", "no");
        jschSession.setConfig(config);
        jschSession.connect();

        channel = jschSession.openChannel("shell");
        inputStream = channel.getInputStream();
        outputStream = channel.getOutputStream();
        channel.connect();


        thread = new Thread() {

            @Override
            public void run() {

                try {
                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
                    String msg = "";
                    String preMsg = "";
                    while ((msg = bufferedReader.readLine()) != null) { // 이것은 차단되므로 채널의 반환 내용을 읽으려면 스레드를 시작해야 합니다.

                        msg = "\r\n" + msg;

                        if (preMsg.equals(msg)) { // 직접 입력
                            byte[] bytes = msg.getBytes();
                            ByteBuffer byteBuffer = ByteBuffer.wrap(bytes, 0, bytes.length);
                            synchronized (this) {
                                session.getBasicRemote().sendBinary(byteBuffer);
                            }
                            continue;
                        } else if (msg.equals(preMsg + dataToDst.toString())) { // 명령 실행, 첫 번째 줄 무시
                            continue;
                        }

                        if ("".equals(msg) || "\r\n".equals(msg)) {
                            continue;
                        }

                        preMsg = msg;

                        System.out.println("<<" + msg + ">>");
                        byte[] bytes = msg.getBytes();
                        ByteBuffer byteBuffer = ByteBuffer.wrap(bytes, 0, bytes.length);
                        synchronized (this) {
                            session.getBasicRemote().sendBinary(byteBuffer);
                        }

                        dataToDst = new StringBuilder();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };
        thread.start();

        Thread.sleep(100);
        this.onMessage("{\"data\":\"\\r\"}", this.session);

    }

    @OnClose
    public void onClose() {
        webSocketSet.remove(this);
        onlineCount.decrement();
        System.out.println("링크가 닫혔습니다 현재 접속중인 인원수는" + onlineCount.longValue());

        channel.disconnect();
        jschSession.disconnect();
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException, JSchException {


        System.out.println("클라이언트의" + session.getUserProperties().get("ClientIP") + " 입력값:" + message);

        JsonNode node = JsonUtil.strToJsonObject(message);

        if (node.has("resize")) {
            // do nothing
            return;
        }

        if (node.has("data")) {
            String str = node.get("data").asText();

            if ("\r".equals(str)) {
                if (dataToDst.length() > 0) {
                    str = "\r\n";
                }
            }else if("".equals(str)){
                if (dataToDst.length()> 0) {
                    str = "\b";
                    dataToDst.deleteCharAt(dataToDst.length()-1);
                }else{
                    str = "";
                }
            }else {
                dataToDst.append(str);
            }

            byte[] bytes = str.getBytes();
            outputStream.write(bytes);
            outputStream.flush();

            if (!"\r\n".equals(str) && !"\r".equals(str)) {
                System.out.println("[[" + str + "]]");
                ByteBuffer byteBuffer = ByteBuffer.wrap(bytes, 0, bytes.length);
                synchronized (this) {
                    session.getBasicRemote().sendBinary(byteBuffer);
                }
            }

            System.out.println("dataToDst = " + dataToDst);

            return;
        }


    }
}
