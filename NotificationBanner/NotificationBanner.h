//
//  NotificationBanner.h
//  NotificationBanner
//
//  Created by Vidhan Nandi on 09/03/16.
//  Copyright © 2016 VNTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationBanner : UIToolbar
{
    void (^ _onTap)();
    
    UIImageView *_imgIcon;
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    UIImageView *_bottomAnchor;
    NSTimer *_timerHideAuto;
}

+ (instancetype)sharedInstance;

+ (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message isAutoHide:(BOOL)isAutoHide;
+ (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message isAutoHide:(BOOL)isAutoHide onTap:(void (^)())onTap;

+ (void)hideNotificationBanner;
+ (void)hideNotificationBannerOnComplete:(void (^)())onComplete;

@end
