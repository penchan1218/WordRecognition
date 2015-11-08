//
//  MatchResultScene.h
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MatchResultScene : SKScene

@property (nonatomic, assign) BOOL won;

@property (nonatomic, copy) void (^takePhotoBlock)();
@property (nonatomic, copy) void (^backBlock)();

@property (nonatomic, weak) SKSpriteNode *backNode;
@property (nonatomic, weak) SKSpriteNode *takePhotoNode;

- (id)initWithSize:(CGSize)size won:(BOOL)won;

@end
