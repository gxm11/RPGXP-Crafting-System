# 在进入地图的瞬间，执行的自动事件。
# 在此处亦可进入新的场景。
load "game_craft.rb"
load "scene_craft.rb"
load "window_craftcommand.rb"
load "window_craftlist.rb"
load "window_craftnumber.rb"
load "window_craftstatus.rb"

$game_craft = Game_Craft.new

$game_craft.add_recipe do |craft|
  craft.create :item, 1, 3
  craft.consume :item, 2, 1
end
$game_craft.add_recipe do |craft|
  craft.create :item, 2, 1
  craft.consume :item, 1, 4
end
$game_craft.add_recipe do |craft|
  craft.create :weapon, 2, 1
  craft.consume :weapon, 1, 2
  craft.consume :item, 2, 2
end

class Interpreter
  def init_test
    return unless $DEBUG
    # 添加一些物品和装备，用于合成测试。
    $game_party.gain_item(1, 10)
    $game_party.gain_item(2, 10)
    $game_party.gain_weapon(1, 10)
    $game_party.gain_weapon(2, 10)
    $game_party.gain_armor(1, 10)
    $game_party.gain_armor(2, 10)

    # 进入合成场景
    $scene = Scene_Craft.new
  end
end
