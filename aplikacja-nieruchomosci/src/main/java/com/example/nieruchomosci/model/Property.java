package com.example.nieruchomosci.model;

import javax.persistence.*;

@Entity
@Table(name = "properties")
public class Property {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String description;
    private Double price;
    private String location;
    private Integer rooms;
    private Double area;
    private String phoneNumber;
    
    // Konstruktory
    public Property() {}
    
    public Property(String title, String description, Double price, String location, 
                   Integer rooms, Double area, String phoneNumber) {
        this.title = title;
        this.description = description;
        this.price = price;
        this.location = location;
        this.rooms = rooms;
        this.area = area;
        this.phoneNumber = phoneNumber;
    }
    
    // Gettery i settery
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Double getPrice() {
        return price;
    }
    
    public void setPrice(Double price) {
        this.price = price;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public Integer getRooms() {
        return rooms;
    }
    
    public void setRooms(Integer rooms) {
        this.rooms = rooms;
    }
    
    public Double getArea() {
        return area;
    }
    
    public void setArea(Double area) {
        this.area = area;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
