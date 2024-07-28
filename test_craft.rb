# 在进入地图的瞬间，执行的自动事件。
# 在此处亦可进入新的场景。
load "scene_craft.rb"
load "window_craftcommand.rb"
load "window_craftlist.rb"
load "window_craftnumber.rb"
load "window_craftstatus.rb"

$game_craft = Game_Craft.new
$game_craft.add_recipe({
  "target" => { "kind" => :item, "id" => 1, "number" => 2 },
  "materials" => [
    { "kind" => :item, "id" => 2, "number" => 10 },
    { "kind" => :item, "id" => 3, "number" => 5 }
  ]
})
$game_craft.add_recipe({
  "target" => { "kind" => :weapon, "id" => 2, "number" => 1 },
  "materials" => [
    { "kind" => :item, "id" => 2, "number" => 20 },
    { "kind" => :weapon, "id" => 3, "number" => 10 }
  ]
})
$game_craft.add_recipe({
  "target" => { "kind" => :armor, "id" => 2, "number" => 1 },
  "materials" => [
    { "kind" => :item, "id" => 2, "number" => 20 },
    { "kind" => :armor, "id" => 3, "number" => 10 }
  ]
})

class Interpreter
  def init_test
    return unless $DEBUG

    # 进入合成场景
    $scene = Scene_Craft.new
  end
end
