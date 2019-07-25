class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      degrader_class = resolve_degrader(item)
      degrader_class.degrade(item)
    end
  end


  private

  def resolve_degrader(item)
    [
      LegendaryQualityDegrader,
      IncreaseQualityDegrader,
      BackstageQualityDegrader,
      TwiceQualityDegrader
    ].each do |degrader_class|
      return degrader_class if degrader_class::ITEMS.include?(item.name)
    end
    NormalQualityDegrader
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class ApplicationQualityDegrader
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def self.degrade(item)
    new(item).degrade
  end

  def degrade
    descrease_date
    degrade_quality
    limit_quality_value
    item
  end

  private

  def degrade_quality
    raise "degrade_quality need to be implement"
  end

  def descrease_date
    item.sell_in = item.sell_in - 1
  end

  def limit_quality_value
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end

  def quality_to_change
    item.sell_in < 0 ? 2 : 1
  end
end

class NormalQualityDegrader < ApplicationQualityDegrader
  private

  def degrade_quality
    item.quality = item.quality - quality_to_change
  end
end

class LegendaryQualityDegrader < ApplicationQualityDegrader
  ITEMS = ["Sulfuras, Hand of Ragnaros"]

  def degrade
    item
  end
end

class IncreaseQualityDegrader < ApplicationQualityDegrader
  ITEMS = ["Aged Brie"]

  private

  def degrade_quality
    item.quality = item.quality + 1
  end
end

class BackstageQualityDegrader < ApplicationQualityDegrader
  ITEMS = ["Backstage passes to a TAFKAL80ETC concert"]

  private

  def degrade_quality
    item.quality = item.quality + quality_to_change
  end

  def limit_quality_value
    super
    item.quality = 0 if item.sell_in < 0
  end

  def quality_to_change
    return 3 if item.sell_in <= 5
    return 2 if item.sell_in <= 10
    1
  end
end


class TwiceQualityDegrader < ApplicationQualityDegrader
  ITEMS = ["Conjured Mana Cake"]

  private

  def degrade_quality
    item.quality = item.quality - quality_to_change
  end

  def quality_to_change
    super * 2
  end
end
