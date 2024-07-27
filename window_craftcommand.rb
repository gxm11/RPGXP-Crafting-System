# window_craftcommand.rb
class Window_CraftCommand < Window_Selectable
  # 初始化对像
  def initialize
    super(0, 64, 640, 64)
    self.contents = Bitmap.new(width - 32, height - 32)
    @item_max = 3
    @column_max = 3
    @commands = ["物品", "装备", "取消"]
    refresh
    self.index = 0
  end

  # 刷新
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end

  # 描绘项目
  def draw_item(index)
    x = (index * 213) + ((213 - self.contents.text_size(@commands[index]).width) / 2)
    self.contents.draw_text(x, 0, 213, 32, @commands[index], 1)
  end
end
