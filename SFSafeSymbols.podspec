Pod::Spec.new do |spec|
  spec.name = 'SFSafeSymbols'
  spec.version = '2.0.1'
  spec.summary = "Safely access Apple's SF Symbols using static typing"

  spec.homepage = 'https://github.com/piknotech/SFSafeSymbols'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.author = { 'Frederick Pietschmann' => 'cocoapods@fredpi.de' }
  spec.social_media_url = 'https://twitter.com/piknotech'

  spec.static_framework = true
  
  spec.ios.deployment_target = '11.0'
  spec.tvos.deployment_target = '11.0'
  spec.watchos.deployment_target = '6.0'
  spec.macos.deployment_target = '10.13'

  spec.swift_version = '5.3'

  spec.source = { :git => "https://github.com/piknotech/SFSafeSymbols.git", :tag => "#{spec.version}" }
  spec.source_files = 'Sources/**/*'

  spec.weak_framework = 'SwiftUI'
end
