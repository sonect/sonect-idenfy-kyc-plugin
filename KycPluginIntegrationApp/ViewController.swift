//
//  ViewController.swift
//  KycPluginIntegrationApp
//
//  Created by Marko Hlebar on 23/03/2020.
//  Copyright © 2020 Sonect. All rights reserved.
//

import UIKit
import SonectShop
import SonectCore
import IdenfyKycPlugin
import CommonCrypto

class ScanPlugin: NSObject, SNCScanCodePlugin {
    func viewController() -> UIViewController {
        return UIViewController()
    }
    func scan(_ handler: @escaping SNCScanCodeResultHandler) {}
    func stop() {}
}

func hmacSignature(for parameters:[String], hmacKey:String) -> String {
    let string = parameters.joined(separator:":")
    let str = Array(string.utf8CString)
    let key = hmacKey.data(using: .utf8)!
    
    let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<UInt8>.allocate(capacity:digestLen)
    
    key.withUnsafeBytes { body in
        CCHmac(UInt32(kCCHmacAlgSHA256), body.baseAddress, key.count, str, string.count, result)
    }
    
    let hmac = Data(bytes: result, count: digestLen)
    let digest = hmac.base64EncodedString()
    
    result.deallocate()
    return digest
}

class ViewController: UIViewController {
    
    
    let clientId = "301da290-b3c1-11ea-a237-b9638f3287a8"
    let clientSecret = "143d9a778e999daf070cebcf17268ba361a5ac8909d21bf88ff13d363f15cc1e"
    let merchantId = "marko6"
    let deviceId = "001"
    let hmacKey = "db9c0e27ff0d9d7251a555a75c6feeee1be1f57c2cb972a48583c63dbb04f608"

    @IBAction func startSdk(_ sender: Any) {
        let sdkToken = calculateSdkToken(clientId: clientId,
                                         clientSecret: clientSecret)
        
        //THIS SHOULD BE CALCULATED ON THE SERVER
        let signature = calculateSignature(clientId: clientId,
                                           shopId: merchantId,
                                           key: hmacKey)
        
        let credentials = SNCShopCredentials(sdkToken: sdkToken,
                                             merchantId: merchantId,
                                             signature: signature,
                                             deviceId: deviceId)
        let configuration = SNCShopConfiguration.default()
        SNCSonectShop.kycProviderPlugin = IdenfyKycProviderPlugin()
        SNCSonectShop.scanCodePlugin = ScanPlugin()
        SNCSonectShop.present(with: credentials,
                              configuration: configuration,
                              presenting: self)
    }
    
    func calculateSignature(clientId:String, shopId:String, key:String) -> String {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let parameters = [
              clientId,
              bundleIdentifier,
              shopId
        ]
        
        return hmacSignature(for: parameters, hmacKey: key)
    }
    
    func calculateSdkToken(clientId:String, clientSecret:String) -> String {
        let string = "\(clientId):\(clientSecret)"
        let data = string.data(using: .utf8)
        return data!.base64EncodedString()
    }
}
