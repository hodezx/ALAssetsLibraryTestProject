//
//  HOAsset.h
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/25.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HOAsset : ALAsset

@property (strong, nonatomic) NSDate *takenDate;
- (HOAsset *) initWithTakenDate:(NSDate *)takenDate;

@end
