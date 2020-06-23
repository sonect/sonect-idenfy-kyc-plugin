Pod::Spec.new do |spec|

    spec.name         = "sonect-idenfy-kyc-plugin"
    spec.version      = "1.0.1"
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
    spec.platform     = :ios, "9.0"
    spec.source       = { :http => "https://github.com/sonect/sonect-idenfy-kyc-plugin/releases/download/#{spec.version}/IdenfyKycPlugin_Cocoapods.framework.zip" }
    spec.ios.vendored_frameworks = 'IdenfyKycPlugin.framework'
  
  end
  