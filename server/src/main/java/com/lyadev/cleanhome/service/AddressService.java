package com.lyadev.cleanhome.service;

import com.lyadev.cleanhome.entity.AddressEntity;
import com.lyadev.cleanhome.repository.AddressRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AddressService {
    AddressRepository addressRepository;
    public void save(AddressEntity addressEntity){
        addressRepository.save(addressEntity);
    }
    public AddressEntity findAddressById(String id){
        return addressRepository.findAddressEntityById(id);
    }
}
