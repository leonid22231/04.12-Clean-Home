package com.lyadev.cleanhome.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "addresses")
@Getter
@Setter
public class AddressEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.EAGER, optional = true, cascade = CascadeType.ALL)
    @JoinColumn(name="city.name", nullable = true, referencedColumnName = "name")
    RegionEntity city;

    String street;
    String house;
    String frame;
    String entrance;
    String apartment;
    String intercom;
    String floor;

    @JsonProperty("city")
    public String getCity(){
        if(city!=null){
            return city.getName();
        }else {
            return "";
        }
    }

    @Override
    public String toString() {
        return street+", д. "+house+" кв. "+apartment;
    }
}
