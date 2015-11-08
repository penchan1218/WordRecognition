//
//  YQNotificationPoster.m
//  YuanQuan
//
//  Created by 陈颖鹏 on 15/9/13.
//
//

#import "YQNotificationPoster.h"

@implementation YQNotificationPoster

+ (void)postNotification_hideTabbar_withObj:(id)obj {
    UITabBarController *tabbarController = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (tabbarController && [[tabbarController class] isSubclassOfClass:[UITabBarController class]]) {
        CGRect newFrame = tabbarController.tabBar.frame;
        newFrame.origin = CGPointMake(0, SCREEN_HEIGHT);
        [UIView animateWithDuration:0.2 animations:^{
            tabbarController.tabBar.frame = newFrame;
        } completion:^(BOOL finished) {
           [[NSNotificationCenter defaultCenter] postNotificationName:YQHideTabbarNotification object:obj];
        }];
    }
}

+ (void)postNotification_showTabbar_withObj:(id)obj {
    UITabBarController *tabbarController = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (tabbarController && [[tabbarController class] isSubclassOfClass:[UITabBarController class]]) {
        CGRect newFrame = tabbarController.tabBar.frame;
        newFrame.origin = CGPointMake(0, SCREEN_HEIGHT-newFrame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            tabbarController.tabBar.frame = newFrame;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YQShowTabbarNotification object:obj];
        }];
    }
}

+ (void)postNotification_fadeHideNaviBar_withObj:(UIViewController *)obj
{
    UINavigationBar *navBar = obj.navigationController.navigationBar;
    [UIView animateWithDuration:0.2 animations:^{
        navBar.alpha = 0.0;
    }];
}

+ (void)postNotification_fadeShowNaviBar_withObj:(UIViewController *)obj
{
    UINavigationBar *navBar = obj.navigationController.navigationBar;
    [UIView animateWithDuration:0.2 animations:^{
        navBar.alpha = 1.0;
    }];
}

+ (void)postNotification_showLookingForCard:(NSString *)cardImageName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowLookingForCard object:NSDictionaryOfVariableBindings(cardImageName)];
}



@end
