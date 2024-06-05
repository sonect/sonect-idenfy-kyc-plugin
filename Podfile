# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'IdenfyKycPlugin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IdenfyKycPlugin
  pod 'iDenfySDK/iDenfyLiveness'
  pod 'sonect-core-ios'
  pod 'lottie-ios', '~> 4.4.3'
end

target 'KycPluginIntegrationApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KycPluginIntegrationApp
  pod 'iDenfySDK/iDenfyLiveness'
  pod 'sonect-shop-sdk-ios'
  pod 'sonect-core-ios'
  pod 'lottie-ios', '~> 4.4.3'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
  end
end
