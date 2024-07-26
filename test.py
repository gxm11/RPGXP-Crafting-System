import pyautogui
import pydirectinput
from test_config import input_sequence
import os
import tqdm
import time

workspace = r"D:\work\20240726-aider"
pyautogui.PAUSE = 1
pydirectinput.PAUSE = 0.1

width, height = pyautogui.size()
game_width, game_height = 640, 480 + 48
shot_area = (width // 2 - game_width // 2, height // 2 - game_height // 2 - 24, game_width, game_height)

index = 0
def capture(filename=None):
    if filename is None:
        global index
        index += 1
        filename = f"{index:03d}"

    pyautogui.screenshot(f"{workspace}/screenshot/{filename}.png", shot_area)

# 启动 Game.exe
pyautogui.hotkey('win', 'r')
pyautogui.typewrite(f"{workspace}/Game.exe debug")
pyautogui.press('enter')

print("auto test start.")

# 切换输入法（可选）
pyautogui.press('shift')

# 游戏中
if os.path.exists("error.log"):
    os.remove("error.log")

scene = 'shop'
for key in tqdm.tqdm(input_sequence(scene), desc=scene):
    if os.path.exists("error.log"):
        print("error detected, exit.")
        break

    if key == 'capture':
        capture()
    elif key == 'wait':
        time.sleep(1)
    else:
        pydirectinput.press(key)

print("auto test done.")
capture("latest")
pyautogui.hotkey('alt', 'f4')