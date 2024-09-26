package singleResponsibilityPrinciple.good;

import singleResponsibilityPrinciple.Pen;
import singleResponsibilityPrinciple.Pencil;

import java.util.List;

public class PriceCalculator {
    public int calculatePrice(List<Object> writingEquipments) {
        int price = 0;
        for(Object equipement : writingEquipments) {
            if(equipement instanceof Pencil) {
                price += 10;
            }
            if(equipement instanceof Pen) {
                price += 50;
            }
        }
        return price;
    }
}