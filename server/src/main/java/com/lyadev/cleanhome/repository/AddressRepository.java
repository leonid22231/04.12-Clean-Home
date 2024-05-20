package com.lyadev.cleanhome.repository;

import com.lyadev.cleanhome.entity.AddressEntity;
import com.lyadev.cleanhome.entity.RegionEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AddressRepository extends JpaRepository<AddressEntity, String> {
    AddressEntity findAddressEntityById(String id);
}
