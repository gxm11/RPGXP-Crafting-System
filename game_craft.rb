class Game_Craft
  def initialize(var_id)
    @var_id = var_id
    unless $game_variables[var_id].is_a?(Array)
      $game_variables[var_id] = []
    end
  end

  def recipes
    $game_variables[@var_id].select do |recipe|
      recipe["switch_id"].nil? || $game_switches[recipe["switch_id"]]
    end
  end

  def add_recipe
    recipe = {}
    @target = nil
    @materials = []
    @switch_id = nil
    yield(self)
    recipe["target"] = @target if @target
    recipe["materials"] = @materials if @materials
    recipe["switch_id"] = @switch_id if @switch_id
    $game_variables[@var_id] << recipe
    @target = nil
    @materials = nil
    @switch_id = nil
  end

  def create(kind, id, number)
    @target = { "kind" => kind, "id" => id, "number" => number }
  end

  def switch(switch_id)
    @switch_id = switch_id
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

  def craft(recipe, quantity)
    recipe["materials"].each do |material|
      case material["kind"]
      when :item
        $game_party.lose_item(material["id"], material["number"] * quantity)
      when :weapon
        $game_party.lose_weapon(material["id"], material["number"] * quantity)
      when :armor
        $game_party.lose_armor(material["id"], material["number"] * quantity)
      end
    end
    case recipe["target"]["kind"]
    when :item
      $game_party.gain_item(recipe["target"]["id"], recipe["target"]["number"] * quantity)
    when :weapon
      $game_party.gain_weapon(recipe["target"]["id"], recipe["target"]["number"] * quantity)
    when :armor
      $game_party.gain_armor(recipe["target"]["id"], recipe["target"]["number"] * quantity)
    end
  end
end
