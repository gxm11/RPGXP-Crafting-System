import pyautogui
import pydirectinput

workspace = r"D:\work\20240726-aider"
pyautogui.PAUSE = 1
pydirectinput.PAUSE = 0.2

# 启动 Game.exe
pyautogui.hotkey('win', 'r')
pyautogui.typewrite(f"{workspace}/Game.exe debug")
pyautogui.press('enter')

print("auto test start.")

pyautogui.press('shift')

# 游戏中
press = pydirectinput.press

# 进入Scene_Map
press('enter')
# 与上面的角色对话
press('up')
press('enter')
# 购买1个道具
press('enter')

press('enter')
press('right')
press('right')
press('enter')

press('down')
press('enter')
press('right')
press('enter')

# 截图
width, height = pyautogui.size()
game_width, game_height = 640, 480 + 48
shot_area = (width // 2 - game_width // 2, height // 2 - game_height // 2 - 24, game_width, game_height)
pyautogui.screenshot(f"{workspace}/screenshot.png", shot_area)

print("auto test done.")

pyautogui.hotkey('alt', 'f4')