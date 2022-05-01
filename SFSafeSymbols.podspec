Pod::Spec.new do |spec|
  spec.name = 'SFSafeSymbols'
  spec.version = '3.3.2'
  spec.summary = "Safely access Apple's SF Symbols using static typing"

  spec.homepage = 'https://github.com/SFSafeSymbols/SFSafeSymbols'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.author = { 'Frederick Pietschmann' => 'cocoapods@fredpi.de' }
  spec.social_media_url = 'https://twitter.com/piknotech'
  
  spec.ios.deployment_target = '11.0'
  spec.tvos.deployment_target = '11.0'
  spec.watchos.deployment_target = '4.0'
  spec.macos.deployment_target = '10.13'

  spec.swift_versions = ['5.3', '5.4', '5.5']

  spec.source = { :git => "https://github.com/SFSafeSymbols/SFSafeSymbols.git", :tag => "#{spec.version}" }
  spec.source_files = 'Sources/**/*'

  spec.weak_framework = 'SwiftUI'
end
