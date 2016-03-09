# NotificationBanner
show custom banner when notifications are received.
#Screen Shots
![Auto Hide Banner](https://github.com/vidhannandi/NotificationBanner/blob/content/Content/autoHide.png "Auto hiding Banner")
![Manual Hide Banner](https://github.com/vidhannandi/NotificationBanner/blob/content/Content/manual.png "Manual hiding Banner")
![Tappable Banner](https://github.com/vidhannandi/NotificationBanner/blob/content/Content/autoHide.png "Tappable Banner")

# Methods
```ObjectiveC
// Methods To show Banner
// Show Tappable Banner
[NotificationBanner showNotificationBannerWithTitle:@"Tappable Banner" message:@"This is a tappable banner."  isAutoHide:false onTap:^{
NSLog(@"Banner Tappped.");
[NotificationBanner hideNotificationBanner];
}];

// Show Manual Hiding banner
[NotificationBanner showNotificationBannerWithTitle:@"Manually Hide Banner" message:@"This is a manual hiding banner."  isAutoHide:false];
// Call "[NotificationBanner hideNotificationBanner];" to hide the banner

// Show auto hiding banner
[NotificationBanner showNotificationBannerWithTitle:@"Auto Hiding Banner" message:@"This is an auto hiding banner."  isAutoHide:true];



// Methods to Hide Banner
// Hide banner
[NotificationBanner hideNotificationBanner];
// Hide banner with completion handler
[NotificationBanner hideNotificationBannerOnComplete:^{
NSLog(@" Banner has been hidden.");
}];
// 
```
