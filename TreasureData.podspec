Pod::Spec.new do |s|
  s.name         = "TreasureData"
  s.version      = "0.1.0"
  s.license      = { :type => 'Apache 2.0', :text => '
                     Licensed under the Apache License, Version 2.0 (the "License");
                     you may not use this file except in compliance with the License.
                     You may obtain a copy of the License at

                         http://www.apache.org/licenses/LICENSE-2.0

                     Unless required by applicable law or agreed to in writing, software
                     distributed under the License is distributed on an "AS IS" BASIS,
                     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
                     See the License for the specific language governing permissions and
                     limitations under the License.' }
  s.summary      = "Objective-C Client Library for Treasure Data."
  s.homepage     = "https://github.com/yonekawa/td-client-objc"
  s.authors      = { "Kenichi Yonekawa" => "tcgrim@gmail.com" }
  s.source       = { :git => "https://github.com/yonekawa/td-client-objc.git",
                     :tag => "0.1.0" }
  s.source_files = 'TreasureData/**/*.{h,m}'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.dependency 'AFNetworking',  '2.1.0'
  s.dependency 'Mantle',        '1.3.1'
  s.dependency 'ReactiveCocoa', '2.2.3'
end
