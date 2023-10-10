# frozen_string_literal: true

require 'optparse'

def exec
  opt = OptionParser.new
  params = { number_of_lines: false, number_of_words: false, bytesize: false }
  opt.on('-l') { |v| params[:number_of_lines] = v }
  opt.on('-w') { |v| params[:number_of_words] = v }
  opt.on('-c') { |v| params[:bytesize] = v }
  opt.parse!(ARGV)
  params.transform_values!(&:!) unless params.values.any?

  ARGV.empty? ? wc_stdin(params) : wc_files(params)
end

def wc_stdin(params)
  lines = ARGF.to_a
  stat = build_stat(params, lines)
  print_format(stat)
end

def wc_files(params, paths: ARGV)
  path_stats =
    paths.map do |path|
      file = File.read(path)
      lines = file.lines
      build_stat(params, lines, path:)
    end

  path_stats.each { |stat| print_format(stat) }

  return if path_stats.size <= 1

  total = build_total(params, path_stats)
  print_total(total)
end

def build_stat(params, lines, path: nil)
  number_of_lines = lines.size
  words = lines.join.split(/\s+/)
  number_of_words = words.size
  bytesize = lines.map(&:bytesize).sum

  stat = {}
  stat[:number_of_lines] = number_of_lines if params[:number_of_lines]
  stat[:number_of_words] = number_of_words if params[:number_of_words]
  stat[:bytesize] = bytesize if params[:bytesize]
  stat[:path] = path
  stat
end

def build_total(params, path_stats)
  total_lines =     path_stats.map { |stat| stat[:number_of_lines] }.sum if params[:number_of_lines]
  total_words =     path_stats.map { |stat| stat[:number_of_words] }.sum if params[:number_of_words]
  total_bytesizes = path_stats.map { |stat| stat[:bytesize] }.sum        if params[:bytesize]

  [total_lines, total_words, total_bytesizes].compact
end

SPACE = 7

def print_format(stat)
  print ' '
  puts stat.values.map { |v| v.to_s.rjust(SPACE) }.join(' ')
end

def print_total(total)
  print ' '
  print total.map { |v| v.to_s.rjust(SPACE) }.join(' ')
  puts ' total'
end

exec