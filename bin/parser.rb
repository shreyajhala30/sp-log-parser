# frozen_string_literal: true

require_relative '../lib/log_analyzer'

file_path = ARGV[0]

analyzer = LogAnalyzer.new(file_path:)
puts '--- All Visits ---'
analyzer.all_visits
puts '--- Unique Visits ---'
analyzer.unique_visits
