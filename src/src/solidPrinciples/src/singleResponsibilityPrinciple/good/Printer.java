package singleResponsibilityPrinciple.good;

import java.util.List;

public class Printer {
    public void printProductDetails(List<Object> writingEquipments) {
        for(Object equipment : writingEquipments) {
            System.out.println(equipment);
        }
    }
}
