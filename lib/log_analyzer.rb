# frozen_string_literal: true

require_relative '../lib/parser'

class LogAnalyzer
  attr_reader :log_entries

  def initialize(file_path:)
    parser = Parser.new(file_path:)
    @log_entries = parser.log_entries
  end

  def all_visits
    summarize(
      entries: sort_entries_by(visit_type: :all_visits),
      visit_type: :all_visits,
      message: "visits"
    )
  end

  def unique_visits
    summarize(
      entries: sort_entries_by(visit_type: :unique_visits),
      visit_type: :unique_visits,
      message: "unique visits"
    )
  end

  private

  def summarize(entries:, visit_type:, message:)
    entries.each { |url, visitor_info| puts "#{url} #{visitor_info[visit_type]} #{message}" }
  end

  def sort_entries_by(visit_type:)
    log_entries.sort_by {|url, visitor_info| [-visitor_info[visit_type], url]}.to_h
  end
end
