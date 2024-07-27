#==============================================================================
# ■ Main
#------------------------------------------------------------------------------
# 　各定义结束后、从这里开始实际处理。
#==============================================================================

begin
  # 准备过渡
  Graphics.freeze
  # 生成场景对像 (标题画面)
  $scene = Scene_Title.new
  # $scene 为有效的情况下调用 main 过程
  while $scene != nil
    $scene.main
  end
  # 淡入淡出
  Graphics.transition(20)
rescue Errno::ENOENT
  # 补充 Errno::ENOENT 以外错误
  # 无法打开文件的情况下、显示信息后结束
  filename = $!.message.sub("No such file or directory - ", "")
  print("找不到文件 #{filename}。 ")
rescue SystemExit
  # nothing happends.
rescue Exception => e
  # by gxm 20240727 捕获所有的错误并写入到 error.log
  msg = ['Error occurs.']
  scripts = load_data("Data/Scripts.rxdata")  
  msg << e.to_s
  msg += e.backtrace.collect { |x|    
    name, line, error = x.split(':', 3)
    name = "RGSS #{scripts[name[7,3].to_i][1]}" if name[0, 7] == "Section"
    "#{name}, line #{line}: #{error}"
  }
  puts msg.join("\n")
  File.open('error.log', 'w') do |f|    
    f << Time.now.strftime("%Y/%m/%d %a %H:%M:%S") << "\n"
    f << msg.join("\n").unpack("U*").pack("U*")
  end
  p "出现了错误，请检查 error.log 文件，并联系作者。"
end
