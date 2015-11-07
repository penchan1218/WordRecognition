//
//  CardViewController.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "BaseViewController.h"

@interface CardViewController : BaseViewController

/**
 *  初始化方法
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithName:(NSString *)name;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *english;

@property (nonatomic, weak) UIImageView *imgView_bg;
@property (nonatomic, weak) UIImageView *imgView_staff;

@end
