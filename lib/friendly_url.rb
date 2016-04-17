# encoding: utf-8
module FriendlyUrl
  $KCODE = "U" unless RUBY_VERSION > "1.9.0"

  def replace_patterns
    [
      { pattern: /[àáâãäåāă]/,     replace_with: 'a'},
      { pattern: /æ/,              replace_with: 'ae'},
      { pattern: /[ďđ]/,           replace_with: 'd'},
      { pattern: /[çćčĉċ]/,        replace_with: 'c'},
      { pattern: /[èéêëēęěĕė]/,    replace_with: 'e'},
      { pattern: /ƒ/,              replace_with: 'f'},
      { pattern: /[ĝğġģ]/,         replace_with: 'g'},
      { pattern: /[ĥħ]/,           replace_with: 'h'},
      { pattern: /[ììíîïīĩĭ]/,     replace_with: 'i'},
      { pattern: /[įıĳĵ]/,         replace_with: 'j'},
      { pattern: /[ķĸ]/,           replace_with: 'k'},
      { pattern: /[łľĺļŀ]/,        replace_with: 'l'},
      { pattern: /[ñńňņŉŋ]/,       replace_with: 'n'},
      { pattern: /[òóôõöøōőŏŏ]/,   replace_with: 'o'},
      { pattern: /œ/,              replace_with: 'oe'},
      { pattern: /ą/,              replace_with: 'q'},
      { pattern: /[ŕřŗ]/,          replace_with: 'r'},
      { pattern: /[śšşŝș]/,        replace_with: 's'},
      { pattern: /[ťţŧț]/,         replace_with: 't'},
      { pattern: /[ùúûüūůűŭũų]/,   replace_with: 'u'},
      { pattern: /ŵ/,              replace_with: 'w'},
      { pattern: /[ýÿŷ]/,          replace_with: 'y'},
      { pattern: /[žżź]/,          replace_with: 'z'},
      { pattern: /\s+/,            replace_with: '-'},
      { pattern: /[^\sa-z0-9_-]/,  replace_with: ''},
      { pattern: /-{2,}/,          replace_with: '-'},
      { pattern: /^-/,             replace_with: ''},
      { pattern: /-$/,             replace_with: ''}
    ]
  end

  def normalize(str)
    unless str.blank?
      n = str.mb_chars.downcase.to_s.strip
      replace_patterns.each do |rule|
        n.gsub!(rule[:pattern], rule[:replace_with])
      end
      n
    end
  end
end
