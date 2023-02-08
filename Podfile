# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'IdenfyKycPlugin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IdenfyKycPlugin
  pod 'iDenfySDK', '~> 7.5.0'
  pod 'sonect-core-ios'
  pod 'lottie-ios', '~> 3.2.1'
end

target 'KycPluginIntegrationApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KycPluginIntegrationApp
  pod 'iDenfySDK', '~> 7.5.0'
  pod 'sonect-shop-sdk-ios'
  pod 'sonect-core-ios'
  pod 'lottie-ios', '~> 3.2.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
  end
end
