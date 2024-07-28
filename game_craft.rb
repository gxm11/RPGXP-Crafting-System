class Game_Craft
  CRAFT_RECIPES = []

  def initialize
    # Initialize method remains empty for now
  end

  def recipes
    CRAFT_RECIPES
  end

  def add_recipe
    recipe = {}
    @target = nil
    @materials = []
    yield(self)
    recipe["target"] = @target if @target
    recipe["materials"] = @materials if @materials
    CRAFT_RECIPES << recipe
    @target = nil
    @materials = nil
  end

  def create(kind, id, number)
    @target = { "kind" => kind, "id" => id, "number" => number }
  end

  def consume(kind, id, number)
    @materials << { "kind" => kind, "id" => id, "number" => number }
  end

  # 检查是否可以合成
  def calculate_max_craft_quantity(recipe)
    max_quantities = recipe["materials"].map do |material|
      case material["kind"]
      when :item
        $game_party.item_number(material["id"]) / material["number"]
      when :weapon
        $game_party.weapon_number(material["id"]) / material["number"]
      when :armor
        $game_party.armor_number(material["id"]) / material["number"]
      end
    end
    max_quantities.min
  end

  def can_craft?(recipe)
    recipe["materials"].all? do |material|
      case material["kind"]
      when :item
        $game_party.item_number(material["id"]) >= material["number"]
      when :weapon
        $game_party.weapon_number(material["id"]) >= material["number"]
      when :armor
        $game_party.armor_number(material["id"]) >= material["number"]
      end
    end
  end
end
