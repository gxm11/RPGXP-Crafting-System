import autotasks

import pyautogui
import pydirectinput
import os
import tqdm
import time
import subprocess
import sys

pyautogui.PAUSE = 1
pydirectinput.PAUSE = 0.1
workspace = os.getcwd()
task = 'default'
if len(sys.argv) >= 2:
    task = sys.argv[1]

print("pydirectinput.pause:", pydirectinput.PAUSE)
print("workspace:", workspace)
print("task:", task)

# 截图相关
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
env = os.environ.copy()
env["AUTOTASK"] = task
proc = subprocess.Popen(["Game.exe", "debug"], cwd=workspace, stdout=sys.stdout, stderr=sys.stderr, env=env)

time.sleep(2)

# 切换输入法（可选）
pyautogui.hotkey('ctrl', 'space')

# 游戏中
if os.path.exists("error.log"):
    with open("error.log", "w") as f:
        pass

if task in autotasks.data:
    for cmd in tqdm.tqdm(autotasks.data[task], desc=task):
        if proc.poll() is not None:
            break

        if cmd == 'capture':
            capture()
            continue
        if cmd.startswith('sleep,'):
            wait_time = float(cmd.split(',')[1])
            time.sleep(wait_time)
            continue

        key = cmd
        pydirectinput.press(key)

# 结束
if proc.poll() is None:
    capture("latest")
    proc.terminate()
    proc.wait()
else:
    print("process terminated.")
