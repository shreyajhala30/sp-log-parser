# frozen_string_literal: true

require_relative '../lib/log_analyzer'

RSpec.describe LogAnalyzer do
  subject(:analyzer) { LogAnalyzer.new(file_path:) }
  let(:file_path) { 'spec/data/server.log' }

  context 'with invalid file path' do
    let(:file_path) { 'invalid_file_path.log' }

    it 'raises error' do
      expect { analyzer }.to raise_error(Parser::Error, 'File Not Found')
    end
  end

  context 'with an empty file' do
    let(:file_path) { 'spec/data/empty_file.log' }

    it 'has empty hash for log entries' do
      expect(analyzer.log_entries).to eq({})
    end
  end

  describe '#all_views' do
    let(:all_visits) { analyzer.all_visits }
    let(:expected_and_sorted_all_visits) do
      {
        '/help_page/1' => {:all_visits=>4, :unique_visits=>3, :visitors=>['126.318.035.038', '929.398.951.889', '722.247.931.582', '929.398.951.889']},
        '/about' => {:all_visits=>2, :unique_visits=>1, :visitors=>['061.945.150.735', '061.945.150.735']},
        '/about/2' => {:all_visits=>1, :unique_visits=>1, :visitors=>['444.701.448.104']}
      }
    end

    it 'returns total number of visits for the url' do
      expect(all_visits).to eq(expected_and_sorted_all_visits)
    end

    context 'with an empty file' do
      let(:file_path) { 'spec/data/empty_file.log' }

      it 'returns empty hash' do
        expect(all_visits).to be_empty
      end
    end
  end

  describe '#unique_visits' do
    let(:unique_visits) { analyzer.unique_visits }
    let(:expected_and_sorted_unique_visits) do
      {
        '/help_page/1' => {:all_visits=>4, :unique_visits=>3, :visitors=>['126.318.035.038', '929.398.951.889', '722.247.931.582', '929.398.951.889']},
        '/about' => {:all_visits=>2, :unique_visits=>1, :visitors=>['061.945.150.735', '061.945.150.735']},
        '/about/2' => {:all_visits=>1, :unique_visits=>1, :visitors=>['444.701.448.104']}
      }
    end

    it 'returns total number of visits for the url' do
      expect(unique_visits).to eq(expected_and_sorted_unique_visits)
    end

    context 'with an empty file' do
      let(:file_path) { 'spec/data/empty_file.log' }

      it 'returns empty hash' do
        expect(unique_visits).to be_empty
      end
    end
  end
end
