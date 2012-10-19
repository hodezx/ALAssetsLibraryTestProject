//
//  ViewController.m
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/19.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *assets;
    ALAssetsLibrary *lib;
    int i;
    NSDate *startDate;
    NSTimer *timer;
    CFAbsoluteTime startTime, stopTime;
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
    stopTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"Used time by CFAbsoluteTime: %f seconds.", stopTime - startTime);
    
    NSDate *timeNow = [[NSDate alloc] init];
    return [timeNow timeIntervalSinceDate:startDate];
}

- (void) showUsedTime: (NSTimeInterval)usedTime;
{
    NSLog(@"This process takes up %g seconds.", usedTime);
    self.statusLabel.text = [NSString stringWithFormat:@"Takes up %.2f secs.", usedTime];
    //self.statusLabel.text = [NSString stringWithFormat:@"Takes up %.2f secs for %d photos", usedTime, [assets count]];
    
    //NSLog(@"There are %d items in assets.", [assets count]);
    //NSLog(@"What class is an asset: %@", [[assets objectAtIndex:1] class]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusLabel.text = @"Press the button.";
    [self.myActivity setHidden:YES];
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
    [super viewDidUnload];
}
- (IBAction)startBtnPressed:(UIButton *)sender {
    [self.myActivity setHidden:NO];
    [self.myActivity startAnimating];
    
    i = 0;
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result != NULL) {
            stop = FALSE;
            NSLog(@"See asset: %@ at %d", result, i++);
            i++;
            //[assets addObject:result];
            //[self showNumOfPic];
        }
    };
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            NSLog(@"start processing the group");
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
        else {
            NSLog(@"end of group");
            [self showNumOfPic];
            [self showUsedTime:[self stopCountingTime]];
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
@end
