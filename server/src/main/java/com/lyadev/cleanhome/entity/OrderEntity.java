package com.lyadev.cleanhome.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.lyadev.cleanhome.entity.enums.Role;
import com.lyadev.cleanhome.entity.enums.Status;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Entity
@Table(name = "orders")
@Getter
@Setter
public class OrderEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Enumerated(EnumType.STRING)
    private Status status;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name="region", nullable = false)
    private RegionEntity region;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name="address", nullable = false)
    private AddressEntity address;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user", nullable = false)
    private UserEntity user;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "cleaner", nullable = true)
    private UserEntity cleaner;

    @JsonProperty("cleaner")
    String cleaner_id(){
        if(cleaner!=null)
            return cleaner.getId();
        else return null;
    }

    @ManyToMany()
    private List<OptionEntity> options;

    private int countRoom;

    private int countBathroom;

    private Date createDate;
    private Date startDate;
    private double customPrice;
    private double size;
    private Date finishDate;
}
