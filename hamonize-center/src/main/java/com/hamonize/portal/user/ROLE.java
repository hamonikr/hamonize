package com.hamonize.portal.user;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ROLE {

    USER("ROLE_USER"),
    ADMIN("ROLE_ADMIN");

    private String value;

}