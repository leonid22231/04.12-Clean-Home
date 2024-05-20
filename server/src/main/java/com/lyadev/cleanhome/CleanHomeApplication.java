package com.lyadev.cleanhome;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Random;

@SpringBootApplication()
public class CleanHomeApplication {

	public static void main(String[] args) throws FirebaseMessagingException {
		SpringApplication.run(CleanHomeApplication.class, args);
	}

}
