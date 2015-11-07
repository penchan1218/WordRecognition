//
//  YQImagePageViewController.h
//  YuanQuan
//
//  Created by 陈颖鹏 on 15/10/10.
//
//

#import <UIKit/UIKit.h>

@interface YQImagePageViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIToolbar *toolBar;

/**
 *  图片的数量
 */
@property (nonatomic, assign) NSInteger numOfImages;

/**
 *  选中的图片的索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@end
