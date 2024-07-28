# 在进入地图的瞬间，执行的自动事件。
# 在此处亦可进入新的场景。
load "init_craft.rb"
load "game_craft.rb"
load "scene_craft.rb"
load "window_craftcommand.rb"
load "window_craftlist.rb"
load "window_craftnumber.rb"
load "window_craftstatus.rb"


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
