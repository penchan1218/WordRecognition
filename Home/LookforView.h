//
//  LookforView.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LookforView : SKScene

- (id)initWithStaffImage:(NSString *)staffImage takePhotoBlock:(void (^)())takePhotoBlock backBlock:(void (^)())block;

@property (nonatomic, copy) NSString *staffImage;

@end
