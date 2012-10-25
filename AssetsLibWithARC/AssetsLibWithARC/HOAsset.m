//
//  HOAsset.m
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/25.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import "HOAsset.h"

@implementation HOAsset
@synthesize takenDate = _takenDate;

- (HOAsset *) initWithTakenDate:(NSDate *)takenDate
{
    self = [super init];
    if (!self)
        return nil;
    else
        self.takenDate = takenDate;
    return self;
}

@end
