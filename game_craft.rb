class Game_Craft
  CRAFT_RECIPES = []

  def initialize
    # Initialize method remains empty for now
  end

  def recipes
    CRAFT_RECIPES
  end

  def add_recipe(recipe)
    CRAFT_RECIPES << recipe
    @target = nil
    @materials = nil
  end
end
