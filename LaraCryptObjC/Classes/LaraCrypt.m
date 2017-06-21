//
//  LaraCrypt.h
//  Cont
//
//  Created by Fardad Co on 5/13/17.
//  Copyright © 2017 Fardad Co. All rights reserved.
//

#import "LaraCrypt.h"


LaraCrypt *laravelCrypt;


@implementation LaraCrypt


//Shared Instance
+(LaraCrypt *)laravelCrypt{
    if (laravelCrypt == nil) {
        laravelCrypt = [[LaraCrypt alloc ]init];
    }
    return laravelCrypt;
}

#pragma mark - Method Handler
-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)letters.length)]];
    }
    return randomString;
}

-(NSString *)stringSerilizer:(NSString *)str{
    return [NSString stringWithFormat:@"s:%lu:\"%@\";",(unsigned long)str.length,str];
}



-(NSString *)AES256CBC_WithKeyData:(NSData *)keyData andIvData:(NSData *)ivData andSerilizedMessage:(NSString *)serilizedMessage andSerilizedMessageData:(NSData *)serilizedMessageData  {
    // Encryption
    size_t         encryptBytes = 0;
    NSMutableData *encrypted  = [NSMutableData dataWithLength:serilizedMessage.length + kCCBlockSizeAES128];
    CCCrypt(
            kCCEncrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding,
            keyData.bytes,
            kCCKeySizeAES256,
            ivData.bytes,
            serilizedMessageData.bytes,
            serilizedMessageData.length,
            encrypted.mutableBytes,
            encrypted.length,
            &encryptBytes
            );
    
    encrypted.length = encryptBytes;
    NSString *encStr = [encrypted base64EncodedStringWithOptions:0];
    return encStr;
}

-(NSString *)MIX_RUNNER:(NSString *)a andB:(NSString *)b{
    return [NSString stringWithFormat:@"%@%@",a,b];
}

-(NSString *)DATA_TO_HeX_With_HmacDigestData:(NSData *)digestData{
    const unsigned char *dataBuffer = (const unsigned char *)[digestData bytes];
    NSUInteger          dataLength  = [digestData length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

-(NSString *)HMAC_CREATOR:(NSString *)mixStr andKeyData:(NSData *)keyData  {
    
    NSData *signatureData = [mixStr dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CCHmacContext context;
    CCHmacInit(&context, kCCHmacAlgSHA256, keyData.bytes, keyData.length);
    CCHmacUpdate(&context, signatureData.bytes, signatureData.length);
    CCHmacFinal(&context, digest);
    NSData *digestData = [NSData dataWithBytes:digest length:sizeof(digest)];
    return [self DATA_TO_HeX_With_HmacDigestData:digestData];
}

#pragma mark - Encryption

-(NSString *)laraEncWithMessage:(NSString *)message andKey:(NSString *)key{
    
    NSString *keyString = key;
    NSString *serilizedMessage = [self stringSerilizer:message];
    NSData *serilizedMessageData = [serilizedMessage dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:keyString options:0];
    NSString *iv = [self randomStringWithLength:16];
    NSData *encodeIvData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSString *ivBase64Str = [encodeIvData base64EncodedStringWithOptions:0];
    NSData *ivData = [iv dataUsingEncoding:NSUTF8StringEncoding];
    
    // Encryption
    NSString *encStr = [self AES256CBC_WithKeyData:keyData andIvData:ivData andSerilizedMessage:serilizedMessage andSerilizedMessageData:serilizedMessageData];
    
    NSString *mixStr = [self MIX_RUNNER:ivBase64Str andB:encStr];
    NSString *mac = [self HMAC_CREATOR:mixStr andKeyData:keyData];
    NSDictionary *dict = @{@"iv":ivBase64Str,@"value":encStr,@"mac":mac};
    
    NSError  * err;
    NSData   * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonBase64Str_ENCRYPTED = [[myString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    NSLog(@"%@ %lu",jsonBase64Str_ENCRYPTED,(unsigned long)jsonBase64Str_ENCRYPTED.length);
    
    return jsonBase64Str_ENCRYPTED;
    
}







@end
