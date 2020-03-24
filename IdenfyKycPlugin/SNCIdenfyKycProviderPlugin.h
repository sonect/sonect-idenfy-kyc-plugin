//
//  SNCIdenfyKycProviderPlugin.h
//  IdenfyKycPlugin
//
//  Created by Marko Hlebar on 23/03/2020.
//  Copyright © 2020 Sonect. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//We can't use this from the public interface as it breaks compilation in the project where SonectShop.framework is added
//#import <SonectShop/SNCIdenfyKycProviderPlugin.h>

//Marking a forward protocol helps fix the problem with imports.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"

@protocol SNCKycProviderPlugin;
@interface SNCIdenfyKycProviderPlugin : NSObject <SNCKycProviderPlugin>
#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
