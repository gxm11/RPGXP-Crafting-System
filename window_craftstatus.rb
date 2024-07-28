# window_craftstatus.rb
class Window_CraftStatus < Window_Base
  # 初始化对像
  def initialize
    super(320, 128, 320, 352)
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
    self.contents.draw_text(4, 0, 200, 32, "创建")
    self.contents.font.color = normal_color
    self.contents.draw_text(4, 32, 200, 32, item.name)
    owned_number = case @recipe["target"]["kind"]
                   when :item
                     $game_party.item_number(@recipe["target"]["id"])
                   when :weapon
                     $game_party.weapon_number(@recipe["target"]["id"])
                   when :armor
                     $game_party.armor_number(@recipe["target"]["id"])
                   end
    self.contents.draw_text(224, 32, 64, 32, "+#{@recipe['target']['number']}/#{owned_number}", 2)
    self.contents.font.color = system_color
    self.contents.draw_text(4, 64, 200, 32, "消耗")
    self.contents.font.color = normal_color
    y = 96
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
      owned_number = case material["kind"]
                     when :item
                       $game_party.item_number(material["id"])
                     when :weapon
                       $game_party.weapon_number(material["id"])
                     when :armor
                       $game_party.armor_number(material["id"])
                     end
      text = "#{owned_number}/#{material["number"]}"
      if owned_number < material["number"]
        self.contents.font.color = crisis_color
      else
        self.contents.font.color = normal_color
      end
      self.contents.draw_text(224, y, 64, 32, text, 2)
      self.contents.font.color = normal_color
      y += 32
    end
  end
end
