//
//  LookThroughCardViewController.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "BaseViewController.h"

@interface LookThroughCardViewController : BaseViewController <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scroll_bg;
@property (nonatomic, weak) UIScrollView *scroll_preview;

@end
