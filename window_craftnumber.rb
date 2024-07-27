# window_craftnumber.rb
class Window_CraftNumber < Window_Base
  # 初始化对像
  def initialize
    super((640 - 300) / 2, (480 - 100) / 2, 300, 100)
    self.back_opacity = 255
    self.contents = Bitmap.new(width - 32, height - 32)
    @recipe = nil
    @max = 1
    @number = 1
  end

  # 设置配方、最大个数
  def set(recipe, max)
    @recipe = recipe
    @max = max
    @number = 1
    refresh
  end

  # 被输入的件数设置
  def number
    return @number
  end

  # 刷新
  def refresh
    self.contents.clear
    case @recipe["target"]["kind"]
    when :item
      item = $data_items[@recipe["target"]["id"]]
    when :weapon
      item = $data_weapons[@recipe["target"]["id"]]
    when :armor
      item = $data_armors[@recipe["target"]["id"]]
    end
    draw_item_name(item, 4, 16)
    self.contents.font.color = normal_color
    self.contents.draw_text(240, 16, 32, 32, "×")
    self.contents.draw_text(276, 16, 24, 32, @number.to_s, 2)
    self.cursor_rect.set(272, 16, 32, 32)
  end

  # 刷新画面
  def update
    super
    if self.active
      # 光标右 (+1)
      if Input.repeat?(Input::RIGHT) and @number < @max
        $game_system.se_play($data_system.cursor_se)
        @number += 1
        refresh
      end
      # 光标左 (-1)
      if Input.repeat?(Input::LEFT) and @number > 1
        $game_system.se_play($data_system.cursor_se)
        @number -= 1
        refresh
      end
      # 光标上 (+10)
      if Input.repeat?(Input::UP) and @number < @max
        $game_system.se_play($data_system.cursor_se)
        @number = [@number + 10, @max].min
        refresh
      end
      # 光标下 (-10)
      if Input.repeat?(Input::DOWN) and @number > 1
        $game_system.se_play($data_system.cursor_se)
        @number = [@number - 10, 1].max
        refresh
      end
    end
  end
end
