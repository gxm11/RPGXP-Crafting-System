#==============================================================================
# ■ Game_Battler (分割定义 2)
#------------------------------------------------------------------------------
# 　处理战斗者的类。这个类作为 Game_Actor 类与 Game_Enemy 类的
# 超级类来使用。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 检查状态
  #     state_id : 状态 ID
  #--------------------------------------------------------------------------
  def state?(state_id)
    # 如果符合被附加的状态的条件就返回 ture
    return @states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # ● 判断状态是否为 full
  #     state_id : 状态 ID
  #--------------------------------------------------------------------------
  def state_full?(state_id)
    # 如果符合被附加的状态的条件就返回 false
    unless self.state?(state_id)
      return false
    end
    # 秩序回合数 -1 (自动状态) 然后返回 true
    if @states_turn[state_id] == -1
      return true
    end
    # 当持续回合数等于自然解除的最低回合数时返回 ture
    return @states_turn[state_id] == $data_states[state_id].hold_turn
  end
  #--------------------------------------------------------------------------
  # ● 附加状态
  #     state_id : 状态 ID
  #     force    : 强制附加标志 (处理自动状态时使用)
  #--------------------------------------------------------------------------
  def add_state(state_id, force = false)
    # 无效状态的情况下
    if $data_states[state_id] == nil
      # 过程结束
      return
    end
    # 无法强制附加的情况下
    unless force
      # 已存在的状态循环
      for i in @states
        # 新的状态和已经存在的状态 (-) 同时包含的情况下、
        # 本状态不包含变化为新状态的状态变化 (-) 
        # (ex : 战斗不能与附加中毒同时存在的场合)
        if $data_states[i].minus_state_set.include?(state_id) and
           not $data_states[state_id].minus_state_set.include?(i)
          # 过程结束
          return
        end
      end
    end
    # 无法附加本状态的情况下
    unless state?(state_id)
      # 状态 ID 追加到 @states 序列中
      @states.push(state_id)
      # 选项 [当作 HP 0 的状态] 有效的情况下
      if $data_states[state_id].zero_hp
        # HP 更改为 0
        @hp = 0
      end
      # 所有状态的循环
      for i in 1...$data_states.size
        # 状态变化 (+) 处理
        if $data_states[state_id].plus_state_set.include?(i)
          add_state(i)
        end
        # 状态变化 (-) 处理
        if $data_states[state_id].minus_state_set.include?(i)
          remove_state(i)
        end
      end
      # 按比例大的排序 (值相等的情况下按照强度排序)
      @states.sort! do |a, b|
        state_a = $data_states[a]
        state_b = $data_states[b]
        if state_a.rating > state_b.rating
          -1
        elsif state_a.rating < state_b.rating
          +1
        elsif state_a.restriction > state_b.restriction
          -1
        elsif state_a.restriction < state_b.restriction
          +1
        else
          a <=> b
        end
      end
    end
    # 强制附加的场合
    if force
      # 设置为自然解除的最低回数 -1 (无效)
      @states_turn[state_id] = -1
    end
    # 不能强制附加的场合
    unless  @states_turn[state_id] == -1
      # 设置为自然解除的最低回数
      @states_turn[state_id] = $data_states[state_id].hold_turn
    end
    # 无法行动的场合
    unless movable?
      # 清除行动
      @current_action.clear
    end
    # 检查 HP 及 SP 的最大值
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ● 解除状态
  #     state_id : 状态 ID
  #     force    : 强制解除标志 (处理自动状态时使用)
  #--------------------------------------------------------------------------
  def remove_state(state_id, force = false)
    # 无法附加本状态的情况下
    if state?(state_id)
      # 被强制附加的状态、并不是强制解除的情况下
      if @states_turn[state_id] == -1 and not force
        # 过程结束
        return
      end
      # 现在的 HP 为 0 当作选项 [当作 HP 0 的状态]有效的场合
      if @hp == 0 and $data_states[state_id].zero_hp
        # 判断是否有另外的 [当作 HP 0 的状态]状态
        zero_hp = false
        for i in @states
          if i != state_id and $data_states[i].zero_hp
            zero_hp = true
          end
        end
        # 如果可以解除战斗不能、将 HP 更改为 1
        if zero_hp == false
          @hp = 1
        end
      end
      # 将状态 ID 从 @states 队列和 @states_turn hash 中删除 
      @states.delete(state_id)
      @states_turn.delete(state_id)
    end
    # 检查 HP 及 SP 的最大值
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ● 获取状态的动画 ID
  #--------------------------------------------------------------------------
  def state_animation_id
    # 一个状态也没被附加的情况下
    if @states.size == 0
      return 0
    end
    # 返回概率最大的状态动画 ID
    return $data_states[@states[0]].animation_id
  end
  #--------------------------------------------------------------------------
  # ● 获取限制
  #--------------------------------------------------------------------------
  def restriction
    restriction_max = 0
    # 从当前附加的状态中获取最大的 restriction 
    for i in @states
      if $data_states[i].restriction >= restriction_max
        restriction_max = $data_states[i].restriction
      end
    end
    return restriction_max
  end
  #--------------------------------------------------------------------------
  # ● 判断状态 [无法获得 EXP]
  #--------------------------------------------------------------------------
  def cant_get_exp?
    for i in @states
      if $data_states[i].cant_get_exp
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 判断状态 [无法回避攻击]
  #--------------------------------------------------------------------------
  def cant_evade?
    for i in @states
      if $data_states[i].cant_evade
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 判断状态 [连续伤害]
  #--------------------------------------------------------------------------
  def slip_damage?
    for i in @states
      if $data_states[i].slip_damage
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 解除战斗用状态 (战斗结束时调用)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for i in @states.clone
      if $data_states[i].battle_only
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 状态自然解除 (回合改变时调用)
  #--------------------------------------------------------------------------
  def remove_states_auto
    for i in @states_turn.keys.clone
      if @states_turn[i] > 0
        @states_turn[i] -= 1
      elsif rand(100) < $data_states[i].auto_release_prob
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 状态攻击解除 (受到物理伤害时调用)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for i in @states.clone
      if rand(100) < $data_states[i].shock_release_prob
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 状态变化 (+) 的适用
  #     plus_state_set  : 状态变化 (+)
  #--------------------------------------------------------------------------
  def states_plus(plus_state_set)
    # 清除有效标志
    effective = false
    # 循环 (附加状态)
    for i in plus_state_set
      # 无法防御本状态的情况下
      unless self.state_guard?(i)
        # 这个状态如果不是 full 的话就设置有效标志
        effective |= self.state_full?(i) == false
        # 状态为 [不能抵抗] 的情况下
        if $data_states[i].nonresistance
          # 设置状态变化标志
          @state_changed = true
          # 附加状态
          add_state(i)
        # 这个状态不是 full 的情况下
        elsif self.state_full?(i) == false
          # 将状态的有效度变换为概率、与随机数比较
          if rand(100) < [0,100,80,60,40,20,0][self.state_ranks[i]]
            # 设置状态变化标志
            @state_changed = true
            # 附加状态
            add_state(i)
          end
        end
      end
    end
    # 过程结束
    return effective
  end
  #--------------------------------------------------------------------------
  # ● 状态变化 (-) 的使用
  #     minus_state_set : 状态变化 (-)
  #--------------------------------------------------------------------------
  def states_minus(minus_state_set)
    # 清除有效标志
    effective = false
    # 循环 (解除状态)
    for i in minus_state_set
      # 如果这个状态被附加则设置有效标志
      effective |= self.state?(i)
      # 设置状态变化标志
      @state_changed = true
      # 解除状态
      remove_state(i)
    end
    # 过程结束
    return effective
  end
end
