Pod::Spec.new do |s|

  s.name = "SFSafeSymbols"
  s.version = "0.1.1"
  s.summary = "Safely access Apple's SF System Symbols using static typing"

  s.homepage = "https://github.com/piknotech/SFSafeSymbols"
  s.license = { :type => "MIT", :file => "LICENSE.md" }

  s.author = { "Frederick Pietschmann" => "cocoapods@fredpi.de" }
  s.social_media_url = "https://twitter.com/fredcpi"
  
  s.ios.deployment_target = "10.0"

  s.source = { :git => "https://github.com/piknotech/SFSafeSymbols.git", :tag => "#{s.version}" }
  s.source_files = "Sources/SFSafeSymbols/*.swift"
  s.framework = "UIKit"
  s.swift_version = "5.1"
end
