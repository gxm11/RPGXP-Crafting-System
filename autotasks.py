data = {'default': []}

# ---------------------------------------------------------
# map 测试
# ---------------------------------------------------------
# 进入Scene_Map
s = data['map'] = []
s += ['enter', 'sleep,0.5']

# ---------------------------------------------------------
# shop 测试
# ---------------------------------------------------------
# 进入Scene_Map
s = data['shop'] = []
s += ['enter']
s += ['capture']
# 与上面的角色对话
s += ['up', 'enter']
# 选择“买”
s += ['enter']
# 购买1个道具
s += ['enter', 'right', 'right', 'enter']
s += ['down', 'enter', 'right', 'enter']
# 离开商店并打开物品窗口
s += ['esc', 'esc', 'esc']
s += ['enter', 'sleep,1']

# ---------------------------------------------------------
# craft 测试
# ---------------------------------------------------------
# 进入Scene_Map
s = data['craft'] = []
s += ['enter', 'sleep,0.5', 'capture']
# 进入Scene_Craft
s += ['sleep,0.5', 'enter', 'sleep,0.5', 'capture']
s += ['enter', 'sleep,0.5', 'capture']
s += ['esc', 'sleep,0.5', 'capture']
# 其他菜单操作
s += ['right', 'sleep,0.5', 'enter', 'sleep,0.5', 'capture', 'esc']
s += ['right', 'sleep,0.5', 'enter']
