Pod::Spec.new do |spec|

    spec.name         = "sonect-idenfy-kyc-plugin"
    spec.version      = "3.6.0"
    spec.summary      = "Sonect Scandit Scan Plugin"
    spec.description  = <<-DESC
    This is the Sonect Idenfy KYC Plugin public podspec. 
                     DESC
  
    spec.homepage     = "https://github.com/sonect/sonect-idenfy-kyc-plugin"
    spec.license      = { :type => "Sonect Closed Source", :text => <<-LICENSE
                      Copyright (C) Sonect AG - All Rights Reserved
                      Unauthorized copying of this file, and the Sonect SDK via any medium is strictly prohibited
                      Proprietary and confidential
                      Sonect, February 2012. 
                      LICENSE
                 }
    spec.author             = { "sonect" => "marko.hlebar@sonect.ch" }
    spec.platform     = :ios, "13.0"
    spec.source       = { :git => "https://github.com/sonect/sonect-idenfy-kyc-plugin.git", :tag => spec.version }
    spec.source_files       = 'IdenfyKycPlugin/*.swift', 'IdenfyKycPlugin/Classes/*.swift'
    spec.swift_version = '5.0'
    
    spec.dependency 'iDenfySDK/iDenfyLiveness', '8.5.0'
    spec.dependency 'lottie-ios'
    spec.dependency 'sonect-core-ios'

    #this don't pass pod lib lint until this is fixed  
    spec.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
    
  end