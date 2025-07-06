package com.example.nieruchomosci.service;

import com.example.nieruchomosci.model.Property;
import com.example.nieruchomosci.repository.PropertyRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PropertyService {
    
    @Autowired
    private PropertyRepository propertyRepository;
    
    public List<Property> getAllProperties() {
        return propertyRepository.findAll();
    }
    
    public Property getPropertyById(Long id) {
        return propertyRepository.findById(id).orElse(null);
    }
    
    public void saveProperty(Property property) {
        propertyRepository.save(property);
    }
}
