package com.lyadev.cleanhome.service;

import com.lyadev.cleanhome.entity.OrderEntity;
import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.entity.UserEntity;
import com.lyadev.cleanhome.entity.enums.Status;
import com.lyadev.cleanhome.repository.OrderRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@AllArgsConstructor
public class OrderService {
    OrderRepository orderRepository;

    public List<OrderEntity> findAll(){
        return  orderRepository.findAll();
    }
    public List<OrderEntity> findUserOrders(UserEntity user){
        List<OrderEntity> _list = orderRepository.findOrderEntitiesByUserAndRegionOrderByCreateDate(user, user.getRegion());
        List<OrderEntity> list = new ArrayList<>();
        for(OrderEntity order : _list){
            if(order.getStatus().equals(Status.WORK_CANCEL) || order.getStatus().equals(Status.WORK_FINISH)){
                continue;
            }
            list.add(order);
        }
        return list;
    }
    public List<OrderEntity> findOrderByStatusDind(RegionEntity region){
        return orderRepository.findOrderEntitiesByRegionAndStatus(region, Status.FINDING_CLEANER);
    }
    public List<OrderEntity> findOrderByRegionAndCleaner(RegionEntity region, UserEntity user){
        List<OrderEntity> orderEntities = orderRepository.findOrderEntitiesByRegionAndCleaner(region, user);
        List<OrderEntity> orderEntities_ = new ArrayList<>();
        for(OrderEntity order : orderEntities){
            if(order.getStatus()!=Status.WORK_FINISH && order.getStatus()!=Status.WORK_CANCEL){
                orderEntities_.add(order);
            }
        }
        return  orderEntities_;
    }
    public List<OrderEntity> findDoneUserOrders(UserEntity user){
        List<OrderEntity> _list = orderRepository.findOrderEntitiesByUserAndRegionOrderByCreateDate(user, user.getRegion());
        List<OrderEntity> list = new ArrayList<>();
        for(OrderEntity order : _list){
            if(order.getStatus().equals(Status.WORK_CANCEL) || order.getStatus().equals(Status.WORK_FINISH)){
                list.add(order);
            }
        }
        return list;
    }

    public OrderEntity findOrderById(String id){
        return orderRepository.findOrderEntityById(id);
    }
    public void save(OrderEntity orderEntity){
        orderRepository.save(orderEntity);
    }
    public void delete(OrderEntity order){
        orderRepository.delete(order);
    }
}
