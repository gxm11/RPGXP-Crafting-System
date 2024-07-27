#==============================================================================
# ■ Game_Battler (分割定义 3)
#------------------------------------------------------------------------------
# 　处理战斗者的类。这个类作为 Game_Actor 类与 Game_Enemy 类的
# 超级类来使用。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 可以使用特技的判定
  #     skill_id : 特技 ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    # SP 不足的情况下不能使用
    if $data_skills[skill_id].sp_cost > self.sp
      return false
    end
    # 战斗不能的情况下不能使用
    if dead?
      return false
    end
    # 沉默状态的情况下、物理特技以外的特技不能使用
    if $data_skills[skill_id].atk_f == 0 and self.restriction == 1
      return false
    end
    # 获取可以使用的时机
    occasion = $data_skills[skill_id].occasion
    # 战斗中的情况下
    if $game_temp.in_battle
      # [平时] 或者是 [战斗中] 可以使用
      return (occasion == 0 or occasion == 1)
    # 不是战斗中的情况下
    else
      # [平时] 或者是 [菜单中] 可以使用
      return (occasion == 0 or occasion == 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 应用通常攻击效果
  #     attacker : 攻击者 (battler)
  #--------------------------------------------------------------------------
  def attack_effect(attacker)
    # 清除会心一击标志
    self.critical = false
    # 第一命中判定
    hit_result = (rand(100) < attacker.hit)
    # 命中的情况下
    if hit_result == true
      # 计算基本伤害
      atk = [attacker.atk - self.pdef / 2, 0].max
      self.damage = atk * (20 + attacker.str) / 20
      # 属性修正
      self.damage *= elements_correct(attacker.element_set)
      self.damage /= 100
      # 伤害符号正确的情况下
      if self.damage > 0
        # 会心一击修正
        if rand(100) < 4 * attacker.dex / self.agi
          self.damage *= 2
          self.critical = true
        end
        # 防御修正
        if self.guarding?
          self.damage /= 2
        end
      end
      # 分散
      if self.damage.abs > 0
        amp = [self.damage.abs * 15 / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      # 第二命中判定
      eva = 8 * self.agi / attacker.dex + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
    end
    # 命中的情况下
    if hit_result == true
      # 状态冲击解除
      remove_states_shock
      # HP 的伤害计算
      self.hp -= self.damage
      # 状态变化
      @state_changed = false
      states_plus(attacker.plus_state_set)
      states_minus(attacker.minus_state_set)
    # Miss 的情况下
    else
      # 伤害设置为 "Miss"
      self.damage = "Miss"
      # 清除会心一击标志
      self.critical = false
    end
    # 过程结束
    return true
  end
  #--------------------------------------------------------------------------
  # ● 应用特技效果
  #     user  : 特技的使用者 (battler)
  #     skill : 特技
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    # 清除会心一击标志
    self.critical = false
    # 特技的效果范围是 HP 1 以上的己方、自己的 HP 为 0、
    # 或者特技的效果范围是 HP 0 的己方、自己的 HP 为 1 以上的情况下
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      # 过程结束
      return false
    end
    # 清除有效标志
    effective = false
    # 公共事件 ID 是有效的情况下,设置为有效标志
    effective |= skill.common_event_id > 0
    # 第一命中判定
    hit = skill.hit
    if skill.atk_f > 0
      hit *= user.hit / 100
    end
    hit_result = (rand(100) < hit)
    # 不确定的特技的情况下设置为有效标志
    effective |= hit < 100
    # 命中的情况下
    if hit_result == true
      # 计算威力
      power = skill.power + user.atk * skill.atk_f / 100
      if power > 0
        power -= self.pdef * skill.pdef_f / 200
        power -= self.mdef * skill.mdef_f / 200
        power = [power, 0].max
      end
      # 计算倍率
      rate = 20
      rate += (user.str * skill.str_f / 100)
      rate += (user.dex * skill.dex_f / 100)
      rate += (user.agi * skill.agi_f / 100)
      rate += (user.int * skill.int_f / 100)
      # 计算基本伤害
      self.damage = power * rate / 20
      # 属性修正
      self.damage *= elements_correct(skill.element_set)
      self.damage /= 100
      # 伤害符号正确的情况下
      if self.damage > 0
        # 防御修正
        if self.guarding?
          self.damage /= 2
        end
      end
      # 分散
      if skill.variance > 0 and self.damage.abs > 0
        amp = [self.damage.abs * skill.variance / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      # 第二命中判定
      eva = 8 * self.agi / user.dex + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva * skill.eva_f / 100
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
      # 不确定的特技的情况下设置为有效标志
      effective |= hit < 100
    end
    # 命中的情况下
    if hit_result == true
      # 威力 0 以外的物理攻击的情况下
      if skill.power != 0 and skill.atk_f > 0
        # 状态冲击解除
        remove_states_shock
        # 设置有效标志
        effective = true
      end
      # HP 的伤害减法运算
      last_hp = self.hp
      self.hp -= self.damage
      effective |= self.hp != last_hp
      # 状态变化
      @state_changed = false
      effective |= states_plus(skill.plus_state_set)
      effective |= states_minus(skill.minus_state_set)
      # 威力为 0 的场合
      if skill.power == 0
        # 伤害设置为空的字串
        self.damage = ""
        # 状态没有变化的情况下
        unless @state_changed
          # 伤害设置为 "Miss"
          self.damage = "Miss"
        end
      end
    # Miss 的情况下
    else
      # 伤害设置为 "Miss"
      self.damage = "Miss"
    end
    # 不在战斗中的情况下
    unless $game_temp.in_battle
      # 伤害设置为 nil
      self.damage = nil
    end
    # 过程结束
    return effective
  end
  #--------------------------------------------------------------------------
  # ● 应用物品效果
  #     item : 物品
  #--------------------------------------------------------------------------
  def item_effect(item)
    # 清除会心一击标志
    self.critical = false
    # 物品的效果范围是 HP 1 以上的己方、自己的 HP 为 0、
    # 或者物品的效果范围是 HP 0 的己方、自己的 HP 为 1 以上的情况下
    if ((item.scope == 3 or item.scope == 4) and self.hp == 0) or
       ((item.scope == 5 or item.scope == 6) and self.hp >= 1)
      # 过程结束
      return false
    end
    # 清除有效标志
    effective = false
    # 公共事件 ID 是有效的情况下,设置为有效标志
    effective |= item.common_event_id > 0
    # 命中判定
    hit_result = (rand(100) < item.hit)
    # 不确定的特技的情况下设置为有效标志
    effective |= item.hit < 100
    # 命中的情况
    if hit_result == true
      # 计算回复量
      recover_hp = maxhp * item.recover_hp_rate / 100 + item.recover_hp
      recover_sp = maxsp * item.recover_sp_rate / 100 + item.recover_sp
      if recover_hp < 0
        recover_hp += self.pdef * item.pdef_f / 20
        recover_hp += self.mdef * item.mdef_f / 20
        recover_hp = [recover_hp, 0].min
      end
      # 属性修正
      recover_hp *= elements_correct(item.element_set)
      recover_hp /= 100
      recover_sp *= elements_correct(item.element_set)
      recover_sp /= 100
      # 分散
      if item.variance > 0 and recover_hp.abs > 0
        amp = [recover_hp.abs * item.variance / 100, 1].max
        recover_hp += rand(amp+1) + rand(amp+1) - amp
      end
      if item.variance > 0 and recover_sp.abs > 0
        amp = [recover_sp.abs * item.variance / 100, 1].max
        recover_sp += rand(amp+1) + rand(amp+1) - amp
      end
      # 回复量符号为负的情况下
      if recover_hp < 0
        # 防御修正
        if self.guarding?
          recover_hp /= 2
        end
      end
      # HP 回复量符号的反转、设置伤害值
      self.damage = -recover_hp
      # HP 以及 SP 的回复
      last_hp = self.hp
      last_sp = self.sp
      self.hp += recover_hp
      self.sp += recover_sp
      effective |= self.hp != last_hp
      effective |= self.sp != last_sp
      # 状态变化
      @state_changed = false
      effective |= states_plus(item.plus_state_set)
      effective |= states_minus(item.minus_state_set)
      # 能力上升值有效的情况下
      if item.parameter_type > 0 and item.parameter_points != 0
        # 能力值的分支
        case item.parameter_type
        when 1  # MaxHP
          @maxhp_plus += item.parameter_points
        when 2  # MaxSP
          @maxsp_plus += item.parameter_points
        when 3  # 力量
          @str_plus += item.parameter_points
        when 4  # 灵巧
          @dex_plus += item.parameter_points
        when 5  # 速度
          @agi_plus += item.parameter_points
        when 6  # 魔力
          @int_plus += item.parameter_points
        end
        # 设置有效标志
        effective = true
      end
      # HP 回复率与回复量为 0 的情况下
      if item.recover_hp_rate == 0 and item.recover_hp == 0
        # 设置伤害为空的字符串
        self.damage = ""
        # SP 回复率与回复量为 0、能力上升值无效的情况下
        if item.recover_sp_rate == 0 and item.recover_sp == 0 and
           (item.parameter_type == 0 or item.parameter_points == 0)
          # 状态没有变化的情况下
          unless @state_changed
            # 伤害设置为 "Miss"
            self.damage = "Miss"
          end
        end
      end
    # Miss 的情况下
    else
      # 伤害设置为 "Miss"
      self.damage = "Miss"
    end
    # 不在战斗中的情况下
    unless $game_temp.in_battle
      # 伤害设置为 nil
      self.damage = nil
    end
    # 过程结束
    return effective
  end
  #--------------------------------------------------------------------------
  # ● 应用连续伤害效果
  #--------------------------------------------------------------------------
  def slip_damage_effect
    # 设置伤害
    self.damage = self.maxhp / 10
    # 分散
    if self.damage.abs > 0
      amp = [self.damage.abs * 15 / 100, 1].max
      self.damage += rand(amp+1) + rand(amp+1) - amp
    end
    # HP 的伤害减法运算
    self.hp -= self.damage
    # 过程结束
    return true
  end
  #--------------------------------------------------------------------------
  # ● 属性修正计算
  #     element_set : 属性
  #--------------------------------------------------------------------------
  def elements_correct(element_set)
    # 无属性的情况
    if element_set == []
      # 返回 100
      return 100
    end
    # 在被赋予的属性中返回最弱的
    # ※过程 element_rate 是、本类以及继承的 Game_Actor
    #   和 Game_Enemy 类的定义
    weakest = -100
    for i in element_set
      weakest = [weakest, self.element_rate(i)].max
    end
    return weakest
  end
end
