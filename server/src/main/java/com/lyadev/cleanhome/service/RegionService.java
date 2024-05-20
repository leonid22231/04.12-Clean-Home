package com.lyadev.cleanhome.service;

import com.lyadev.cleanhome.entity.RegionEntity;
import com.lyadev.cleanhome.repository.RegionRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class RegionService {
    private RegionRepository regionRepository;

    public RegionEntity findRegionById(String id){
        return regionRepository.findRegionEntityById(id);
    }
    public List<RegionEntity> findAllRegions(){
       return regionRepository.findAll();
    }

    public void save(RegionEntity region){
        regionRepository.save(region);
    }
}
