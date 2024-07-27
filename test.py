import pyautogui
import pydirectinput
from test_config import input_sequence
import os
import tqdm
import time
import subprocess
import sys

workspace = os.getcwd()
pyautogui.PAUSE = 1
pydirectinput.PAUSE = 0.1

task = 'default'
if len(sys.argv) >= 2:
    task = sys.argv[1]

game_width, game_height = 640, 480 + 48
width, height = pyautogui.size()
shot_area = (width // 2 - game_width // 2, height // 2 - game_height // 2 - 24, game_width, game_height)

index = 0
def capture(filename=None):
    if filename is None:
        global index
        index += 1
        filename = f"{index:03d}"

    pyautogui.screenshot(f"{workspace}/screenshot/{filename}.png", shot_area)

# 启动 Game.exe
proc = subprocess.Popen(["Game.exe", "debug"], cwd=workspace, stdout=sys.stdout, stderr=sys.stderr)

time.sleep(2)

print("auto test start.")

# 切换输入法（可选）
pyautogui.hotkey('ctrl', 'space')

# 游戏中
if os.path.exists("error.log"):
    os.remove("error.log")

for key in tqdm.tqdm(input_sequence(task), desc=task):
    if os.path.exists("error.log"):
        print("error detected, exit.")
        break
    if proc.poll() is not None:
        break

    if key == 'capture':
        capture()
    elif key == 'wait':
        time.sleep(1)
    else:
        pydirectinput.press(key)

if proc.poll() is None:
    capture("latest")
    proc.terminate()
    proc.wait()
    print("auto test done.")
else:
    print("process terminated.")
