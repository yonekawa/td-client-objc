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

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency 'AFNetworking',         '2.1.0'
  s.dependency 'ReactiveCocoa',        '2.2.3'
  s.dependency 'ISO8601DateFormatter', '0.7'
  s.dependency 'Mantle',               '1.3.1'
end
