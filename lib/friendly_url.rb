# encoding: utf-8
module FriendlyUrl
  $KCODE = "U" unless RUBY_VERSION > "1.9.0"
  def normalize(str)
    unless str.blank?
      n = str.mb_chars.downcase.to_s.strip
      n.gsub!(/[àáâãäåāă]/,     'a')
      n.gsub!(/æ/,              'ae')
      n.gsub!(/[ďđ]/,           'd')
      n.gsub!(/[çćčĉċ]/,        'c')
      n.gsub!(/[èéêëēęěĕė]/,    'e')
      n.gsub!(/ƒ/,              'f')
      n.gsub!(/[ĝğġģ]/,         'g')
      n.gsub!(/[ĥħ]/,           'h')
      n.gsub!(/[ììíîïīĩĭ]/,     'i')
      n.gsub!(/[įıĳĵ]/,         'j')
      n.gsub!(/[ķĸ]/,           'k')
      n.gsub!(/[łľĺļŀ]/,        'l')
      n.gsub!(/[ñńňņŉŋ]/,       'n')
      n.gsub!(/[òóôõöøōőŏŏ]/,   'o')
      n.gsub!(/œ/,              'oe')
      n.gsub!(/ą/,              'q')
      n.gsub!(/[ŕřŗ]/,          'r')
      n.gsub!(/[śšşŝș]/,        's')
      n.gsub!(/[ťţŧț]/,         't')
      n.gsub!(/[ùúûüūůűŭũų]/,   'u')
      n.gsub!(/ŵ/,              'w')
      n.gsub!(/[ýÿŷ]/,          'y')
      n.gsub!(/[žżź]/,          'z')
      n.gsub!(/\s+/,            '-')
      n.gsub!(/[^\sa-zა-ჰ0-9_-]/,  '')
      n.gsub!(/-{2,}/,          '-')
      n.gsub!(/^-/,             '')
      n.gsub!(/-$/,             '')
      n
    end
  end
end
