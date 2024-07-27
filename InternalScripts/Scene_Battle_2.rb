#==============================================================================
# ■ Scene_Battle (分割定义 2)
#------------------------------------------------------------------------------
# 　处理战斗画面的类。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● 开始自由战斗回合
  #--------------------------------------------------------------------------
  def start_phase1
    # 转移到回合 1
    @phase = 1
    # 清除全体同伴的行动
    $game_party.clear_actions
    # 设置战斗事件
    setup_battle_event
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面 (自由战斗回合)
  #--------------------------------------------------------------------------
  def update_phase1
    # 胜败判定
    if judge
      # 胜利或者失败的情况下 : 过程结束
      return
    end
    # 开始同伴命令回合
    start_phase2
  end
  #--------------------------------------------------------------------------
  # ● 开始同伴命令回合
  #--------------------------------------------------------------------------
  def start_phase2
    # 转移到回合 2
    @phase = 2
    # 设置角色为非选择状态
    @actor_index = -1
    @active_battler = nil
    # 有效化同伴指令窗口
    @party_command_window.active = true
    @party_command_window.visible = true
    # 无效化角色指令窗口
    @actor_command_window.active = false
    @actor_command_window.visible = false
    # 清除主回合标志
    $game_temp.battle_main_phase = false
    # 清除全体同伴的行动
    $game_party.clear_actions
    # 不能输入命令的情况下
    unless $game_party.inputable?
      # 开始主回合
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # ● 刷新画面 (同伴命令回合)
  #--------------------------------------------------------------------------
  def update_phase2
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 同伴指令窗口光标位置分支
      case @party_command_window.index
      when 0  # 战斗
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 开始角色的命令回合
        start_phase3
      when 1  # 逃跑
        # 不能逃跑的情况下
        if $game_temp.battle_can_escape == false
          # 演奏冻结 SE
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # 演奏确定 SE
        $game_system.se_play($data_system.decision_se)
        # 逃走处理
        update_phase2_escape
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面更新 (同伴指令回合 : 逃跑)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    # 计算敌人速度的平均值
    enemies_agi = 0
    enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    if enemies_number > 0
      enemies_agi /= enemies_number
    end
    # 计算角色速度的平均值
    actors_agi = 0
    actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    if actors_number > 0
      actors_agi /= actors_number
    end
    # 逃跑成功判定
    success = rand(100) < 50 * actors_agi / enemies_agi
    # 成功逃跑的情况下
    if success
      # 演奏逃跑 SE
      $game_system.se_play($data_system.escape_se)
      # 还原为战斗开始前的 BGM
      $game_system.bgm_play($game_temp.map_bgm)
      # 战斗结束
      battle_end(1)
    # 逃跑失败的情况下
    else
      # 清除全体同伴的行动
      $game_party.clear_actions
      # 开始主回合
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # ● 开始结束战斗回合
  #--------------------------------------------------------------------------
  def start_phase5
    # 转移到回合 5
    @phase = 5
    # 演奏战斗结束 ME
    $game_system.me_play($game_system.battle_end_me)
    # 还原为战斗开始前的 BGM
    $game_system.bgm_play($game_temp.map_bgm)
    # 初始化 EXP、金钱、宝物
    exp = 0
    gold = 0
    treasures = []
    # 循环
    for enemy in $game_troop.enemies
      # 敌人不是隐藏状态的情况下
      unless enemy.hidden
        # 获得 EXP、增加金钱
        exp += enemy.exp
        gold += enemy.gold
        # 出现宝物判定
        if rand(100) < enemy.treasure_prob
          if enemy.item_id > 0
            treasures.push($data_items[enemy.item_id])
          end
          if enemy.weapon_id > 0
            treasures.push($data_weapons[enemy.weapon_id])
          end
          if enemy.armor_id > 0
            treasures.push($data_armors[enemy.armor_id])
          end
        end
      end
    end
    # 限制宝物数为 6 个
    treasures = treasures[0..5]
    # 获得 EXP
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      if actor.cant_get_exp? == false
        last_level = actor.level
        actor.exp += exp
        if actor.level > last_level
          @status_window.level_up(i)
        end
      end
    end
    # 获得金钱
    $game_party.gain_gold(gold)
    # 获得宝物
    for item in treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    # 生成战斗结果窗口
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    # 设置等待计数
    @phase5_wait_count = 100
  end
  #--------------------------------------------------------------------------
  # ● 画面更新 (结束战斗回合)
  #--------------------------------------------------------------------------
  def update_phase5
    # 等待计数大于 0 的情况下
    if @phase5_wait_count > 0
      # 减少等待计数
      @phase5_wait_count -= 1
      # 等待计数为 0 的情况下
      if @phase5_wait_count == 0
        # 显示结果窗口
        @result_window.visible = true
        # 清除主回合标志
        $game_temp.battle_main_phase = false
        # 刷新状态窗口
        @status_window.refresh
      end
      return
    end
    # 按下 C 键的情况下
    if Input.trigger?(Input::C)
      # 战斗结束
      battle_end(0)
    end
  end
end
