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
s += ['sleep,0.5', 'capture']
# 合成6个小回复剂
s += ['enter', 'enter', 'right', 'right', 'capture', 'enter', 'capture']
# 合成1个回复药剂
s += ['down', 'enter', 'capture', 'enter', 'capture']
# 离开物品合成
s += ['esc']
# 前往装备合成
s += ['right', 'enter', 'capture']
# 离开装备合成
s += 'esc right enter'.split()
# 与左边的角色进行对话
s += 'left enter down enter sleep,0.5 enter'.split()
s += 'left enter sleep,0.5 enter sleep,0.5'.split()
s += 'enter sleep,0.5 down down sleep,0.5 enter sleep,0.5 esc'.split()