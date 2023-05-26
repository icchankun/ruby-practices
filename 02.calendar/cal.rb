#!/usr/bin/env ruby

# ライブラリの読み込み。
require 'date'
require 'optparse'

# OptionParserオブジェクトoptを作成。
opt = OptionParser.new

# 現在の年月を変数に代入。
today = Date.today
year = today.year
month = today.mon

# 年月を指定するオプションを定義。
opt.on('-y VAL') {|v| year = v.to_i }
opt.on('-m VAL') {|v| month = v.to_i }
opt.parse!(ARGV)


# 一日と最終日のオブジェクトを作成。
first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

# カレンダーの年月と曜日を表示。
puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"

# 一日の曜日を確認し、それに合わせてインデントを調整。
INITIAL_INDENT = 2
ADDITIONAL_INDENT = 3
add_count = first_date.strftime(format = "%w").to_i

indent = INITIAL_INDENT + ADDITIONAL_INDENT * add_count

# 今日が一日である場合、1の文字色と背景色を反転。
day = 1
if first_date == today
  day = "\e[7m#{day}\e[0m"
  indent += day.size - 1
end

# 一日が土曜日の場合に改行を追加。
if first_date.saturday?
  puts "#{day}".rjust(indent)
else
  print "#{day}".rjust(indent)
  print "".rjust(1)
end

# 二日から最終日までをeachメソッドによって、表示。
(2..last_date.day).each do |day|
  date = Date.new(year, month, day)

  # 今日の場合、文字色と背景色を反転。
  if date == today
    print "".rjust(1) if day < 2
    day = "\e[7m#{day}\e[0m"
  end
  
  if date.saturday?
    puts "#{day}".rjust(2)
  else
    print "#{day}".rjust(2)
    print "".rjust(1)
  end
end

# カレンダーの最後の行とプロンプトの間に一行空きを作成。
puts last_date.saturday? ? "\n" : "\n "