//
//  ViewController.m
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/19.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import "HOAsset.h"
#import<malloc/malloc.h>
#import <CommonCrypto/CommonDigest.h>

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *assets;
    ALAssetsLibrary *lib;
    int i;
    NSDate *startDate;
    NSTimer *timer;
    CFAbsoluteTime startTime, stopTime;
    NSArray *assetsByCreatedDate, *assetsByTakenDate;
    NSMutableArray *hoassets;
    NSDateFormatter *formatter;
}

@synthesize myActivity = _myActivity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) startCountingTime;
{
    startDate = [[NSDate alloc] init];
}

- (NSTimeInterval) stopCountingTime
{
//    stopTime = CFAbsoluteTimeGetCurrent();
//    NSLog(@"Used time by CFAbsoluteTime: %f seconds.", stopTime - startTime);
    
    NSDate *timeNow = [[NSDate alloc] init];
    return [timeNow timeIntervalSinceDate:startDate];
}

- (void) showUsedTime: (NSTimeInterval)usedTime;
{
    NSLog(@"Iterating takes up %g seconds.", usedTime);
    self.statusLabel.text = [NSString stringWithFormat:@"Takes up %.2f secs.", usedTime];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusLabel.text = @"Iterate before sort.";
    [self.myActivity setHidden:YES];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
}

- (void) showNumOfPic
{
    NSLog(@"There are %d photos loaded", i);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyActivity:nil];
    [self setStatusLabel:nil];
    [self setImageView:nil];
    [super viewDidUnload];
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

    NSDate *takenDate = [formatter dateFromString:takenDateStr];
    
    //metadata = nil;
    //takenDateStr = nil;
    return (takenDate == nil) ? [self getCreatedDateOfAsset:asset] : takenDate;
    }
}

- (void) showMetadata
{
    NSDictionary *metadata;
    
    NSLog(@"Getting the item out of assets array. And the metadata is like: ");
    ALAsset *asset = [assets lastObject];
    metadata = asset.defaultRepresentation.metadata;
    NSLog(@"%@", metadata);
    
    NSLog(@"Created Date of this asset: %@", [asset valueForProperty:ALAssetPropertyDate]);
    
    // Get the original date time
    NSString *takenDate = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
    
    if (takenDate != nil)
        NSLog(@"This photo was taken at the time: %@", takenDate);
    else
        NSLog(@"This photo doesn't have taken date information.");
//    formatter dateFromString:[];
    

    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
    NSLog(@"Location of this asset: %@", location);
 
    
}

// Get information out of the asset, including:
// metadata, createDate, takenDate(if exists), location(Problem1)
// Problem1: Missing CoreLocation framework on iOS 6 SDK with Xcode 4.5
// Problem1 solved: Add the framework manually via Finder
- (void) showAssetMetadataWithoutLog:(ALAsset *)asset
{
    //NSDictionary *metadata = asset.defaultRepresentation.metadata;
    /*
    NSDate *createDate = [asset valueForProperty:ALAssetPropertyDate];
    
    // Get the original date time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSString *takenDateStr = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
    NSDate *takenDate = [formatter dateFromString:takenDateStr];
    
    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];    
     */
}

- (void) showAssetMetadata:(ALAsset *)asset
{
    NSDictionary *metadata;
    
    NSLog(@"Getting the item out of assets array. And the metadata is like: ");
    metadata = asset.defaultRepresentation.metadata;
    NSLog(@"%@", metadata);
    
    NSLog(@"Created Date of this asset: %@", [asset valueForProperty:ALAssetPropertyDate]);
    
    // Get the original date time
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSString *takenDateStr = [[metadata objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
    NSDate *takenDate = [formatter dateFromString:takenDateStr];

    
    if (takenDate != nil)
        NSLog(@"This photo was taken at the time: %@", takenDate);
    else
        NSLog(@"This photo doesn't have taken date information.");
    //    formatter dateFromString:[];
    
    //NSLog(@"")
    
    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
    NSLog(@"Location of this asset: %@", location);
    
}

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

- (int) cntOfDiffPhoto:(NSArray *)assetsArray
{
    int cnt = 0;
    NSMutableArray *hashes = [[NSMutableArray alloc] init];
    
    for (HOAsset *asset in assetsArray) {
        NSString *hashVal = [NSString stringWithFormat:@"%@", asset.hashValue];
        if (![hashes containsObject:hashVal]) {
            cnt++;
            [hashes addObject:hashVal];
        }
    }
    
    return cnt;//[hashes count];
}

- (void) showThumbnail
{
    ALAsset *asset = [assets lastObject];
    UIImage *thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
    
    CGImageRef cg_thumbnail = asset.thumbnail;
    NSLog(@"Size of the CGImageRef: %lu %lu", CGImageGetHeight(cg_thumbnail), CGImageGetWidth(cg_thumbnail));
    
    [self.imageView setImage:thumbnail];
    NSLog(@"The size of the thumbnail %g %g", thumbnail.size.width, thumbnail.size.height);
    NSLog(@"The URL of the asset: %@", asset.defaultRepresentation.url);
    NSData *data = UIImageJPEGRepresentation(thumbnail, 0);
    NSLog(@"The space it uses: %d", [data length]);
}

- (IBAction)startBtnPressed:(UIButton *)sender {
    [self.myActivity setHidden:NO];
    [self.myActivity startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self doStartBtnPressed:sender];
    });
}

- (IBAction)doStartBtnPressed:(UIButton *)sender {

    
    i = 0;
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result != NULL) {
            stop = FALSE;
            //NSLog(@"See asset: %@ at %d", result, i++);
            i++;
            
            [assets addObject:result];
            NSLog(@"index: %d", index);
            /*
            double t = (double)(rand() % 100) / 100;

            [NSThread sleepForTimeInterval:t];
            NSLog(@"The index for this asset: %d", index);
            NSLog(@"time: %g", t);
            NSLog(@"Count of the assets: %d", assets.count);
            */
            
            //[self showNumOfPic];
            //[self showAssetMetadataWithoutLog:result];
            //[self showAssetMetadata:result];
            //[self showMetadata];
            //NSLog(@"Hash of this asset thumbnail %@", [self getHash:[UIImage imageWithCGImage:[result thumbnail]]]);
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            NSLog(@"start processing the group");
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            //[group enumerateAssetsUsingBlock:assetEnumerator];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [group numberOfAssets] - 1)];
            [group enumerateAssetsAtIndexes:indexSet options:NSEnumerationConcurrent usingBlock:assetEnumerator];
        }
        else {
            // Reach the end of iterating? Not neccessarily.
            NSLog(@"end of group");
            [self showNumOfPic];
            [self showUsedTime:[self stopCountingTime]];
            
            // Show the metadata of the first item out of assets
            //[self showMetadata];
            [self showThumbnail];
            ALAsset *last = [assets lastObject];
            NSDictionary *last_dict = last.defaultRepresentation.metadata;
            
            NSArray *dictArr = [last_dict allValues];
            id obj = nil;
            int totalSize = 0;
            for (obj in dictArr) {
                totalSize += malloc_size((__bridge const void *)(obj));
            }
            
            NSLog(@"Hash of this asset thumbnail %@", [self getHash:[UIImage imageWithCGImage:[last thumbnail]]]);

            NSLog(@"size of myObject: %zd", totalSize);
            NSLog(@"the array of all values looks like: %@", dictArr);
            
            NSLog(@"size of thumbnail: %zd", malloc_size(last.thumbnail));
            
            NSLog(@"size of the default representation: %llu", last.defaultRepresentation.size);
            

        }
        
        [self.myActivity stopAnimating];
        [self.myActivity setHidden:YES];
    };
    
    assets = [[NSMutableArray alloc] init];
    lib = [[ALAssetsLibrary alloc] init];
    
    self.statusLabel.text = @"Iterating through all photos...";
    
    [self startCountingTime];
    startTime = CFAbsoluteTimeGetCurrent();
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
        NSLog(@"Failed: %@", error);
    }];
    

}
- (IBAction)sortByCDBtnPressed:(UIButton *)sender {
    [self.myActivity setHidden:NO];
    [self.myActivity startAnimating];
    
    if ([assets count] <= 1) {
        //NSLog(@"Sorted by created date.");
        [self performSelector:@selector(startBtnPressed:)];
    }
    
    // Start counting
    [self startCountingTime];
    assetsByCreatedDate = [assets sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *obj1_CD = [self getCreatedDateOfAsset:obj1];
        NSDate *obj2_CD = [self getCreatedDateOfAsset:obj2];
        return [obj2_CD compare:obj1_CD];
    }];
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@, Sorted by CD takes up %gs", self.statusLabel.text, [self stopCountingTime]];
    
    [self.myActivity stopAnimating];
    [self.myActivity setHidden:YES];
    
    NSLog(@"Test the sortByCD: %@ %@", [self getCreatedDateOfAsset:[assetsByCreatedDate objectAtIndex:0]], [self getCreatedDateOfAsset:[assetsByCreatedDate lastObject]]);
}

- (IBAction)sortByTDBtnPressed:(UIButton *)sender {
    [self.myActivity setHidden:NO];
    [self.myActivity startAnimating];
    
    if ([assets count] < 1) {
        //NSLog(@"Sorted by taken date.");
        [self performSelector:@selector(startBtnPressed:)];
    }
    
    // Start counting
    [self startCountingTime];
    
    hoassets = [[NSMutableArray alloc] init];
    for (ALAsset *asset in assets) {
        HOAsset *hoasset = [[HOAsset alloc] initWithAsset:asset];
        [hoassets addObject:hoasset];
        hoasset = nil;
    }

    
    assetsByTakenDate = [hoassets sortedArrayUsingComparator:^NSComparisonResult(HOAsset *obj1, HOAsset *obj2) {
        NSDate *obj1_TD = obj1.takenDate;
        NSDate *obj2_TD = obj2.takenDate;
        return [obj2_TD compare:obj1_TD];
    }];
     
    
     
    self.statusLabel.text = [NSString stringWithFormat:@"%@, Sorted by TD takes up %gs", self.statusLabel.text, [self stopCountingTime]];
    
    //NSLog(@"There are %d different photos.", [self cntOfDiffPhoto:hoassets]);
    
//    for (HOAsset *anAsset in hoassets) {
//        NSLog(@"taken date: %@, hash: %@", anAsset.takenDate, anAsset.hashValue);
//    }
    
    [self.myActivity stopAnimating];
    [self.myActivity setHidden:YES];
    
    //NSLog(@"Test the sortByTD: %@ %@", [self getTakenDateOfAsset:[assetsByTakenDate objectAtIndex:0]], [self getTakenDateOfAsset:[assetsByTakenDate lastObject]]);
}
@end
