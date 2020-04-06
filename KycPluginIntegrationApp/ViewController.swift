//
//  ViewController.swift
//  KycPluginIntegrationApp
//
//  Created by Marko Hlebar on 23/03/2020.
//  Copyright © 2020 Sonect. All rights reserved.
//

import UIKit
import SonectShop
import IdenfyKycPlugin

class ScanCodePlugin: NSObject, SNCScanCodePlugin {
    func viewController() -> UIViewController {
        return UIViewController()
    }
    
    func scan(_ handler: @escaping SNCScanCodeResultHandler) {
    }
    
    func stop() {
    }
}

class ViewController: UIViewController {

    @IBAction func startSdk(_ sender: Any) {
        let credentials = SNCShopCredentials(sdkToken: "YOUR_SDK_TOKEN",
                                             merchantId: "YOUR_MERCHANT_ID",
                                             signature: "YOUR_SIGNATURE",
                                             deviceId: "YOUR_DEVICE_ID")
        let configuration = SNCShopConfiguration.default()
        SNCSonectShop.kycProviderPlugin = IdenfyKycProviderPlugin()
        SNCSonectShop.scanCodePlugin = ScanCodePlugin()
        SNCSonectShop.present(with: credentials,
                              configuration: configuration,
                              presenting: self)
    }
}

