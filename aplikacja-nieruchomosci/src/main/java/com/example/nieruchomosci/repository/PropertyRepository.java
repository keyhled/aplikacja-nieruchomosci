package com.example.nieruchomosci.repository;

import com.example.nieruchomosci.model.Property;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PropertyRepository extends JpaRepository<Property, Long> {
    // Spring Data JPA automatycznie zapewnia podstawowe operacje CRUD
}
