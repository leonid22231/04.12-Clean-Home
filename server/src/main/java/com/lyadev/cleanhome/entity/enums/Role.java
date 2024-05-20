package com.lyadev.cleanhome.entity.enums;

import org.springframework.security.core.GrantedAuthority;

public enum Role implements GrantedAuthority {
    USER,CLEANER,MANAGER,ADMIN;

    @Override
    public String getAuthority() {
        return name();
    }
}
