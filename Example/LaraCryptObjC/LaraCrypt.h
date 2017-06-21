//
//  LaraCrypt.h
//  Cont
//
//  Created by Fardad Co on 5/13/17.
//  Copyright © 2017 Fardad Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHMAC.h"
#import "CommonCryptor.h"

@interface LaraCrypt : NSObject

//Shared Instance
+(LaraCrypt *)laravelCrypt;

#pragma mark - Encryption

-(NSString *)laraEncWithMessage:(NSString *)message andKey:(NSString *)key;

@end
