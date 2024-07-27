# scene_craft.rb
class Scene_Craft
  # 主处理
  def main
    # 生成帮助窗口
    @help_window = Window_Help.new
    # 生成指令窗口
    @command_window = Window_CraftCommand.new
    # 生成合成列表窗口
    @craft_list_window = Window_CraftList.new
    @craft_list_window.active = false
    @craft_list_window.visible = false
    # 生成合成状态窗口
    @craft_status_window = Window_CraftStatus.new
    @craft_status_window.visible = false
    # 生成数量输入窗口
    @number_window = Window_CraftNumber.new
    @number_window.active = false
    @number_window.visible = false
    # 执行过渡
    Graphics.transition
    # 主循环
    loop do
      # 刷新游戏画面
      Graphics.update
      # 刷新输入信息
      Input.update
      # 刷新画面
      update
      # 如果画面切换的话就中断循环
      if $scene != self
        break
      end
    end
    # 准备过渡
    Graphics.freeze
    # 释放窗口
    @help_window.dispose
    @command_window.dispose
    @craft_list_window.dispose
    @craft_status_window.dispose
    @number_window.dispose
  end

  # 刷新画面
  def update
    # 刷新窗口
    @help_window.update
    @command_window.update
    @craft_list_window.update
    @craft_status_window.update
    @number_window.update
    # 指令窗口激活的情况下: 调用 update_command
    if @command_window.active
      update_command
      return
    end
    # 合成列表窗口激活的情况下: 调用 update_craft_list
    if @craft_list_window.active
      update_craft_list
      return
    end
    # 个数输入窗口激活的情况下: 调用 update_number
    if @number_window.active
      update_number
      return
    end
  end

  # 刷新画面 (指令窗口激活的情况下)
  def update_command
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 切换到主菜单
      $scene = Scene_Map.new
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 命令窗口光标位置分支
      case @command_window.index
      when 0  # 物品
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 窗口状态转向物品合成模式
        @command_window.active = false
        @craft_list_window.set_recipes($craft_recipes.select { |recipe| recipe["target"]["kind"] == :item })
        @craft_list_window.active = true
        @craft_list_window.visible = true
        @craft_status_window.visible = true
      when 1  # 装备
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 窗口状态转向装备合成模式
        @command_window.active = false
        @craft_list_window.set_recipes($craft_recipes.select { |recipe| recipe["target"]["kind"] == :weapon || recipe["target"]["kind"] == :armor })
        @craft_list_window.active = true
        @craft_list_window.visible = true
        @craft_status_window.visible = true
      when 2  # 取消
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 切换到主菜单
        $scene = Scene_Map.new
      end
      return
    end
  end

  # 刷新画面 (合成列表窗口激活的情况下)
  def update_craft_list
    # 设置状态窗口的物品
    @craft_status_window.recipe = @craft_list_window.recipe
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 窗口状态转向初期模式
      @command_window.active = true
      @craft_list_window.active = false
      @craft_list_window.visible = false
      @craft_status_window.visible = false
      @craft_status_window.recipe = nil
      # 删除帮助文本
      @help_window.set_text("")
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 获取配方
      @recipe = @craft_list_window.recipe
      # 配方无效的情况下
      if @recipe == nil
        # 演奏冻结 SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 演奏确定 SE
      $game_system.se_play($data_system.decision_se)
      # 计算可以最多合成的数量
      max = calculate_max_craft_quantity(@recipe)
      # 窗口状态转向数值输入模式
      @craft_list_window.active = false
      @craft_list_window.visible = false
      @number_window.set(@recipe, max)
      @number_window.active = true
      @number_window.visible = true
    end
  end

  # 刷新画面 (个数输入窗口激活的情况下)
  def update_number
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 设置个数输入窗口为不活动·非可视状态
      @number_window.active = false
      @number_window.visible = false
      # 窗口状态转向合成列表模式
      @craft_list_window.active = true
      @craft_list_window.visible = true
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 演奏商店 SE
      $game_system.se_play($data_system.shop_se)
      # 设置个数输入窗口为不活动·非可视状态
      @number_window.active = false
      @number_window.visible = false
      # 合成处理
      craft_item(@recipe, @number_window.number)
      # 刷新各窗口
      @craft_list_window.refresh
      @craft_status_window.refresh
    end
  end

  # 计算可以最多合成的数量
  def calculate_max_craft_quantity(recipe)
    max_quantities = recipe["materials"].map do |material|
      case material["kind"]
      when :item
        $game_party.item_number(material["id"]) / material["number"]
      when :weapon
        $game_party.weapon_number(material["id"]) / material["number"]
      when :armor
        $game_party.armor_number(material["id"]) / material["number"]
      end
    end
    max_quantities.min
  end

  # 合成物品
  def craft_item(recipe, quantity)
    recipe["materials"].each do |material|
      case material["kind"]
      when :item
        $game_party.lose_item(material["id"], material["number"] * quantity)
      when :weapon
        $game_party.lose_weapon(material["id"], material["number"] * quantity)
      when :armor
        $game_party.lose_armor(material["id"], material["number"] * quantity)
      end
    end
    case recipe["target"]["kind"]
    when :item
      $game_party.gain_item(recipe["target"]["id"], recipe["target"]["number"] * quantity)
    when :weapon
      $game_party.gain_weapon(recipe["target"]["id"], recipe["target"]["number"] * quantity)
    when :armor
      $game_party.gain_armor(recipe["target"]["id"], recipe["target"]["number"] * quantity)
    end
  end
end