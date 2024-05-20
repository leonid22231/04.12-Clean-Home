package com.lyadev.cleanhome.config;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Role;
import com.lyadev.cleanhome.service.FirebaseUserDetailsService;
import com.lyadev.cleanhome.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.web.SecurityFilterChain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration{
    @Autowired
    UserService userService;

    AuthenticationManager authenticationManager;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception {
        httpSecurity.csrf().disable().authorizeHttpRequests((auth) ->
                auth.requestMatchers(HttpMethod.POST, "api/v1/register").permitAll()
                        .requestMatchers(HttpMethod.GET, "api/v1/region","api/v1/notify").permitAll()
                        .requestMatchers("api/v1/region/***").hasAnyAuthority(Role.ADMIN.name(), Role.MANAGER.name())
                        .anyRequest().authenticated()).oauth2ResourceServer((oauth2 -> oauth2.jwt(jwtConfigurer -> jwtConfigurer.jwtAuthenticationConverter(new Converter<Jwt, AbstractAuthenticationToken>() {
            @Override
            public AbstractAuthenticationToken convert(Jwt source) {
                Collection<SimpleGrantedAuthority> collection = new ArrayList<>();
                try {
                    UserRecord userRecord = FirebaseAuth.getInstance().getUser(source.getClaimAsString("user_id"));
                    UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
                    if(user!=null)
                        for(Role role : user.getRoles()){
                            collection.add(new SimpleGrantedAuthority(role.getAuthority()));
                        }
                } catch (FirebaseAuthException e) {
                    throw new RuntimeException(e);

                }
                return new JwtAuthenticationToken(source,collection);
            }
        }))));

        return httpSecurity.build();
    }
}
