#
# Be sure to run `pod lib lint MWAppBaseLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MWAppBaseLibrary'
  s.version          = '0.1.1'
  s.summary          = 'A short description of MWAppBaseLibrary.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mokong/MWAppBaseLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MorganWang' => 'a525325614@163.com' }
  s.source           = { :git => 'https://github.com/mokong/MWAppBaseLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.swift_version = '4.2'

  s.source_files = 'MWAppBaseLibrary/Classes/**/*'
  
  s.subspec 'Const' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Const/*.{swift}'
  end
  
  s.subspec 'Controller' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Controller/*.{swift}'
  end
  
  s.subspec 'DataBase' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/DataBase/*.{swift}'
  end
  
  s.subspec 'Extension' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Extension/*.{swift}'
  end
  
  s.subspec 'Location' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Location/*.{swift}'
  end
  
  s.subspec 'Model' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Model/*.{swift}'
  end
  
  s.subspec 'Module' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Module/*.{swift}'
  end
  
  s.subspec 'Util' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/Util/*.{swift}'
  end
  
  s.subspec 'View' do |aa|
      aa.source_files = 'MWAppBaseLibrary/Classes/View/*.{swift}'
  end
  
#  s.resource = 'MWAppBaseLibrary/Classes/*.bundle'

  # s.resource_bundles = {
  #   'MWAppBaseLibrary' => ['MWAppBaseLibrary/Assets/*.png']
  # }

   s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
   s.dependency 'SnapKit'
   s.dependency 'WCDB.swift'
   s.dependency 'KeychainAccess'
   s.dependency 'LanguageManager-iOS'
   s.dependency 'SwiftyStoreKit'
end
