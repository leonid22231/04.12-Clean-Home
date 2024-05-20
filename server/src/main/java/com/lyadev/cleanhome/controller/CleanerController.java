package com.lyadev.cleanhome.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.lyadev.cleanhome.entity.OrderEntity;
import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Status;
import com.lyadev.cleanhome.service.OrderService;
import com.lyadev.cleanhome.service.RegionService;
import com.lyadev.cleanhome.service.UserService;
import com.lyadev.cleanhome.utils.MessageUtils;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Date;

@Controller
@RequestMapping("/api/v1/cleaner")
@AllArgsConstructor
public class CleanerController {
    OrderService orderService;
    UserService userService;
    RegionService regionService;
    @PostMapping("/selectOrder")
    public ResponseEntity<?> selectOrder(Principal principal, String order) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        OrderEntity orderEntity = orderService.findOrderById(order);
        orderEntity.setCleaner(user);
        orderEntity.setStatus(Status.FOUND_CLEANER);
        orderService.save(orderEntity);
        if(user.getNotifyToken()!=null){
            MessageUtils.UpdateMessage(user.getNotifyToken());
        }
        if(orderEntity.getUser().getNotifyToken()!=null){
            MessageUtils.NotificationMessage(orderEntity.getUser().getNotifyToken(), "Клинер найден !");
            MessageUtils.UpdateMessage(orderEntity.getUser().getNotifyToken());
        }
        return  new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/startOrder")
    public ResponseEntity<?> startOrder(Principal principal,String order) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        OrderEntity orderEntity = orderService.findOrderById(order);
        orderEntity.setStatus(Status.WORK_STARTED);
        orderService.save(orderEntity);
        if(user.getNotifyToken()!=null){
            MessageUtils.UpdateMessage(user.getNotifyToken());
        }
        if(orderEntity.getUser().getNotifyToken()!=null){
            MessageUtils.NotificationMessage(orderEntity.getUser().getNotifyToken(), "Клинер приступил к работе !");
            MessageUtils.UpdateMessage(orderEntity.getUser().getNotifyToken());
        }
        return  new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/endOrder")
    public ResponseEntity<?> endOrder(Principal principal,String order) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        OrderEntity orderEntity = orderService.findOrderById(order);
        orderEntity.setStatus(Status.WORK_FINISH);
        orderEntity.setFinishDate(Date.from(OffsetDateTime.now().toLocalDateTime().toInstant(ZoneOffset.UTC)));
        orderService.save(orderEntity);
        if(user.getNotifyToken()!=null){
            MessageUtils.UpdateMessage(user.getNotifyToken());
        }
        if(orderEntity.getUser().getNotifyToken()!=null){
            MessageUtils.NotificationMessage(orderEntity.getUser().getNotifyToken(), "Клинер закончил работу !");
            MessageUtils.UpdateMessage(orderEntity.getUser().getNotifyToken());
        }
        return  new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/orders")
    public ResponseEntity<?> orders(Principal principal) throws FirebaseAuthException {
        System.out.println(principal);
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        RegionEntity region = regionService.findRegionById(user.getRegion().getId());

        return new ResponseEntity<>(orderService.findOrderByRegionAndCleaner(region, user), HttpStatus.OK);
    }
    @GetMapping("/findOrders")
    public ResponseEntity<?> findOrders(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());

        return new ResponseEntity<>(orderService.findOrderByStatusDind(user.getRegion()), HttpStatus.OK);
    }
}
