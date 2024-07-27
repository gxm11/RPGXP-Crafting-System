#==============================================================================
# ■ Scene_Battle (分割定义 3)
#------------------------------------------------------------------------------
# 　处理战斗画面的类。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● 开始角色命令回合
  #--------------------------------------------------------------------------
  def start_phase3
    # 转移到回合 3
    @phase = 3
    # 设置角色为非选择状态
    @actor_index = -1
    @active_battler = nil
    # 输入下一个角色的命令
    phase3_next_actor
  end
  #--------------------------------------------------------------------------
  # ● 转到输入下一个角色的命令
  #--------------------------------------------------------------------------
  def phase3_next_actor
    # 循环
    begin
      # 角色的明灭效果 OFF
      if @active_battler != nil
        @active_battler.blink = false
      end
      # 最后的角色的情况
      if @actor_index == $game_party.actors.size-1
        # 开始主回合
        start_phase4
        return
      end
      # 推进角色索引
      @actor_index += 1
      @active_battler = $game_party.actors[@actor_index]
      @active_battler.blink = true
    # 如果角色是在无法接受指令的状态就再试
    end until @active_battler.inputable?
    # 设置角色的命令窗口
    phase3_setup_command_window
  end
  #--------------------------------------------------------------------------
  # ● 转向前一个角色的命令输入
  #--------------------------------------------------------------------------
  def phase3_prior_actor
    # 循环
    begin
      # 角色的明灭效果 OFF
      if @active_battler != nil
        @active_battler.blink = false
      end
      # 最初的角色的情况下
      if @actor_index == 0
        # 开始同伴指令回合
        start_phase2
        return
      end
      # 返回角色索引
      @actor_index -= 1
      @active_battler = $game_party.actors[@actor_index]
      @active_battler.blink = true
    # 如果角色是在无法接受指令的状态就再试
    end until @active_battler.inputable?
    # 设置角色的命令窗口
    phase3_setup_command_window
  end
  #--------------------------------------------------------------------------
  # ● 设置角色指令窗口
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    # 同伴指令窗口无效化
    @party_command_window.active = false
    @party_command_window.visible = false
    # 角色指令窗口无效化
    @actor_command_window.active = true
    @actor_command_window.visible = true
    # 设置角色指令窗口的位置
    @actor_command_window.x = @actor_index * 160
    # 设置索引为 0
    @actor_command_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面 (角色命令回合)
  #--------------------------------------------------------------------------
  def update_phase3
    # 敌人光标有效的情况下
    if @enemy_arrow != nil
      update_phase3_enemy_select
    # 角色光标有效的情况下
    elsif @actor_arrow != nil
      update_phase3_actor_select
    # 特技窗口有效的情况下
    elsif @skill_window != nil
      update_phase3_skill_select
    # 物品窗口有效的情况下
    elsif @item_window != nil
      update_phase3_item_select
    # 角色指令窗口有效的情况下
    elsif @actor_command_window.active
      update_phase3_basic_command
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面 (角色命令回合 : 基本命令)
  #--------------------------------------------------------------------------
  def update_phase3_basic_command
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 转向前一个角色的指令输入
      phase3_prior_actor
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 角色指令窗口光标位置分之
      case @actor_command_window.index
      when 0  # 攻击
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 设置行动
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        # 开始选择敌人
        start_enemy_select
      when 1  # 特技
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 设置行动
        @active_battler.current_action.kind = 1
        # 开始选择特技
        start_skill_select
      when 2  # 防御
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 设置行动
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 1
        # 转向下一位角色的指令输入
        phase3_next_actor
      when 3  # 物品
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 设置行动
        @active_battler.current_action.kind = 2
        # 开始选择物品
        start_item_select
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面 (角色命令回合 : 选择特技)
  #--------------------------------------------------------------------------
  def update_phase3_skill_select
    # 设置特技窗口为可视状态
    @skill_window.visible = true
    # 刷新特技窗口
    @skill_window.update
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 结束特技选择
      end_skill_select
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 获取特技选择窗口现在选择的特技的数据
      @skill = @skill_window.skill
      # 无法使用的情况下
      if @skill == nil or not @active_battler.skill_can_use?(@skill.id)
        # 演奏冻结 SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 演奏确定 SE
      $game_system.se_play($data_system.decision_se)
      # 设置行动
      @active_battler.current_action.skill_id = @skill.id
      # 设置特技窗口为不可见状态
      @skill_window.visible = false
      # 效果范围是敌单体的情况下
      if @skill.scope == 1
        # 开始选择敌人
        start_enemy_select
      # 效果范围是我方单体的情况下
      elsif @skill.scope == 3 or @skill.scope == 5
        # 开始选择角色
        start_actor_select
      # 效果范围不是单体的情况下
      else
        # 选择特技结束
        end_skill_select
        # 转到下一位角色的指令输入
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面 (角色命令回合 : 选择物品)
  #--------------------------------------------------------------------------
  def update_phase3_item_select
    # 设置物品窗口为可视状态
    @item_window.visible = true
    # 刷新物品窗口
    @item_window.update
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 选择物品结束
      end_item_select
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 获取物品窗口现在选择的物品资料
      @item = @item_window.item
      # 无法使用的情况下
      unless $game_party.item_can_use?(@item.id)
        # 演奏冻结 SE
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 演奏确定 SE
      $game_system.se_play($data_system.decision_se)
      # 设置行动
      @active_battler.current_action.item_id = @item.id
      # 设置物品窗口为不可见状态
      @item_window.visible = false
      # 效果范围是敌单体的情况下
      if @item.scope == 1
        # 开始选择敌人
        start_enemy_select
      # 效果范围是我方单体的情况下
      elsif @item.scope == 3 or @item.scope == 5
        # 开始选择角色
        start_actor_select
      # 效果范围不是单体的情况下
      else
        # 物品选择结束
        end_item_select
        # 转到下一位角色的指令输入
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面画面 (角色命令回合 : 选择敌人)
  #--------------------------------------------------------------------------
  def update_phase3_enemy_select
    # 刷新敌人箭头
    @enemy_arrow.update
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 选择敌人结束
      end_enemy_select
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 演奏确定 SE
      $game_system.se_play($data_system.decision_se)
      # 设置行动
      @active_battler.current_action.target_index = @enemy_arrow.index
      # 选择敌人结束
      end_enemy_select
      # 显示特技窗口中的情况下
      if @skill_window != nil
        # 结束特技选择
        end_skill_select
      end
      # 显示物品窗口的情况下
      if @item_window != nil
        # 结束物品选择
        end_item_select
      end
      # 转到下一位角色的指令输入
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面更新 (角色指令回合 : 选择角色)
  #--------------------------------------------------------------------------
  def update_phase3_actor_select
    # 刷新角色箭头
    @actor_arrow.update
    # 按下 B 键的情况下
    if Input.trigger?(Input::B)
      # 演奏取消 SE
      $game_system.se_play($data_system.cancel_se)
      # 选择角色结束
      end_actor_select
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 演奏确定 SE
      $game_system.se_play($data_system.decision_se)
      # 设置行动
      @active_battler.current_action.target_index = @actor_arrow.index
      # 选择角色结束
      end_actor_select
      # 显示特技窗口中的情况下
      if @skill_window != nil
        # 结束特技选择
        end_skill_select
      end
      # 显示物品窗口的情况下
      if @item_window != nil
        # 结束物品选择
        end_item_select
      end
      # 转到下一位角色的指令输入
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 开始选择敌人
  #--------------------------------------------------------------------------
  def start_enemy_select
    # 生成敌人箭头
    @enemy_arrow = Arrow_Enemy.new(@spriteset.viewport1)
    # 关联帮助窗口
    @enemy_arrow.help_window = @help_window
    # 无效化角色指令窗口
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 结束选择敌人
  #--------------------------------------------------------------------------
  def end_enemy_select
    # 释放敌人箭头
    @enemy_arrow.dispose
    @enemy_arrow = nil
    # 指令为 [战斗] 的情况下
    if @actor_command_window.index == 0
      # 有效化角色指令窗口
      @actor_command_window.active = true
      @actor_command_window.visible = true
      # 隐藏帮助窗口
      @help_window.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 开始选择角色
  #--------------------------------------------------------------------------
  def start_actor_select
    # 生成角色箭头
    @actor_arrow = Arrow_Actor.new(@spriteset.viewport2)
    @actor_arrow.index = @actor_index
    # 关联帮助窗口
    @actor_arrow.help_window = @help_window
    # 无效化角色指令窗口
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 结束选择角色
  #--------------------------------------------------------------------------
  def end_actor_select
    # 释放角色箭头
    @actor_arrow.dispose
    @actor_arrow = nil
  end
  #--------------------------------------------------------------------------
  # ● 开始选择特技
  #--------------------------------------------------------------------------
  def start_skill_select
    # 生成特技窗口
    @skill_window = Window_Skill.new(@active_battler)
    # 关联帮助窗口
    @skill_window.help_window = @help_window
    # 无效化角色指令窗口
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 选择特技结束
  #--------------------------------------------------------------------------
  def end_skill_select
    # 释放特技窗口
    @skill_window.dispose
    @skill_window = nil
    # 隐藏帮助窗口
    @help_window.visible = false
    # 有效化角色指令窗口
    @actor_command_window.active = true
    @actor_command_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 开始选择物品
  #--------------------------------------------------------------------------
  def start_item_select
    # 生成物品窗口
    @item_window = Window_Item.new
    # 关联帮助窗口
    @item_window.help_window = @help_window
    # 无效化角色指令窗口
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 结束选择物品
  #--------------------------------------------------------------------------
  def end_item_select
    # 释放物品窗口
    @item_window.dispose
    @item_window = nil
    # 隐藏帮助窗口
    @help_window.visible = false
    # 有效化角色指令窗口
    @actor_command_window.active = true
    @actor_command_window.visible = true
  end
end
