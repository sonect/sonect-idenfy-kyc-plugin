//
//  IdenfyKycProviderPlugin.swift
//  SonectShopApp
//
//  Created by Marko Hlebar on 05/03/2020.
//  Copyright © 2020 Sonect. All rights reserved.
//

import UIKit
import iDenfySDK
import SonectCore

class IdenfyKycResult: NSObject, SNCKycCheckResult {
    var data: Any? = nil
    var error: Error? = nil
    var status: SNCKycVerificationStatus = .unkown
    
    init(verificationStatus: iDenfySDK.IdenfyIdentificationResult) {
        data = verificationStatus
        
        if verificationStatus.autoIdentificationStatus == .UNVERIFIED {
            status = .userCancelled
        }
        else {
            status = .pending
        }
    }
}

public class IdenfyKycProviderPlugin: NSObject, SNCKycProviderPlugin {
            
    public var platform: String = "idenfy"
    
    private var idenfyController: IdenfyController?
    private var idenfyViewController: UIViewController?
    
    public func startKycCheck(_ presentingViewController: UIViewController,
                              configuration: [AnyHashable : Any],
                              handler: @escaping SNCKycCheckResultHandler) {
        guard let token = configuration["token"] as? String else {
            fatalError("Missing token in configuration parameters.")
        }
        
        let idenfyUISettings = IdenfyUIBuilderV2()
            .withInstructions(.dialog)
            .build()
                 
        let idenfySettings = IdenfyBuilderV2()
            .withUISettingsV2(idenfyUISettings)
            .withAuthToken(token)
            .build()
        
        let idenfyController = IdenfyController.shared
        idenfyController.initializeIdenfySDKV2WithManual(idenfySettingsV2: idenfySettings)
        let idenfyViewController = idenfyController.instantiateNavigationController()
        
        idenfyController.getIdenfyResultWithDismiss { [weak self] idenfyIdentificationResult in
            let result = IdenfyKycResult(verificationStatus: idenfyIdentificationResult)
            handler(result)
            
            self?.idenfyController = nil
            self?.idenfyViewController = nil
        }
        
        presentingViewController.present(idenfyViewController, animated: true, completion: nil)
        
        self.idenfyController = idenfyController
        self.idenfyViewController = idenfyViewController
    }
}
