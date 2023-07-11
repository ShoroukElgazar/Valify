Pod::Spec.new do |s|
  s.name             = 'Valify'
  s.version          = '1.1.0'
  s.summary          = 'Valify'
  s.description      = <<-DESC
Clean, simple, and customizable.
DESC

  s.homepage         = 'https://github.com/ShoroukElgazar/Valify.git'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Shorouk' => 'shorouk.mohamed93@gmail.com' }
  s.source           = { :git => 'https://github.com/ShoroukElgazar/Valify.git', :tag => '1.2.0' }


  s.swift_version = '5'
  s.ios.deployment_target = '14.0'
  s.source_files  = "Sources/**/*"
  s.exclude_files  = "Sources/Supporting Files/**/*"
  s.framework  = "Foundation"
end
