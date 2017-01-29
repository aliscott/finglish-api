require 'json'
require 'sinatra/base'
require 'google/cloud/translate'

class App < Sinatra::Base
  FINGLISH_MAPPING = {
    'ا' => 'a',
    'آ' => 'ah',
    'ب' => 'b',
    'پ' => 'p',
    'ت' => 't',
    'ث' => 's',
    'ج' => 'j',
    'چ' => 'ch',
    'ح' => 'h',
    'خ' => 'kh',
    'د' => 'd',
    'ذ' => 'z',
    'ر' => 'r',
    'ز' => 'z',
    'ژ' => 'zj',
    'س' => 's',
    'ش' => 'sh',
    'ص' => 's',
    'ض' => 'z',
    'ط' => 't',
    'ظ' => 'z',
    'ع' => 'ʿ',
    'غ' => 'gh',
    'ف' => 'f',
    'ق' => 'gh',
    'ک' => 'k',
    'گ' => 'g',
    'ل' => 'l',
    'م' => 'm',
    'ن' => 'n',
    'و' => 'v',
    'ه' => 'h',
    'ی' => 'i',
    '؟' => '?'
  }

  GOOGLE_PROJECT_ID = ENV['GOOGLE_PROJECT_ID']
  GOOGLE_API_KEY = ENV['GOOGLE_API_KEY']

  def translate_to_farsi(text)
    translate = Google::Cloud::Translate.new(project: GOOGLE_PROJECT_ID, key: GOOGLE_API_KEY)
    translate.translate(text, to: 'fa').text
  end

  def convert_to_finglish(text)
    text.split('').map { |c| FINGLISH_MAPPING[c] || c }.join('')
  end

  before do
    content_type :json
  end

  after do
    response.body = JSON.dump(response.body)
  end

  get '/translate' do
    puts 'here'
    farsi = translate_to_farsi(params['text'])
    puts 'here2'
    finglish = convert_to_finglish(farsi)
    {
      translation: {
        farsi: farsi,
        finglish: finglish
      }
    }
  end
end
