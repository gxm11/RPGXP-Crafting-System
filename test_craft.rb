# 在进入地图的瞬间，执行的自动事件。
# 在此处亦可进入新的场景。
load "game_craft.rb"
load "scene_craft.rb"
load "window_craftcommand.rb"
load "window_craftlist.rb"
load "window_craftnumber.rb"
load "window_craftstatus.rb"

$game_craft = Game_Craft.new
$game_craft.add_recipe do
  create :item, 1, 2
  consume :item, 2, 10
  consume :item, 3, 5
end
$game_craft.add_recipe do
  create :weapon, 2, 1
  consume :item, 2, 20
  consume :weapon, 3, 10
end
$game_craft.add_recipe do
  create :armor, 2, 1
  consume :item, 2, 20
  consume :armor, 3, 10
end

class Interpreter
  def init_test
    return unless $DEBUG

    # 进入合成场景
    $scene = Scene_Craft.new
  end
end
