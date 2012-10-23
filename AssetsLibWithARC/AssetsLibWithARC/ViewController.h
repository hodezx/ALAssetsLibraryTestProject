//
//  ViewController.h
//  AssetsLibWithARC
//
//  Created by William Ho on 12/10/19.
//  Copyright (c) 2012年 William Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *myActivity;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)startBtnPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)sortByCDBtnPressed:(UIButton *)sender;
- (IBAction)sortByTDBtnPressed:(UIButton *)sender;

@end
