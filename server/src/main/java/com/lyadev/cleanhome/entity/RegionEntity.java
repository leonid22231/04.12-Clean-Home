package com.lyadev.cleanhome.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Reference;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "regions")
@Getter
@Setter
public class RegionEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(unique = true)
    private String name;

    private double priceRoom;

    private double priceBathroom;
    private double priceSize;

    @OneToMany()
    private List<OptionEntity> options = new ArrayList<>();

    @OneToMany(mappedBy = "id", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<OrderEntity> orders = new ArrayList<>();

    @OneToMany()
    private List<NewsEntity> news = new ArrayList<>();
    @JsonIgnore
    @OneToMany()
    private List<UserEntity> users = new ArrayList<>();
    @JsonIgnore
    @OneToMany()
    private List<UserEntity> cleaner = new ArrayList<>();
}
