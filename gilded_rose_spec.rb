require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    it "never descrease quality to lower than 0" do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 0
    end

    it "never increase quality to greater than 50" do
      items = [Item.new('Aged Brie', 10, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 50
    end

    context "before the concert" do
      it "descrease sell_in and quality" do
        items = [Item.new('foo', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 9
      end

      it "increase quality as Aged Brie get older" do
        items = [Item.new('Aged Brie', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 11
      end

      it "never descrease quality for Sulfuras" do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 10
      end

      it "drops quality to 0 for Backstage" do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end

      it "increases quality by 2 when 10 days or less for Backstage" do
        items = [
          Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10),
          Item.new('Backstage passes to a TAFKAL80ETC concert', 4, 5)
        ]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 13
        expect(items[1].quality).to eq 8
      end

      it "increases quality by 3 when 5 days or less for Backstage" do
        items = [
          Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10),
          Item.new('Backstage passes to a TAFKAL80ETC concert', 9, 5)
        ]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 12
        expect(items[1].quality).to eq 7
      end

      xit "descrease quality as twice for Conjured" do
        items = [Item.new('Conjured Mana Cake', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 8
      end
    end

    context "after the concert" do
      it "descrease sell_in and quality twice" do
        items = [Item.new('foo', -1, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(-2)
        expect(items[0].quality).to eq(8)
      end

      it "increase quality twice as Aged Brie get older" do
        items = [Item.new('Aged Brie', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 12
      end

      it "never descrease quality for Sulfuras" do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 10
      end

      it "descrease quality twice as fast as normal items for Conjured" do
        items = [Item.new('Conjured Mana Cake', -1, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(-2)
        expect(items[0].quality).to eq 6
      end
    end
  end
end
