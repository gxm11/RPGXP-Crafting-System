import pyautogui
import pydirectinput

exe_path = r"D:\work\20240726-aider\Game.exe"
pyautogui.PAUSE = 1
pydirectinput.PAUSE = 1

pyautogui.hotkey('win', 'r')
pyautogui.typewrite(exe_path)
pyautogui.press('enter')
pyautogui.press('shift')

# 游戏中
press = pydirectinput.press

press('enter')
