package com.example.nieruchomosci.controller;

import com.example.nieruchomosci.model.Property;
import com.example.nieruchomosci.service.PropertyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class PropertyController {
    
    @Autowired
    private PropertyService propertyService;
    
    // Strona główna - lista ogłoszeń
    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("properties", propertyService.getAllProperties());
        return "index";
    }
    
    // Formularz dodawania ogłoszenia
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("property", new Property());
        return "add-property";
    }
    
    // Zapisywanie ogłoszenia
    @PostMapping("/add")
    public String addProperty(@ModelAttribute Property property) {
        propertyService.saveProperty(property);
        return "redirect:/";
    }
    
    // Szczegóły ogłoszenia
    @GetMapping("/property/{id}")
    public String showProperty(@PathVariable Long id, Model model) {
        model.addAttribute("property", propertyService.getPropertyById(id));
        return "property-details";
    }
}
