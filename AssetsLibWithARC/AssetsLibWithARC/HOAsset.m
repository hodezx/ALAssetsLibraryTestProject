//
//  HOAsset.m
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/25.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import "HOAsset.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HOAsset
@synthesize createdDate = _createdDate;
@synthesize takenDate = _takenDate;
@synthesize hashValue = _hashValue;

- (NSString *)getHash:(UIImage *)inImage
{
    unsigned char result[16];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(inImage)];
    CC_MD5([imageData bytes], [imageData length], result);
    NSString *imageHash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]];
    return imageHash;
}

- (NSDate *) getCreatedDateOfAsset:(ALAsset *)asset
{
    return [asset valueForProperty:ALAssetPropertyDate];
}

- (NSDate *) getTakenDateOfAsset:(ALAsset *)asset
{
    @autoreleasepool {
        
        NSDictionary *metadata = asset.defaultRepresentation.metadata;
        NSString *takenDateStr = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
        NSDate *takenDate = [formatter dateFromString:takenDateStr];
        
        return (takenDate == nil) ? [self getCreatedDateOfAsset:asset] : takenDate;
    }
}

- (HOAsset *) initWithAsset:(ALAsset *)asset
{
    self = [super init];
    if (!self)
        return nil;
    else {
        // Set the asset
        self.asset = asset;
        // Set the property date
        self.createdDate = [self getCreatedDateOfAsset:asset];
        // Set the taken date
        self.takenDate = [self getTakenDateOfAsset:asset];
        // Set the thumbnail
        self.thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
        // Set the hash value of the thumbnail
        //self.hashValue = [self getHash:self.thumbnail];
    }
    return self;
}

@end
