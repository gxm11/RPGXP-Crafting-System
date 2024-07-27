# 在进入地图的瞬间，执行的自动事件。
# 在此处亦可进入新的场景。
class Interpreter
  def init_test
    return unless $DEBUG
    $game_party.gain_gold(1000)
  end
end
