# frozen_string_literal: true

require_relative '../lib/parser'

RSpec.describe Parser do
  subject(:parser) { Parser.new(file_path:) }

  let(:file_path) { 'spec/data/server.log' }

  context 'validations' do
    context 'with invalid file path' do
      let(:file_path) { 'invalid-file-path' }

      it 'validates the passed file exists' do
        expect { parser }.to raise_error(Parser::Error, 'File Not Found')
      end
    end

    context 'with a non readable file' do
      before { allow(File).to receive(:readable?).with(file_path).and_return(false) }

      it 'validates file is readable' do
        expect { parser }.to raise_error(Parser::Error, 'File Not Readable')
      end
    end
  end

  describe '#log_entries' do
    context 'when the file is empty' do
      let(:file_path) { 'spec/data/empty_file.log' }

      it 'returns an empty hash' do
        expect(parser.log_entries).to eq({})
      end
    end

    context 'when the file contains logs' do
      let(:expected_log_entires) do
        {
          '/about' => { all_visits: 2, unique_visits: 1, visitors: ['061.945.150.735', '061.945.150.735'] },
          '/help_page/1' => { all_visits: 4, unique_visits: 3,
                              visitors: ['126.318.035.038', '929.398.951.889', '722.247.931.582', '929.398.951.889'] },
          '/about/2' => { all_visits: 1, unique_visits: 1, visitors: ['444.701.448.104'] }
        }
      end

      it 'returns hash containing url and its visitors information' do
        expect(parser.log_entries).to eq(expected_log_entires)
      end
    end
  end
end
