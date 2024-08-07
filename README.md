# RPG Maker XP 合成系统

## 项目概述

本项目是为RPG Maker XP游戏开发的一个合成系统。该系统允许玩家在游戏中合成物品和装备，从而增强游戏体验。合成系统包括多个组件，如场景、窗口和游戏逻辑，它们协同工作以实现合成功能。

## 项目演示

[演示视频](https://github.com/gxm11/RPGXP-Crafting-System/releases/download/v1.0/bandicam.2024-07-28.17-14-58-924.mp4)

## 项目结构

项目主要由以下几个部分组成：

1. **场景 (Scene)**:
   - `scene_craft.rb`: 合成场景，负责合成界面的显示和交互。

2. **窗口 (Window)**:
   - `window_craftcommand.rb`: 合成指令窗口，显示合成选项。
   - `window_craftlist.rb`: 合成列表窗口，显示可合成的物品列表。
   - `window_craftnumber.rb`: 合成数量窗口，允许玩家选择合成数量。
   - `window_craftstatus.rb`: 合成状态窗口，显示当前合成物品的详细信息。

3. **游戏逻辑 (Game Logic)**:
   - `game_craft.rb`: 合成系统的核心逻辑，处理合成操作。
   - `init_craft.rb`: 初始化合成系统，确保合成数据正确加载。

4. **测试 (Test)**:
   - `test.py`: 用于测试合成系统的脚本。

## aider 在项目中的作用

aider 是一个强大的AI辅助编程工具，在本项目中发挥了重要作用：

- **代码生成**: aider 帮助生成了合成系统的初始代码框架，包括场景、窗口和游戏逻辑的实现。
- **功能扩展**: 在项目开发过程中，aider 协助添加了新的合成功能和优化了现有代码。
- **问题解决**: 当遇到技术难题或需要优化代码时，aider 提供了有效的解决方案和建议。

通过aider的辅助，本项目的开发效率得到了显著提升，同时也确保了代码的高质量和可维护性。

## 使用说明

1. **安装RPG Maker XP**: 确保你已经安装了RPG Maker XP游戏开发工具。
2. **导入项目**: 将本项目导入到RPG Maker XP中。
3. **运行游戏**: 启动游戏，进入合成场景，体验合成系统的功能。

更多详细的使用说明，请参见[craft.md](craft.md)。

## 贡献

欢迎任何形式的贡献，包括但不限于代码优化、功能扩展和文档改进。请提交Pull Request或Issue，我们将及时处理。

## 许可证

本项目采用MIT许可证，详情请参见[LICENSE](LICENSE)文件。
