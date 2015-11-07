//
//  CardView.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *english;

@property (nonatomic, weak) UIImageView *imgView_bg;
@property (nonatomic, weak) UIImageView *imgView_staff;

@end
