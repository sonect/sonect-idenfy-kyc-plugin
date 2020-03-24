//
//  SNCIdenfyKycProviderPlugin.m
//  IdenfyKycPlugin
//
//  Created by Marko Hlebar on 23/03/2020.
//  Copyright © 2020 Sonect. All rights reserved.
//

#import "SNCIdenfyKycProviderPlugin.h"
#import <SonectShop/SonectShop.h>
@import iDenfySDK;
@import IdenfyLiveness;

@interface SNCIdenfyKycProviderPlugin ()

@property (nonatomic, strong) UIColor *flamingoColor;
@property (nonatomic, strong) UIColor *whiteColor;
@property (nonatomic, strong) UIColor *blackColor;

@end

@implementation SNCIdenfyKycProviderPlugin

- (void)startKycCheck:(UIViewController *)presentingViewController
        configuration:(NSDictionary *)configuration
              handler:(SNCKycCheckResultHandler)handler {
    NSString *countryCode = configuration[@"countryCode"];
    NSString *token = configuration[@"token"];

//    IdenfyLivenessUISettings *settings = [IdenfyLivenessUISettings new];
    
//    IdenfyUISettings *settings;
}

@end
