package com.lyadev.cleanhome.repository;

import com.lyadev.cleanhome.entity.OrderEntity;
import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Status;
import com.lyadev.cleanhome.service.UserService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<OrderEntity, String> {
    List<OrderEntity> findOrderEntitiesByUserAndRegionOrderByCreateDate(UserEntity user, RegionEntity region);
    List<OrderEntity> findOrderEntitiesByRegionAndStatus(RegionEntity region, Status status);
    OrderEntity findOrderEntityById(String id);
    List<OrderEntity> findOrderEntitiesByRegionAndCleaner(RegionEntity region, UserEntity user);
}
