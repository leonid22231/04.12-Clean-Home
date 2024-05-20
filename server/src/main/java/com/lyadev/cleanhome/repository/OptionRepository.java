package com.lyadev.cleanhome.repository;

import com.lyadev.cleanhome.entity.OptionEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OptionRepository extends JpaRepository<OptionEntity, String> {
    OptionEntity findOptionEntityById(String id);
}
