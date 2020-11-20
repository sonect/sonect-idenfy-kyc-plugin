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

struct ProfileIdentityVerificationStatus {
    let authenticationStatus: iDenfySDK.AuthenticationResultResponse?
    let errorStatus: iDenfySDK.IdenfyErrorResponse?
    let userExit: Bool?
}

class IdenfyKycResult: NSObject, SNCKycCheckResult {
    var data: Any? = nil
    var error: Error? = nil
    var status: SNCKycVerificationStatus = .unkown
    
    init(verificationStatus: ProfileIdentityVerificationStatus) {
        data = verificationStatus
        
        if let _ = verificationStatus.userExit {
            status = .userCancelled
        }
        else if let errorStatus = verificationStatus.errorStatus {
            status = .failure
            error = NSError(domain: "ch.sonect.idenfyKycPlugin",
                            code: 1000,
                            userInfo: [NSLocalizedDescriptionKey: errorStatus.message])
        }
        else if let idenfyStatus = verificationStatus.authenticationStatus?.idenfyIdentificationStatus {
            switch idenfyStatus {
            case .APPROVED: fallthrough
            case .REVIEWING:
                status = .pending
            case .DENIED: fallthrough
            case .SUSPECTED:
                status = .failure
                error = NSError(domain: "ch.sonect.idenfyKycPlugin",
                                code: 1001,
                                userInfo: [NSLocalizedDescriptionKey: verificationStatus.authenticationStatus?.errorMessage?.en ?? "Unknown Kyc Error"])
            @unknown default:
                break
            }
        }
    }
}

public class IdenfyKycProviderPlugin: NSObject, SNCKycProviderPlugin {
        
    var flamingoColor = UIColor.systemPink
    var whiteColor = UIColor.white
    var blackColor = UIColor.black
    
    public var platform: String = "idenfy"
    
    private var idenfyController: IdenfyController?
    private var idenfyVC: UINavigationController?
    
    public func startKycCheck(_ presentingViewController: UIViewController, configuration: [AnyHashable : Any], handler: @escaping SNCKycCheckResultHandler) {
        let countryCode = configuration["countryCode"] as! String
        let token = configuration["token"] as! String
        
        let idenfyUISettings = IdenfyUIBuilder()
            .withCustomDocumentBorderColor(borderColor: .clear)
            .build()
        
        let identificationSessionSettings = IdentificationSessionUISettings()
        identificationSessionSettings.overridesStoryboard = true
        identificationSessionSettings.idenfyPhotoResultBackgroundColor = blackColor
        identificationSessionSettings.idenfyTransparentCameraOverlayColor = blackColor
        identificationSessionSettings.idenfyFaceResultsInformationTitleColor = whiteColor
        identificationSessionSettings.idenfyFaceSessionCameraInformationTitleColor = whiteColor
        identificationSessionSettings.idenfyDocumentsCameraSessionInformationTitleColor = whiteColor
        identificationSessionSettings.idenfyDocumentsResultsInformationTitleColor = whiteColor
        idenfyUISettings.setIdentificationSessionUISettings(identificationSessionUISettings: identificationSessionSettings)
        
        let idenfyIdentificationResults = IdenfyIdentificationResultsSettings()
        idenfyIdentificationResults.isSuccessResultsViewVisible = false
        idenfyIdentificationResults.isErrorResultsViewVisible = false
        idenfyIdentificationResults.isRetryErrorResultsViewVisible = false
        idenfyIdentificationResults.isRetryingIdentificationAvailable = false
        idenfyIdentificationResults.isAutoDismissOnSuccessEvent = false
        idenfyIdentificationResults.isAutoDismissOnErrorEvent = false
        idenfyIdentificationResults.isAutoDismissOnUserExitEvent = false
        
        let idenfySettings = IdenfyBuilder()
            .withCustomIdentificationResultsSettings(idenfyIdentificationResults)
            .withUISettings(idenfyUISettings)
            .withCustomLocalStoryboard(true)
            .withIssuingCountry(countryCode)
            .withAuthToken(token)
            .build()
        
        let idenfyController = IdenfyController(idenfySettings: idenfySettings)
        let idenfyVC = idenfyController.instantiateNavigationController()
        
        idenfyController.handleIDenfyCallbacks(
            onSuccess: { (response) in
                let status = ProfileIdentityVerificationStatus(
                    authenticationStatus: response,
                    errorStatus: nil,
                    userExit: nil)
                let result = IdenfyKycResult(verificationStatus: status)
                handler(result)
                
                idenfyVC.dismiss(animated: true, completion: nil)
        },
            onError: { (response) in
                let status = ProfileIdentityVerificationStatus(
                    authenticationStatus: nil,
                    errorStatus: response,
                    userExit: nil)
                let result = IdenfyKycResult(verificationStatus: status)
                handler(result)
                
                idenfyVC.dismiss(animated: true, completion: nil)
        },
            onUserExit: {
                //User exited the SDK without completing identification process.
                let status = ProfileIdentityVerificationStatus(
                    authenticationStatus: nil,
                    errorStatus: nil,
                    userExit: true)
                let result = IdenfyKycResult(verificationStatus: status)
                handler(result)
                
                idenfyVC.dismiss(animated: true, completion: nil)
        })
        
        presentingViewController.present(idenfyVC, animated: true, completion: nil)
        
        self.idenfyController = idenfyController
        self.idenfyVC = idenfyVC
    }
}
