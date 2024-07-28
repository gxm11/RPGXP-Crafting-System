
# init_craft.rb

# 使用猴子补丁改写 Game_Party 的 initialize 方法
class Game_Party
  alias init_craft_initialize initialize

  def initialize
    # 调用原始的 initialize 方法
    init_craft_initialize

    # 创建 $game_craft 对象
    $game_craft = Game_Craft.new(100)  # 假设使用变量ID 100来存储合成配方

    # 初始化合成配方
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

    # 添加一个带有开关的配方
    $game_craft.add_recipe do |craft|
      craft.create :item, 3, 1
      craft.consume :item, 1, 2
      craft.switch 1  # 假设开关ID 1
    end
  end
end
