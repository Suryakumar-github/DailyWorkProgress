package OpenClosePrinciple.good;

import OpenClosePrinciple.WritingEquipments;

import java.util.List;

public class PriceCalculator {
    public int calculatePrice(List<WritingEquipments> writingEquipments) {
        int price = 0;
        for(int i = 0; i < writingEquipments.size(); i++) {
            price += writingEquipments.get(i).getPrice();
        }
        return price;
    }
}
