seq = {"shop": [], "default": []}

def input_sequence(key = "default"):
    return seq[key]


# ---------------------------------------------------------
# default 测试
# ---------------------------------------------------------
# 进入Scene_Map
s = seq['default']
s += ['enter']
s += ['wait']
# ---------------------------------------------------------
# shop 测试
# ---------------------------------------------------------
# 进入Scene_Map
s = seq['shop']
s += ['enter']
s += ["capture"]
# 与上面的角色对话
s += ['up', 'enter']
# 选择“买”
s += ['enter']
# 购买1个道具
s += ['enter', 'right', 'right', 'enter']
s += ['down', 'enter', 'right', 'enter']
# 离开商店并打开物品窗口
s += ["esc", "esc", "esc"]
s += ["enter"]
s += ["wait"]
