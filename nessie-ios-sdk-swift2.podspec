#
# Be sure to run `pod lib lint nessie-ios-sdk-swift2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "nessie-ios-sdk-swift2"
  s.version          = "0.1"
  s.summary          = "iOS sdk for Nessie - Swift2."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                        A longer description of nessie-ios-wrapper in Markdown format.
                        * Support for swift2
                        * we have a separate pod for swift 1.2
                        * iOS wrapper for the nessie API
                       DESC

  s.homepage         = "https://github.com/nessieisreal/nessie-ios-sdk-swift2"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.authors           = { "Raúl" => "victor.lv.82@gmail.com","borikanes" => "ooludemi@terpmail.umd.edu" }
  s.source           = { :git => "https://github.com/nessieisreal/nessie-ios-sdk-swift2.git", :tag => "v0.1" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Nessie-iOS-Wrapper/**/*'
  # s.resource_bundles = {
  #   'nessie-ios-sdk-swift2' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
