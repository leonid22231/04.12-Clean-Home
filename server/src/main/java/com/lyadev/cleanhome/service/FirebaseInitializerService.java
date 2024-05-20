package com.lyadev.cleanhome.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

@Service
public class FirebaseInitializerService {
    private static final Logger logger = LoggerFactory.getLogger(FirebaseInitializerService.class);

    @PostConstruct
    private void onStart(){
        logger.info("Firebase Initializing");
        try {
            initFirebase();
        }catch (IOException e){
            logger.info("Initializing firebase " + e);
        }
    }

    private void initFirebase() throws IOException {
        InputStream refreshToken = this.getClass().getClassLoader().getResourceAsStream("./clean-home-application-firebase-adminsdk-edgat-f3457bf3f2.json");

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(refreshToken))
                .build();

        if(FirebaseApp.getApps() == null ||FirebaseApp.getApps().isEmpty())
            FirebaseApp.initializeApp(options);
    }
}
