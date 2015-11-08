//
//  YQNotificationPoster.h
//  YuanQuan
//
//  Created by 陈颖鹏 on 15/9/13.
//
//

#import <Foundation/Foundation.h>

static NSString * const YQHideTabbarNotification = @"YQHideTabbarNotification";
static NSString * const YQShowTabbarNotification = @"YQShowTabbarNotification";

static NSString * const YQFadeHideNaviBarNotification = @"YQFadeHideNaviBarNotification";
static NSString * const YQFadeShowNaviBarNotification = @"YQFadeShowNaviBarNotification";

static NSString * const YQRefreshFriendListNotification = @"YQRefreshFriendListNotification";
static NSString * const YQDidReceiveRemoteIMMessage = @"DidRecieveUserMessage";

static NSString * const YQDidReceiveDPushMessage    = @"YQDidReceiveDPushMessage";

static NSString * const YQDidReceiveRemoteMessage   = @"YQDidReceiveRemoteMessage";

static NSString * const ShowLookingForCard = @"ShowLookingForCard";

//static NSString * const ShouldShowCard = @"";

@interface YQNotificationPoster : NSObject

/**
 *  隐藏tabbar
 *
 *  @param obj 发送通知的主体
 */
+ (void)postNotification_hideTabbar_withObj:(id)obj;

/**
 *  显示tabbar
 *
 *  @param obj 发送通知的主体
 */
+ (void)postNotification_showTabbar_withObj:(id)obj;

/**
 *  隐藏navBar
 *
 *  @param obj 持有要隐藏的navBar的vc
 */
+ (void)postNotification_fadeHideNaviBar_withObj:(UIViewController *)obj;

/**
 *  显示navBar
 *
 *  @param obj 持有要显示的navBar的vc
 */
+ (void)postNotification_fadeShowNaviBar_withObj:(UIViewController *)obj;

+ (void)postNotification_showLookingForCard:(NSString *)cardImageName;

@end
