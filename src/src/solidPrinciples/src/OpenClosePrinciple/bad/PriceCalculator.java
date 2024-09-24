package OpenClosePrinciple.bad;

import OpenClosePrinciple.Brush;
import OpenClosePrinciple.Pen;
import OpenClosePrinciple.Pencil;

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
            if(equipement instanceof Brush) {
                price += 200;
            }
        }
        return price;
    }
}
