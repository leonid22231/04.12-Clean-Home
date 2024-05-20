package com.lyadev.cleanhome.repository;

import com.lyadev.cleanhome.entity.NewsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NewsRepository extends JpaRepository<NewsEntity, String> {

}
