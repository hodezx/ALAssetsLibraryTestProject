//
//  HOAsset.h
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/25.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HOAsset : NSObject

@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) NSDate *takenDate;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSString *hashValue;
@property (strong, nonatomic) UIImage *thumbnail;

- (HOAsset *) initWithAsset:(ALAsset *)asset;

@end
