class Game_Craft
  CRAFT_RECIPES = [
    {
      "target" => { "kind" => :item, "id" => 1, "number" => 2 },
      "materials" => [
        { "kind" => :item, "id" => 2, "number" => 10 },
        { "kind" => :item, "id" => 3, "number" => 5 }
      ]
    },
    {
      "target" => { "kind" => :weapon, "id" => 2, "number" => 1 },
      "materials" => [
        { "kind" => :item, "id" => 2, "number" => 20 },
        { "kind" => :weapon, "id" => 3, "number" => 10 }
      ]
    },
    {
      "target" => { "kind" => :armor, "id" => 2, "number" => 1 },
      "materials" => [
        { "kind" => :item, "id" => 2, "number" => 20 },
        { "kind" => :armor, "id" => 3, "number" => 10 }
      ]
    }
  ]
end
