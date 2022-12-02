# frozen_string_literal: true

class Parser
  class Error < StandardError; end
  attr_reader :file_path

  def initialize(file_path:)
    @file_path = file_path.strip

    raise Error, 'File Not Found' unless File.exist?(file_path)
    raise Error, 'File Not Readable' unless File.readable?(file_path)
  end

  def log_entries
    return {} if File.empty?(file_path)

    generate_log_entries
  end

  private

  def generate_log_entries
    return @log_entries if defined?(@log_entries)

    @log_entries = {}
    file = File.new file_path
    file.each do |line|
      url, ip = line.strip.split(' ', 2)
      @log_entries[url] = (@log_entries[url] || []) << ip
    end
    @log_entries
  rescue StandardError => e
    raise Error, "Unexpected Processing Failure: #{e.message}"
  end
end
