package com.lyadev.cleanhome.repository;

import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, String> {
    UserEntity findUserEntityByPhoneNumber(String phoneNumber);
    UserEntity findUserEntityById(String id);
    List<UserEntity> findUserEntityByRegion(RegionEntity region);
}
