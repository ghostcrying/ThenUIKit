Pod::Spec.new do |s|
  s.name             = 'ThenUIKit'
  s.version          = '0.0.8'
  s.summary          = 'The Basic UIKit Framework'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage      = 'https://github.com/ghostcrying/ThenFoundation'
  # s.screenshots = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.author        = { 'ghost' => 'czios1501@gmail.com' }
  s.source        = { :git => 'https://github.com/ghostcrying/ThenUIKit.git', :tag => s.version.to_s }
  
  s.platform      = :ios, "11.0"
  s.swift_version = "5.0"

  s.source_files  = 'Sources/**/*.{swift,h,m}', 'Sources/*.h'
  
  s.frameworks    = 'Foundation', 'UIKit'
  
  s.dependency 'ThenFoundation', '~> 0.0.7'
  
end

