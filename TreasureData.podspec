Pod::Spec.new do |s|
  s.name         = "TreasureData"
  s.version      = "0.1.0"
  s.summary      = "Objective-C Client Library for Treasure Data."
  s.homepage     = "https://github.com/yonekawa/td-client-objc"
  s.license      = "MIT"
  s.author       = { "Kenichi Yonekawa" => "tcgrim@gmail.com" }
  s.source       = { :git => "https://github.com/yonekawa/td-client-objc.git" }
  s.source_files = 'TreasureData/**/*.{h,m}'
  s.requires_arc = true

  s.dependency 'AFNetworking',  '2.1.0'
  s.dependency 'Mantle',        '1.3.1'
  s.dependency 'ReactiveCocoa', '2.2.3'
end
