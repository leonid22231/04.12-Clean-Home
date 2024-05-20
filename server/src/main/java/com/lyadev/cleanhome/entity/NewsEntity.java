package com.lyadev.cleanhome.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "news")
@Getter
@Setter
public class NewsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    private String title;

    private String info;

    private String image;

    private String url;

    @JsonIgnore
    private Date startDate;
    @JsonIgnore
    private Date finishDate;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.EAGER, optional = false,cascade = {CascadeType.MERGE, CascadeType.PERSIST})
    @JoinColumn(name="region", nullable = false)
    private RegionEntity region;

}
