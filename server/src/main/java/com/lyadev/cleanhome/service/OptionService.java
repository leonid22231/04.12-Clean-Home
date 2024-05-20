package com.lyadev.cleanhome.service;

import com.lyadev.cleanhome.entity.OptionEntity;
import com.lyadev.cleanhome.repository.OptionRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class OptionService {
    OptionRepository optionRepository;

    public OptionEntity findOptionById(String id){
        return optionRepository.findOptionEntityById(id);
    }
    public void save(OptionEntity optionEntity){
        optionRepository.save(optionEntity);
    }
    public void delete(OptionEntity option){
        optionRepository.delete(option);
    }
}
