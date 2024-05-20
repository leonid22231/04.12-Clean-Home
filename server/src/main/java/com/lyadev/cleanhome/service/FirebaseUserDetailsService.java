package com.lyadev.cleanhome.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.lyadev.cleanhome.entity.UserEntity;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class FirebaseUserDetailsService implements UserDetailsService {
    UserService userService;
    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("UserName " + username);
        UserDetails userDetails;
        try {
            UserRecord userRecord = FirebaseAuth.getInstance().getUser(username);
            UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
            userDetails = user;
        } catch (FirebaseAuthException e) {
            throw new RuntimeException(e);

        }
        return userDetails;
    }
}
