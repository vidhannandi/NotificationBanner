//
//  ViewController.m
//  NotificationViewDemo
//
//  Created by Vidhan Nandi on 09/03/16.
//  Copyright © 2016 VNTech. All rights reserved.
//

#import "ViewController.h"
#import "NotificationBanner.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Action
- (IBAction)showbanner:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [NotificationBanner showNotificationBannerWithTitle:@"Tappable Banner" message:@"This is a tappable banner."  isAutoHide:false onTap:^{
                NSLog(@"Banner Tappped.");
                [NotificationBanner hideNotificationBanner];
            }];
        }
            break;
        case 2:{
            [NotificationBanner showNotificationBannerWithTitle:@"Manual Hide Banner" message:@"This is a manual hiding banner."  isAutoHide:false];
        }
            break;
        default:
        {
            [NotificationBanner showNotificationBannerWithTitle:@"Auto Hide Banner" message:@"This is an auto hiding banner."  isAutoHide:true];
        }
            break;
    }
}


@end
