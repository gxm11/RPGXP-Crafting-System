# 合成系统插件使用指南

## 目录
1. [安装插件](#安装插件)
2. [配置插件](#配置插件)
3. [配置地图事件](#配置地图事件)
4. [使用方法](#使用方法)

## 安装插件

1. 将以下文件复制到您的RPG Maker项目目录中：
   - `game_craft.rb`
   - `scene_craft.rb`
   - `window_craftcommand.rb`
   - `window_craftlist.rb`
   - `window_craftnumber.rb`
   - `window_craftstatus.rb`
   - `init_craft.rb`
   - `test_craft.rb`

2. 确保这些文件位于正确的目录结构中，通常是`Scripts`目录下。

## 配置插件

1. **初始化合成系统**：
   - 打开`init_craft.rb`文件，确保`Game_Craft`对象在`Game_Party`初始化时被正确创建。
   - 默认情况下，使用变量ID 1来存储合成配方。

2. **添加合成配方**：
   - 在`init_craft.rb`中，使用`$game_craft.add_recipe`方法添加合成配方。例如：
     ```ruby
     $game_craft.add_recipe do |craft|
       craft.create :item, 1, 3
       craft.consume :item, 2, 1
     end
     ```

3. **配置开关和变量**：
   - 如果需要使用开关来控制某些配方的可用性，可以在配方中添加`switch`方法。例如：
     ```ruby
     $game_craft.add_recipe do |craft|
       craft.create :item, 3, 1
       craft.consume :item, 1, 2
       craft.switch 1  # 假设开关ID 1
     end
     ```

## 配置地图事件

1. **添加测试事件**：
   - 在`test_craft.rb`中，配置一个自动事件，在进入地图时加载合成场景。例如：
     ```ruby
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
     ```

2. **地图事件设置**：
   - 在地图事件中，添加一个脚本事件，调用`$scene = Scene_Craft.new`以加载合成场景。

## 使用方法

1. **进入合成界面**：
   - 在游戏中，通过地图事件或特定条件触发合成场景。

2. **合成物品**：
   - 在合成界面中，选择要合成的物品，并确认所需的材料和数量。
   - 确认后，系统将消耗相应的材料并生成目标物品。

3. **退出合成界面**：
   - 完成合成后，可以通过界面中的返回按钮退出合成界面，返回到游戏主界面。

通过以上步骤，您可以成功安装、配置和使用合成系统插件。如果在使用过程中遇到任何问题，请参考相关脚本文件进行调试和修改。
