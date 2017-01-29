RULES = [
  {
    # ی between two letters (except ا and و)
    regex: /\u06CC(?=[\u0600-\u06FF&&[^\u0627\u0648]])|\u06CC(?<=[\u0600-\u06FF&&[^\u0627\u0648]]\u06CC)/,
    string: 'ی',
    result: 'i'
  }, {
    string: 'ی',
    position: :final,
    result: 'i'
  }, {
    # و between two letters (except ا, ی) almost always denotes u
    regex: /\u0648(?=[\u0600-\u06FF&&[^\u0627\u06CC]])|\u0648(?<=[\u0600-\u06FF&&[^\u0627\u06CC]]\u0648)/,
    result: 'u'
  }, {
    string: 'و',
    position: :final,
    result: 'u'
  }, {
    string: 'یی',
    result: 'yi'
  }, {
    # final ه, except before ا, ی and و, typically denotes e.
    pre_regex: /[\u0600-\u06FF&&[^\u06CC\u0627\u0648]]/,
    string: 'ه',
    position: :final,
    result: 'e'
  }, {
    string: 'ای',
    position: :initial,
    result: 'i'
  }
]

def convert_to_regex(rule)
  pre_regex = nil
  if rule[:position] == :initial
    pre_regex = /(\b)/
  elsif !rule[:position].nil?
    pre_regex = /([^\b])/
  else
    pre_regex = /()/
  end
  if rule[:pre_regex]
    pre_regex = Regexp.new("(#{pre_regex}#{rule[:pre_regex]})")
  end

  regex = rule[:regex] if !rule[:regex].nil?
  regex = /(#{rule[:string].codepoints.map { |c| '\u%04X' % c}.join})/ if !rule[:string].nil?

  post_regex = nil
  if rule[:position] == :final
    post_regex = /(\b)/
  elsif !rule[:position].nil?
    post_regex = /([^\b])/
  else
    post_regex = /()/
  end
  if rule[:post_regex]
    post_regex = Regexp.new("(#{rule[:post_regex]}#{post_regex})")
  end

  Regexp.new(pre_regex.to_s + regex.to_s + post_regex.to_s)
end

def apply_rules(text)
  RULES.each do |rule|
    text = text.gsub(convert_to_regex(rule), '\1' + rule[:result] + '\3')
  end
  text
end
