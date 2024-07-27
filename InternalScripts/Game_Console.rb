#--------------------------------------------------------------------------
# 只在 debug 模式下打开控制台
#--------------------------------------------------------------------------
if $DEBUG

  Win32API.new('Kernel32', 'AllocConsole', '', 'L').call
  system 'CHCP 65001 > NUL'
  STDOUT.reopen "CONOUT$"
  STDIN.reopen "CONIN$"
  # 使用 UTF-8 编码
  STDOUT.puts '* 欢迎使用 Project1 控制台程序 *'
  # 游戏窗口置顶  
  hwnd = Win32API.new('user32','GetActiveWindow','v','l').call
  Win32API.new("user32","SetForegroundWindow",'l','l').call(hwnd)
end

module Kernel
def p(*args)
  return if !$DEBUG
  args.each do |a|
    a = a.inspect if !a.is_a? String
    t = Time.now.strftime("%H:%M:%S")
    STDOUT.puts("[#{t}]: #{a}")
  end
end
end
