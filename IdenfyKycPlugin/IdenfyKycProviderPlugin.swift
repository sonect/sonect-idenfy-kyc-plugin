//
//  IdenfyKycProviderPlugin.swift
//  SonectShopApp
//
//  Created by Marko Hlebar on 05/03/2020.
//  Copyright © 2020 Sonect. All rights reserved.
//

import UIKit
import SonectShop
import iDenfySDK

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
    
    public func startKycCheck(_ presentingViewController: UIViewController, configuration: [AnyHashable : Any], handler: @escaping SNCKycCheckResultHandler) {
        let countryCode = configuration["countryCode"] as! String
        let token = configuration["token"] as! String
        
        let idenfyLivenessUISettings = IdenfyLivenessUISettings()
        idenfyLivenessUISettings.livenessFeedbackBackgroundColor = flamingoColor
        idenfyLivenessUISettings.livenessFeedbackFontColor = whiteColor
        idenfyLivenessUISettings.livenessFrameBackgroundColor = blackColor
        idenfyLivenessUISettings.livenessIdentificationOvalProgressColor1 = flamingoColor
        idenfyLivenessUISettings.livenessIdentificationOvalProgressColor2 = flamingoColor
        idenfyLivenessUISettings.livenessIdentificationProgressStrokeColor = flamingoColor
        idenfyLivenessUISettings.livenessIdentificationProgressStrokeWidth = 8
        idenfyLivenessUISettings.livenessIdentificationProgressRadialOffset = 16
        
        let idenfyUISettings = IdenfyUIBuilder()
            .withLivenessUISettings(livenessUISettings: idenfyLivenessUISettings)
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
        
        let idenfySettings = IdenfyBuilder()
            .withUISettings(idenfyUISettings)
            .withCustomLocalStoryboard(true)
            .withIssuingCountry(countryCode)
            .withAuthToken(token)
            .build()
        
        let idenfyController = IdenfyController(idenfySettings: idenfySettings)
        idenfyController.handleIDenfyCallbacks(
            onSuccess: { (response) in
                let status = ProfileIdentityVerificationStatus(
                    authenticationStatus: response,
                    errorStatus: nil,
                    userExit: nil)
                let result = IdenfyKycResult(verificationStatus: status)
                handler(result)
        },
            onError: { (response) in
                let status = ProfileIdentityVerificationStatus(
                    authenticationStatus: nil,
                    errorStatus: response,
                    userExit: nil)
                let result = IdenfyKycResult(verificationStatus: status)
                handler(result)
        },
            onUserExit: {
                //User exited the SDK without completing identification process.
                let status = ProfileIdentityVerificationStatus(
                    authenticationStatus: nil,
                    errorStatus: nil,
                    userExit: true)
                let result = IdenfyKycResult(verificationStatus: status)
                handler(result)
        })
        
        let idenfyVC = idenfyController.instantiateNavigationController()
        presentingViewController.present(idenfyVC, animated: true, completion: nil)
    }
}
