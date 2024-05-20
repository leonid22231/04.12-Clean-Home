package com.lyadev.cleanhome.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.lyadev.cleanhome.entity.*;
import com.lyadev.cleanhome.entity.enums.Status;
import com.lyadev.cleanhome.service.*;
import com.lyadev.cleanhome.utils.MessageUtils;
import lombok.AllArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/api/v1/user")
@AllArgsConstructor
public class UserController {
    UserService userService;
    OrderService orderService;
    OptionService optionService;
    RegionService regionService;
    AddressService addressService;

    @GetMapping("")
    public ResponseEntity<?> userInfo(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        return new ResponseEntity<>(userService.findUserByPhoneNumber(userRecord.getPhoneNumber()), HttpStatus.OK);
    }
    @PostMapping("/delete")
    public ResponseEntity<?> deleteAccount(Principal principal, @RequestParam(required = false)String id) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user;
        if(id!=null && !id.isEmpty()){
            user = userService.findUserById(id);
        }else{
            user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        }
        List<RegionEntity> allReg = regionService.findAllRegions();
        for(RegionEntity region : allReg){
            for(int i = 0; i < region.getUsers().size(); i++){
                if(region.getUsers().get(i).getId().equals(user.getId())){
                    region.getUsers().remove(i);
                }
            }
            for(int i = 0; i < region.getCleaner().size(); i++){
                if(region.getCleaner().get(i).getId().equals(user.getId())){
                    region.getCleaner().remove(i);
                }
            }
            regionService.save(region);
        }

        List<OrderEntity> orders = orderService.findAll();
        for(int i = 0; i < orders.size(); i++){
            if(orders.get(i).getUser().getId().equals(user.getId()) || orders.get(i).getCleaner()!=null && orders.get(i).getCleaner().getId().equals(user.getId())){
                orderService.delete(orders.get(i));
            }
        }
        userService.delete(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/orders")
    public ResponseEntity<?> userOrders(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());

        return new ResponseEntity<>(orderService.findUserOrders(user), HttpStatus.OK);
    }
    @GetMapping("/ordersDone")
    public ResponseEntity<?> userOrdersDone(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());

        return new ResponseEntity<>(orderService.findDoneUserOrders(user), HttpStatus.OK);
    }
    @GetMapping("/addresses")
    public ResponseEntity<?> userAddresses(Principal principal) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        List<AddressEntity> _addresses = user.getAddresses();
        List<AddressEntity> addresses = new ArrayList<>();
        for(AddressEntity address : _addresses){
            if(address.getCity().equals(user.getRegion().getName())){
                addresses.add(address);
            }
        }
        return new ResponseEntity<>(addresses, HttpStatus.OK);
    }
    @PostMapping("/addresses/push")
    public ResponseEntity<?> createAddress(Principal principal, @RequestParam String street, @RequestParam String house,@RequestParam String frame ,@RequestParam String entrance, @RequestParam String apartment, @RequestParam String intercom, @RequestParam String floor) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        AddressEntity addressEntity = new AddressEntity();
        addressEntity.setCity(regionService.findRegionById(user.getRegion().getId()));
        addressEntity.setStreet(street);
        addressEntity.setHouse(house);
        addressEntity.setFrame(frame);
        addressEntity.setEntrance(entrance);
        addressEntity.setApartment(apartment);
        addressEntity.setIntercom(intercom);
        addressEntity.setFloor(floor);

        addressService.save(addressEntity);

        user.getAddresses().add(addressEntity);

        userService.save(user);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }
    @PostMapping("/addresses/{id}/delete")
    public ResponseEntity<?> createAddress(Principal principal, @PathVariable String id) throws FirebaseAuthException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        for(int i = 0; i < user.getAddresses().size(); i ++){
            if(user.getAddresses().get(i).getId().equals(id)){
                user.getAddresses().remove(i);
            }
        }
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/notifyUpdate")
    public ResponseEntity<?> notifyUpdate(Principal principal, @RequestParam String notifyToken) throws FirebaseAuthException, FirebaseMessagingException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        user.setNotifyToken(notifyToken);

        userService.save(user);

        Notification notification = Notification.builder()
                .setTitle("Внимание")
                .setBody("Токен успешно обновлен")
                .build();
        Message message = Message.builder()
                .setToken(user.getNotifyToken())
                .setNotification(notification)
                .build();
        FirebaseMessaging.getInstance().send(message);

        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/orders/push")
    public ResponseEntity<?> createOrder(Principal principal, @RequestParam int countRoom, @RequestParam int countBathroom, @RequestParam String address, @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,@RequestParam(required = false)Double customPrice,@RequestParam(required = false)Double size, @RequestParam(required = false) String... options) throws FirebaseAuthException, FirebaseMessagingException {
        UserRecord userRecord = FirebaseAuth.getInstance().getUser(principal.getName());
        UserEntity user = userService.findUserByPhoneNumber(userRecord.getPhoneNumber());
        OrderEntity orderEntity = new OrderEntity();
        orderEntity.setUser(user);
        orderEntity.setStartDate(Date.from(startDate.toInstant(ZoneOffset.UTC)));
        orderEntity.setCreateDate(Date.from(OffsetDateTime.now().toLocalDateTime().toInstant(ZoneOffset.UTC)));
        orderEntity.setCountRoom(countRoom);
        orderEntity.setCountBathroom(countBathroom);
        if(customPrice!=null) orderEntity.setCustomPrice(customPrice);
        if(size!=null) orderEntity.setSize(size);
        orderEntity.setAddress(addressService.findAddressById(address));
        List<OptionEntity> list = new ArrayList<>();
        if(options!=null)
            if(options.length>0){
                for(String id: options){
                    list.add(optionService.findOptionById(id));
                }
            }
        orderEntity.setOptions(list);
        orderEntity.setStatus(Status.FINDING_CLEANER);
        orderEntity.setRegion(user.getRegion());

        orderService.save(orderEntity);

        RegionEntity region = regionService.findRegionById(user.getRegion().getId());
        region.getOrders().add(orderEntity);
        regionService.save(user.getRegion());

        if(user.getNotifyToken()!=null) MessageUtils.UpdateMessage(user.getNotifyToken());
        for(UserEntity user1 : region.getCleaner()){
            MessageUtils.UpdateMessage(user1.getNotifyToken());
            MessageUtils.NotificationMessage(user1.getNotifyToken(), "Появился новый заказ !");
        }
        return new ResponseEntity<>(orderEntity, HttpStatus.OK);
    }
    @PostMapping("/orders/{id}/cancel")
    public ResponseEntity<?> cancelOrder(@PathVariable String id) throws FirebaseMessagingException {
        OrderEntity order = orderService.findOrderById(id);
        UserEntity client = userService.findUserById(order.getUser().getId());
        order.setStatus(Status.WORK_CANCEL);
        if(order.getCleaner()!=null){
            UserEntity cleaner = userService.findUserById(order.getCleaner().getId());
            if(cleaner.getNotifyToken()!=null){
                MessageUtils.NotificationMessage(cleaner.getNotifyToken(), "Ваш заказ "+order.getAddress().toString()+" отменен");
                MessageUtils.NotificationMessage(client.getNotifyToken(), "Уборка отменена. Ей уже был назначен клинер из-за этого у вас падает рейтинг!");
                orderService.save(order);
                return new ResponseEntity<>(HttpStatus.OK);
            }
        }
        orderService.save(order);
        MessageUtils.NotificationMessage(client.getNotifyToken(), "Уборка отменена");
        MessageUtils.UpdateMessage(client.getNotifyToken());
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
