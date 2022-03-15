package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.springframework.web.multipart.MultipartFile;

/**
 * @program: web-ssh
 * @description:
 * @author: Fanrong
 * @create: 2019-05-14 14:19
 **/
@Getter
@Setter
@Accessors(chain = true)
public class HostLoginInfo {
    private String hostname;
    private Integer port;
    private String username;
    private String password;
    private MultipartFile privatekey;
}
