# window_craftlist.rb
class Window_CraftList < Window_Selectable
  # 初始化对像
  def initialize
    super(0, 128, 320, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    @recipes = []
    refresh
    self.index = 0
  end

  # 设置配方
  def set_recipes(recipes)
    @recipes = recipes
    refresh
  end

  # 获取配方
  def recipe
    return @recipes[self.index]
  end

  # 刷新
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @item_max = @recipes.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end

  # 描绘项目
  def draw_item(index)
    recipe = @recipes[index]
    case recipe["target"]["kind"]
    when :item
      item = $data_items[recipe["target"]["id"]]
    when :weapon
      item = $data_weapons[recipe["target"]["id"]]
    when :armor
      item = $data_armors[recipe["target"]["id"]]
    end
    x = 4
    y = index * 32
    rect = Rect.new(x, y, self.width - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24))
    self.contents.draw_text(x + 28, y, 180, 32, item.name)
    self.contents.draw_text(x + 208, y, 32, 32, recipe["target"]["number"].to_s, 2)
  end

  # 刷新帮助文本
  def update_help
    @help_window.set_text(self.recipe == nil ? "" : self.recipe["target"]["name"])
  end
end
