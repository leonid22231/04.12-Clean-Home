package com.lyadev.cleanhome.service;

import com.lyadev.cleanhome.entity.NewsEntity;
import com.lyadev.cleanhome.repository.NewsRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class NewsService {
    NewsRepository newsRepository;

    public void save(NewsEntity newsEntity){
        newsRepository.save(newsEntity);
    }
}
