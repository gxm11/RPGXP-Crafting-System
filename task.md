`InternalScripts/Scene_Shop.rb` `InternalScripts/Window_ShopCommand.rb` `InternalScripts/Window_ShopBuy.rb` `InternalScripts/Window_ShopStatus.rb` `InternalScripts/Window_ShopNumber.rb` `InternalScripts/Window_Help.rb` `main.rb` `test_craft.rb` `scene_craft.rb` `window_craftcommand.rb` `window_craftlist.rb` `window_craftstatus.rb` `window_craftnumber.rb`

# RMXP 合成系统

完成一个RMXP的合成系统，通过
```
$scene = Scene_Craft.new
```
打开合成界面，合成界面需要有一个合成列表，列表中显示可以合成的物品，点击合成后，合成物品，并扣除材料。

## 界面设置

相应的界面和操作方式可以参考商店界面（Scene_Shop），除了上方的Window_Help外，中间是Window_CraftCommand，包括“物品”、“装备”和“退出”3个按钮。

- 选择“物品”后，左下方的Window_CraftList显示可以合成的物品列表，当光标在列表中的任意物品上时，右下方的Window_CraftStatus显示该物品的详细信息，包括合成所需的材料、数量和合成后的物品。按下确认键后，显示一个数字窗口Window_CraftNumber，输入本次合成的数量，按下确认键后，合成物品，并扣除材料。

- 选择“装备”后，左下方的Window_CraftList显示可以合成的装备列表，点击后，右下方的Window_CraftStatus显示该装备的详细信息，包括合成所需的材料、数量和合成后的装备。按下确认键后，显示一个数字窗口Window_CraftNumber，输入本次合成的数量，按下确认键后，合成装备，并扣除材料。

- 选择“退出”后，关闭合成界面，返回到主菜单。

## 提示

在test_craft.rb中的Interpreter::init_test函数中，可以初始化合成系统，例如：
```
$scene = Scene_Craft.new
```

同样在此文件中，可以硬编码合成的recipe：
```
$craft_recipes = [
    {"target" => {"kind" => :item, "id" => 1, "number" => 2}, "materials" => [{"kind" => :item, "id" => 2, "number" => 10}, {"kind" => :item, "id" => 3, "number" => 5}]},
    {"target" => {"kind" => :weapon, "id" => 2, "number" => 1}, "materials" => [{"kind" => :item, "id" => 2, "number" => 20}, {"kind" => :weapon, "id" => 3, "number" => 10}]},
    {"target" => {"kind" => :armor, "id" => 2, "number" => 1}, "materials" => [{"kind" => :item, "id" => 2, "number" => 20}, {"kind" => :armor, "id" => 3, "number" => 10}]},
]
```

其中，$craft_recipes是一个数组，每个元素是一个哈希表，表示一个合成配方。哈希表的键包括“target”和“materials”，其中“target”表示合成后的物品，包括“kind”、“id”和“number”三个键，分别表示物品的类型、ID和数量；“materials”表示合成所需的材料，是一个数组，每个元素是一个哈希表，表示一种材料，包括“kind”、“id”和“number”三个键，分别表示材料的类型、ID和数量。材料的类型分为“item”、“weapon”和“armor”三类，分别表示物品、武器和防具。

## 任务需求

请创建并编写scene_craft.rb / window_craftcommand.rb / window_craftlist.rb / window_craftstatus.rb / window_craftnumber.rb，实现场景类Scene_Craft和窗口类Window_CraftCommand、Window_CraftList、Window_CraftStatus、Window_CraftNumber。
