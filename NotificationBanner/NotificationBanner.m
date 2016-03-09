//
//  NotificationBanner.m
//  NotificationBanner
//
//  Created by Vidhan Nandi on 09/03/16.
//  Copyright © 2016 VNTech. All rights reserved.
//

#import "NotificationBanner.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - Constant Values

#define Banner_height 64.0f
#define Title_font_size 14.0f
#define Time_font_size 10.0f
#define Message_font_size 13.0f
#define Image_corner_radius 3.0f
#define Image_frame CGRectMake(15.0f, 8.0f, 22.0f, 22.0f)
#define Title_frame CGRectMake(45.0f, 3.0f, [[UIScreen mainScreen] bounds].size.width - 45.0f, 26.0f)
#define Message_height 35.0f
#define Message_frame CGRectMake(45.0f, 25.0f, [[UIScreen mainScreen] bounds].size.width - 45.0f, Message_height)
#define Bottom_anchor_frame CGRectMake(0, self.frame.size.height-10, 35, 4)
#define Bottom_display_duration 3.0f    /// second(s)
#define Bottom_animation_time 0.3f    /// second(s)

@implementation NotificationBanner{
    AVAudioPlayer* myAudio;
}

/// -------------------------------------------------------------------------------------------
#pragma mark - INIT
/// -------------------------------------------------------------------------------------------
+ (instancetype)sharedInstance
{
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, Banner_height)];
    if (self) {
        
        /// Enable orientation tracking
        if (![[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
        
        /// Add Orientation notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationStatusDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        /// createBanner
        [self createBanner];
        
        // PushNotification Sound
        NSString *path = [[NSBundle mainBundle] pathForResource:@"push" ofType:@"wav"];
        
        myAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    }
    
    return self;
}

/// -------------------------------------------------------------------------------------------
#pragma mark - ACTIONS
/// -------------------------------------------------------------------------------------------
- (void)NotificationBannerDidTap:(UIGestureRecognizer *)gesture
{
    if (_onTap) {
        _onTap();
    }
}

/// -------------------------------------------------------------------------------------------
#pragma mark - HELPER
/// -------------------------------------------------------------------------------------------

- (void)createBanner
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.barTintColor = nil;
        self.translucent = YES;
        self.barStyle = UIBarStyleBlack;
        self.alpha = 0.9;
    }
    else {
        [self setTintColor:[UIColor colorWithRed:5 green:31 blue:75 alpha:1]];
    }
    
    self.layer.zPosition = MAXFLOAT;
    self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = NO;
    self.exclusiveTouch = YES;
    
    self.frame = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, Banner_height);
    
    /// Icon
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
    }
    _imgIcon.frame = Image_frame;
    [_imgIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imgIcon.layer setCornerRadius:Image_corner_radius];
    [_imgIcon setClipsToBounds:YES];
    if (![_imgIcon superview]) {
        [self addSubview:_imgIcon];
    }
    
    /// Title
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    _titleLabel.frame = Title_frame;
    [_titleLabel setNumberOfLines:1];
    if (![_titleLabel superview]) {
        [self addSubview:_titleLabel];
    }
    /// Message
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
    }
    _messageLabel.frame = Message_frame;
    [_messageLabel setTextColor:[UIColor whiteColor]];
    [_messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:Message_font_size]];
    [_messageLabel setNumberOfLines:2];
    _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (![_messageLabel superview]) {
        [self addSubview:_messageLabel];
    }
    [self fixLabelMessageSize];
    
    // Bottom anchor
    if (!_bottomAnchor) {
        _bottomAnchor = [[UIImageView alloc] initWithFrame:Bottom_anchor_frame];
    }
    [_bottomAnchor setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.6]];
    [_bottomAnchor setClipsToBounds:YES];
    [_bottomAnchor.layer setCornerRadius:_bottomAnchor.frame.size.height/2];
    [_bottomAnchor setCenter:CGPointMake(self.center.x, _bottomAnchor.center.y)];
    
    if (![_bottomAnchor superview]) {
        [self addSubview:_bottomAnchor];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NotificationBannerDidTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)fixLabelMessageSize
{
    CGSize size = [_messageLabel sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 45.0f, MAXFLOAT)];
    CGRect frame = _messageLabel.frame;
    frame.size.height = (size.height > Message_height ? Message_height : size.height);
    _messageLabel.frame = frame;
}

- (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message isAutoHide:(BOOL)isAutoHide onTap:(void (^)())onTap
{
    /// Invalidate _timerHideAuto
    if (_timerHideAuto) {
        [_timerHideAuto invalidate];
        _timerHideAuto = nil;
    }
    
    /// onTap
    _onTap = onTap;
    
    /// Image
#warning : Default image is app icon change If custom required
    [_imgIcon setImage:[UIImage imageNamed: [[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]  objectAtIndex:0]]];
    
    /// Title
    if (title) {
        [_titleLabel setAttributedText:[self getAttributedTitleWithString:title]];
    }
    else {
        [_titleLabel setText:@""];
    }
    
    /// Message
    if (message) {
        [_messageLabel setText:message];
    }
    else {
        [_messageLabel setText:@""];
    }
    [self fixLabelMessageSize];
    
    /// Prepare frame
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    self.frame = frame;
    
    /// Add to window
    [UIApplication sharedApplication].delegate.window.windowLevel = UIWindowLevelStatusBar;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    // Play Sound
    [myAudio play];
    
    /// Showing animation
    [UIView animateWithDuration:Bottom_animation_time
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y += frame.size.height;
                         self.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    // Schedule to hide
    if (isAutoHide) {
        _timerHideAuto = [NSTimer scheduledTimerWithTimeInterval:Bottom_display_duration
                                                          target:self
                                                        selector:@selector(hideNotificationBanner)
                                                        userInfo:nil
                                                         repeats:NO];
    }
}
- (void)hideNotificationBanner
{
    [self hideNotificationBannerOnComplete:nil];
}
- (void)hideNotificationBannerOnComplete:(void (^)())onComplete
{
    [UIView animateWithDuration:Bottom_animation_time
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.frame;
                         frame.origin.y -= frame.size.height;
                         self.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         [UIApplication sharedApplication].delegate.window.windowLevel = UIWindowLevelNormal;
                         
                         // Invalidate _timerAutoClose
                         if (_timerHideAuto) {
                             [_timerHideAuto invalidate];
                             _timerHideAuto = nil;
                         }
                         
                         if (onComplete) {
                             onComplete();
                         }
                     }];
}

- (NSMutableAttributedString * )getAttributedTitleWithString:(NSString *)str{
    NSMutableString *titleString = [NSMutableString stringWithFormat:@"%@  now",str];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:titleString];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,str.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:Title_font_size] range:NSMakeRange(0,str.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange((str.length),(string.length- str.length))];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:Time_font_size] range:NSMakeRange((str.length),(string.length- str.length))];
    return string;
}
/// -------------------------------------------------------------------------------------------
#pragma mark - ORIENTATION NOTIFICATION
/// -------------------------------------------------------------------------------------------
- (void)orientationStatusDidChange:(NSNotification *)notification
{
    [self createBanner];
}

/// -------------------------------------------------------------------------------------------
#pragma mark - UTILITY FUNCS
/// -------------------------------------------------------------------------------------------
+ (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message
{
    [NotificationBanner showNotificationBannerWithTitle:title message:message isAutoHide:YES onTap:nil];
}
+ (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message isAutoHide:(BOOL)isAutoHide
{
    [NotificationBanner showNotificationBannerWithTitle:title message:message isAutoHide:isAutoHide onTap:nil];
}
+ (void)showNotificationBannerWithTitle:(NSString *)title message:(NSString *)message isAutoHide:(BOOL)isAutoHide onTap:(void (^)())onTap
{
    [[NotificationBanner sharedInstance] showNotificationBannerWithTitle:title message:message isAutoHide:isAutoHide onTap:onTap];
}

+ (void)hideNotificationBanner
{
    [NotificationBanner hideNotificationBannerOnComplete:nil];
}
+ (void)hideNotificationBannerOnComplete:(void (^)())onComplete
{
    [[NotificationBanner sharedInstance] hideNotificationBannerOnComplete:onComplete];
}





@end
