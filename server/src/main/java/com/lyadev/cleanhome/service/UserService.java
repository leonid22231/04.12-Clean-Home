package com.lyadev.cleanhome.service;

import com.google.firebase.auth.UserRecord;
import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Role;
import com.lyadev.cleanhome.repository.UserRepository;
import com.lyadev.cleanhome.utils.MessageUtils;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
@AllArgsConstructor
public class UserService {
    private UserRepository userRepository;
    private RegionService regionService;

    public List<UserEntity> findAll(){
        return  userRepository.findAll();
    }
    public ResponseEntity<?> login(UserRecord userRecord, String role, String regionId, String notifyId){
        UserEntity user = userRepository.findUserEntityByPhoneNumber(userRecord.getPhoneNumber());
        RegionEntity region = regionService.findRegionById(regionId);
        if(Role.valueOf(role)!=Role.ADMIN && Role.valueOf(role)!=Role.MANAGER)
        if(user==null){
            user = new UserEntity();
            user.setPhoneNumber(userRecord.getPhoneNumber());
            user.setCreateDate(new Date(userRecord.getUserMetadata().getCreationTimestamp()));
            user.setActivate(true);
            user.setNotifyToken(notifyId);
            user.getRoles().add(Role.valueOf(role));
            user.setRegion(region);
        }else {
               user.setRegion(regionService.findRegionById(regionId));
               user.setNotifyToken(notifyId);
        }
        if(user.getRoles().isEmpty()){
            user.getRoles().add(Role.valueOf(role));
        }
        userRepository.save(user);
        if(user.getRoles().contains(Role.valueOf(role))){
            checkUser(user, region);
            return new ResponseEntity<>(user, HttpStatus.OK);
        }else {
            if(user.getRoles().contains(Role.MANAGER) || user.getRoles().contains(Role.ADMIN)){
                if(user.getRoles().contains(Role.MANAGER)){
                    if(!user.getRegion().getId().equals(regionId)){
                        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
                    }else return new ResponseEntity<>(user, HttpStatus.OK);
                }else return new ResponseEntity<>(user, HttpStatus.OK);
            }else{
                return new ResponseEntity<>("Вы не можете зайти как " + role, HttpStatus.FORBIDDEN);
            }
        }
    }
    private void checkUser(UserEntity user, RegionEntity region){
        List<RegionEntity> listRegions = regionService.findAllRegions();
        for(RegionEntity regionEntity : listRegions){
            deleteUserFromRegion(user, regionEntity);
        }
        if(user.getRoles().contains(Role.USER))region.getUsers().add(user);
        if(user.getRoles().contains(Role.CLEANER))region.getCleaner().add(user);
        regionService.save(region);
    }
    private void deleteUserFromRegion(UserEntity user, RegionEntity region){
        for(int i = 0; i < region.getCleaner().size(); i++){
            if(region.getCleaner().get(i).getId()==user.getId()){
                region.getCleaner().remove(i);
            }
        }
        for(int i = 0; i < region.getUsers().size(); i++){
            if(region.getUsers().get(i).getId()==user.getId()){
                region.getUsers().remove(i);
            }
        }
        regionService.save(region);
    }
    public UserEntity findUserByPhoneNumber(String phoneNumber){
        return userRepository.findUserEntityByPhoneNumber(phoneNumber);
    }
    public UserEntity findUserById(String id){
        return  userRepository.findUserEntityById(id);
    }
    public List<UserEntity> findUserByRegion(RegionEntity region){
        return userRepository.findUserEntityByRegion(region);
    }
    public void save(UserEntity user){
        userRepository.save(user);
    }
    public void delete(UserEntity user){
        userRepository.delete(user);
    }
}
