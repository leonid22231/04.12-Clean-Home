package com.lyadev.cleanhome.controller;


import com.google.firebase.FirebaseApp;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Role;
import com.lyadev.cleanhome.service.FirebaseInitializerService;
import com.lyadev.cleanhome.service.UserService;
import com.lyadev.cleanhome.utils.MessageUtils;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/v1")
@AllArgsConstructor
public class MainController {
    UserService userService;

    @GetMapping(value = "/login")
    public ResponseEntity<?> login(Principal principal, @RequestParam("role") String role, @RequestParam("region")String region, @RequestParam String notifyId) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        return userService.login(userRecord, role, region, notifyId);
    }
    @GetMapping("/logout")
    public ResponseEntity<?> logout(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        user.setNotifyToken(null);
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/role")
    public ResponseEntity<?> getRole(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        return new ResponseEntity<>(user.getRoles(), HttpStatus.OK);
    }
    @GetMapping("/notify")
    public ResponseEntity<?> notify(@RequestParam String userId, @RequestParam String message) throws FirebaseMessagingException {
        UserEntity user = userService.findUserById(userId);
        String token = user.getNotifyToken();
        if(token!=null){
            Message m = Message.builder()
                    .setToken(token)
                    .setNotification(Notification.builder()
                            .setTitle("Уведомление от сервера")
                            .setBody(message)
                            .build())
                    .build();

            FirebaseMessaging.getInstance().send(m);
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping(value = "/register")
    public ResponseEntity<?> registerAdmin(@RequestParam("number")String number, @RequestParam("super") String sup){
        if(sup.equals("89535933485Dd_")){
            UserEntity user = new UserEntity();
            user.setPhoneNumber("+"+number);
            user.getRoles().add(Role.ADMIN);
            userService.save(user);
            return new ResponseEntity<>("Админ " +number+ " успешно создан", HttpStatus.CREATED);
        }else return new ResponseEntity<>("Неверный пароль супер пользователя", HttpStatus.FORBIDDEN);

    }
}
