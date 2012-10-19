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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.myActivity startAnimating];
    
    i = 0;
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result != NULL) {
            stop = FALSE;
            NSLog(@"See asset: %@", result);
            [assets addObject:result];
            i++;
            //[self showNumOfPic];
        }
    };
        
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group enumerateAssetsUsingBlock:assetEnumerator];
        }
        else {
            [self showNumOfPic];
        }
        
        [self.myActivity stopAnimating];
        [self.myActivity setHidden:YES];
    };
        
    assets = [[NSMutableArray alloc] init];
    lib = [[ALAssetsLibrary alloc] init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
        NSLog(@"Failed: %@", error);
    }];
    
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
    [super viewDidUnload];
}
@end
