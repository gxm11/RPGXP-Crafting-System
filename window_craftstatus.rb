# window_craftstatus.rb
class Window_CraftStatus < Window_Base
  # 初始化对像
  def initialize
    super(320, 128, 272, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @recipe = nil
    refresh
  end

  # 设置配方
  def recipe=(recipe)
    if @recipe != recipe
      @recipe = recipe
      refresh
    end
  end

  # 刷新
  def refresh
    self.contents.clear
    if @recipe == nil
      return
    end
    case @recipe["target"]["kind"]
    when :item
      item = $data_items[@recipe["target"]["id"]]
    when :weapon
      item = $data_weapons[@recipe["target"]["id"]]
    when :armor
      item = $data_armors[@recipe["target"]["id"]]
    end
    self.contents.font.color = system_color
    self.contents.draw_text(4, 0, 200, 32, "合成物品")
    self.contents.font.color = normal_color
    self.contents.draw_text(204, 0, 32, 32, item.name)
    y = 32
    @recipe["materials"].each do |material|
      case material["kind"]
      when :item
        mat_item = $data_items[material["id"]]
      when :weapon
        mat_item = $data_weapons[material["id"]]
      when :armor
        mat_item = $data_armors[material["id"]]
      end
      self.contents.font.color = normal_color
      self.contents.draw_text(4, y, 200, 32, mat_item.name)
      self.contents.draw_text(204, y, 32, 32, material["number"].to_s, 2)
      y += 32
    end
  end
end
