package com.lyadev.cleanhome.utils;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

public class MessageUtils {
    public static void NotificationMessage(String to,String text){
        Message message = Message.builder()
                .setToken(to)
                .setNotification(Notification.builder()
                        .setTitle("Уведомление")
                        .setBody(text)
                        .build())
                .build();

        try {
            FirebaseMessaging.getInstance().send(message);
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException(e);
        }
    }
    public static void UpdateMessage(String to){
        try {
            FirebaseMessaging.getInstance().send(Message.builder()
                    .putData("action","update")
                    .setToken(to)
                    .build());
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException(e);
        }
    }
    public static void LogIn(String to, String role){
        try {
            FirebaseMessaging.getInstance().send(Message.builder()
                    .putData("login","yes")
                    .putData("role",role)
                    .setToken(to)
                    .build());
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException(e);
        }
    }
    public static void LogOut(String to){
        try {
            FirebaseMessaging.getInstance().send(Message.builder()
                    .putData("logout","yes")
                    .setToken(to)
                    .build());
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
