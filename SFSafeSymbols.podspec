Pod::Spec.new do |spec|
  spec.name = 'SFSafeSymbols'
  spec.version = '1.0.1'
  spec.summary = "Safely access Apple's SF Symbols using static typing"

  spec.homepage = 'https://github.com/piknotech/SFSafeSymbols'
  spec.license = { :type => 'MIT', :file => 'LICENSE.md' }

  spec.author = { 'Frederick Pietschmann' => 'cocoapods@fredpi.de' }
  spec.social_media_url = 'https://twitter.com/fredcpi'

  spec.static_framework = true
  
  spec.ios.deployment_target = '11.0'
  spec.tvos.deployment_target = '11.0'
  spec.watchos.deployment_target = '6.0'

  spec.swift_version = '5.1'

  spec.source = { :git => "https://github.com/piknotech/SFSafeSymbols.git", :tag => "#{spec.version}" }
  spec.source_files = 'Sources/**/*'

  spec.frameworks = 'UIKit'
  spec.weak_framework = 'SwiftUI'
end
