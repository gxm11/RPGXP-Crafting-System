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
end
