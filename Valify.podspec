Pod::Spec.new do |s|
  s.name             = 'Valify'
  s.version          = '0.12.0'
  s.summary          = 'Valify'
  s.description      = <<-DESC
Clean, simple, and customizable.
DESC

  s.homepage         = 'https://github.com/ShabanKamell/SwiftUIChipGroup'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'ShabanKamell' => 'sh3ban.kamel@gmail.com' }
  s.source           = { :git => 'https://github.com/ShabanKamell/SwiftUIChipGroup.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ShaAhKa'

  s.swift_version = '5'
  s.ios.deployment_target = '13.0'
  s.source_files  = "Sources/**/*"
  s.exclude_files  = "Sources/Supporting Files/**/*"
  s.framework  = "Foundation"
end
