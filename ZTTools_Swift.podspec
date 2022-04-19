#
# Be sure to run `pod lib lint ZTTools_Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZTTools_Swift'
  s.version          = '0.1.5'
  s.summary          = '工具库Swift版'

  s.description      = <<-DESC
私有工具库，用到的东西都会放到这里，工具库也分为权限、逻辑、UI等
                       DESC

  s.homepage         = 'https://github.com/OCer/ZTTools_Swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nakiri' => '347464661@qq.com' }
  s.source           = { :git => 'https://github.com/OCer/ZTTools_Swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  # 需要设置，不然项目引入库后会崩溃
#  s.pod_target_xcconfig = {
#    # 这在理论上也可以适用于任何's.dependency'
#    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
#  }
  
#  s.user_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
  
  # Xcode12需要加上这2句，排除模拟器不支持的arm64架构
#  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.swift_versions = ['5.0']
  
  s.vendored_frameworks = 'ZTTools_Swift/Classes/ZTTools.xcframework'
  
  s.frameworks = 'UIKit', 'Foundation', 'Photos', 'UserNotifications', 'AVFoundation', 'CoreGraphics'
  s.dependency 'Alamofire','5.6.1'
  s.dependency 'SnapKit','5.6.0'

end
