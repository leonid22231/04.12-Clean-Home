package com.lyadev.cleanhome.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.lyadev.cleanhome.entity.NewsEntity;
import com.lyadev.cleanhome.entity.OptionEntity;
import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Role;
import com.lyadev.cleanhome.service.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/api/v1/region")
@AllArgsConstructor
public class RegionController {
    RegionService regionService;
    NewsService newsService;
    OptionService optionService;
    UserService userService;
    OrderService orderService;

    @GetMapping("")
    public ResponseEntity<?> findAllRegions(){
        return new ResponseEntity<>(regionService.findAllRegions(), HttpStatus.OK);
    }
    @PostMapping("/create")
    public ResponseEntity<?> createRegion(@RequestParam("name")String name,@RequestParam("priceRoom") Double priceRoom,@RequestParam("priceBathroom") Double priceBathroom,@RequestParam("priceSize")Double priceSize){
        RegionEntity region = new RegionEntity();
        region.setName(name);
        region.setPriceRoom(priceRoom);
        region.setPriceBathroom(priceBathroom);
        regionService.save(region);
        return new ResponseEntity<>("Регион "+name + " создан", HttpStatus.CREATED);
    }
    @PostMapping("/{id}/edit")
    public ResponseEntity<?> editRegion(@PathVariable String id, @RequestParam Double pricedRoom, @RequestParam Double priceBathRoom,@RequestParam Double priceSize){
        RegionEntity region = regionService.findRegionById(id);
        region.setPriceRoom(pricedRoom);
        region.setPriceBathroom(priceBathRoom);
        region.setPriceSize(priceSize);
        regionService.save(region);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/option/{option}/edit")
    public  ResponseEntity<?> editOption(@PathVariable String option, @RequestParam(required = false) String name, @RequestParam(required = false) Double price, @RequestParam(required = false) String info){
        OptionEntity optionEntity = optionService.findOptionById(option);
        if(name!=null && !name.isEmpty()){
            optionEntity.setName(name);
        }
        if(price!=null && price>0){
            optionEntity.setPrice(price);
        }
        if(info != null && !info.isEmpty()){
            optionEntity.setDescription(info);
        }
        optionService.save(optionEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/{id}/managers")
    public ResponseEntity<?> findMenagers(@PathVariable String id){
        RegionEntity region = regionService.findRegionById(id);
        List<UserEntity> menegers = new ArrayList<>();
        List<UserEntity> userEntities = userService.findUserByRegion(region);
         for(UserEntity user : userEntities){
            if(user.getRoles().contains(Role.MANAGER)){
                menegers.add(user);
            }
        }
         return new ResponseEntity<>(menegers, HttpStatus.OK);
    }
    @PostMapping("/{id}/addManager")
    public ResponseEntity<?> addManager(@PathVariable("id")String region_id, @RequestParam String id){
        RegionEntity region = regionService.findRegionById(region_id);
        UserEntity user = userService.findUserById(id);
        if(user.getRoles().contains(Role.USER)){
            user.getRoles().remove(Role.USER);
        } else user.getRoles().remove(Role.CLEANER);
        user.getRoles().add(Role.MANAGER);
        user.setRegion(region);
        userService.save(user);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/deleteManager")
    public ResponseEntity<?> deleteManager(@RequestParam String id){
        UserEntity user = userService.findUserById(id);
        user.getRoles().clear();
        user.setRegion(null);
        userService.save(user);

        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/getAllUsers")
    public ResponseEntity<?> allUsersSort(@RequestParam(required = false)String search){
        List<UserEntity> users = userService.findAll();
            List<UserEntity> userEntities = new ArrayList<>();
            for(UserEntity user : users){
                if(!user.getRoles().contains(Role.MANAGER) && !user.getRoles().contains(Role.ADMIN)  || user.getRoles().size()<1){
                    userEntities.add(user);
                }
            }
            if(search==null || search.isEmpty()){
                return new ResponseEntity<>(userEntities, HttpStatus.OK);
            }else {
                List<UserEntity> list = new ArrayList<>();
                for(UserEntity user : userEntities){
                    if(user.getPhoneNumber().contains(search)){
                        list.add(user);
                    }
                }
                return new ResponseEntity<>(list, HttpStatus.OK);
            }
    }
    @GetMapping("/{id}/news")
    public ResponseEntity<?> findNewsRegion(@PathVariable("id")String id){
        RegionEntity region = regionService.findRegionById(id);

        return new ResponseEntity<>(region.getNews(), HttpStatus.OK);
    }
    @GetMapping("/{id}/options")
    public ResponseEntity<?> getOptions(@PathVariable String id){
        return new ResponseEntity<>(regionService.findRegionById(id).getOptions(), HttpStatus.OK);
    }
    @PostMapping("/{id}/deleteOption")
    public ResponseEntity<?> deleteOption(@PathVariable String id, @RequestParam("id") String option_id){
        OptionEntity optionEntity = optionService.findOptionById(option_id);
        RegionEntity region = regionService.findRegionById(id);
        for(int i = 0; i < region.getOptions().size(); i++){
            if(Objects.equals(option_id, region.getOptions().get(i).getId())){
                region.getOptions().remove(i);
            }
        }
        regionService.save(region);
        try {
            optionService.delete(optionEntity);
            return  new ResponseEntity<>(HttpStatus.OK);
        }catch (Exception e){
            return new ResponseEntity<>("Опция будет полностью удалена, когда все заказы с ней закроются", HttpStatus.OK);
        }
    }
    @PostMapping("/{id}/pushOption")
    public ResponseEntity<?> pushOption(@PathVariable("id")String id, @RequestParam String name, @RequestParam(required = false) String description, @RequestParam Double price){
        RegionEntity regionEntity = regionService.findRegionById(id);
        OptionEntity optionEntity = new OptionEntity();
        optionEntity.setName(name);
        if(description!=null && !description.isEmpty())optionEntity.setDescription(description);
        optionEntity.setPrice(price);
        optionEntity.setRegion(regionEntity);

        optionService.save(optionEntity);

        regionEntity.getOptions().add(optionEntity);

        regionService.save(regionEntity);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/{id}/users")
    public ResponseEntity<?> getUsers(@PathVariable("id")String id, @RequestParam(required = false) String search){
        UserList userList = new UserList();
        RegionEntity region = regionService.findRegionById(id);
        if(search!=null && !search.isEmpty()){
            List<UserEntity> users = new ArrayList<>();
            List<UserEntity> cleaners = new ArrayList<>();
            for(UserEntity user : region.getUsers()){
                if(user.getPhoneNumber().contains(search)){
                    users.add(user);
                }
            }
            for(UserEntity user : region.getCleaner()){
                if(user.getPhoneNumber().contains(search)){
                    cleaners.add(user);
                }
            }
            userList.setUsers(users);
            userList.setCleaners(cleaners);
        }else{
            userList.setUsers(region.getUsers());
            userList.setCleaners(region.getCleaner());
        }
        return new ResponseEntity<>(userList, HttpStatus.OK);
    }
    @PostMapping("/{id}/pushNews")
    public ResponseEntity<?> pushNews(@PathVariable("id")String id, @RequestParam String title, @RequestParam String info){
        RegionEntity region = regionService.findRegionById(id);
        NewsEntity news = new NewsEntity();
        news.setTitle(title);
        news.setInfo(info);
        news.setRegion(region);

        newsService.save(news);

        region.getNews().add(news);

        regionService.save(region);
        return new ResponseEntity<>(region.getNews(), HttpStatus.OK);
    }
}
@Getter
@Setter
class UserList{
    List<UserEntity> users;
    List<UserEntity> cleaners;
}