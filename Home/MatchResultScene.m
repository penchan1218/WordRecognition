//
//  MatchResultScene.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "MatchResultScene.h"

@implementation MatchResultScene

- (id)initWithSize:(CGSize)size won:(BOOL)won
{
    self = [super initWithSize:size];
    if (self) {
        self.won = won;
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    CGFloat zPosi = 0;
    // emoji
    SKSpriteNode *emoji = [SKSpriteNode spriteNodeWithImageNamed:@"img_smile"];
    emoji.position = CGPointMake(189/2+emoji.size.width/2, SCREEN_HEIGHT-83-emoji.size.height/2);
    emoji.zPosition = zPosi++;
    [self addChild:emoji];
    
    SKSpriteNode *tip = [SKSpriteNode spriteNodeWithImageNamed:self.won?@"img_zhaodui":@"img_zhaocuo"];
    tip.position = CGPointMake(99/2+tip.size.width/2, SCREEN_HEIGHT-322-tip.size.height/2);
    tip.zPosition = zPosi++;
    [self addChild:tip];
    
    SKSpriteNode *home = [SKSpriteNode spriteNodeWithImageNamed:@"icon_home"];
    self.backNode = home;
    home.position = CGPointMake((self.won?296/2:80/2)+home.size.width/2, SCREEN_HEIGHT-1088/2-home.size.height/2);
    home.zPosition = zPosi;
    [self addChild:home];
    
    if (!self.won) {
        SKSpriteNode *retake = [SKSpriteNode spriteNodeWithImageNamed:@"icon_takePhoto"];
        retake.position = CGPointMake(504/2+retake.size.width/2, SCREEN_HEIGHT-1088/2-retake.size.height/2);
        retake.zPosition = zPosi;
        [self addChild:retake];
        self.takePhotoNode = retake;
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node) {
        if (node == self.backNode && self.backBlock) {
            self.backBlock();
        } else if (node == self.takePhotoNode && self.takePhotoBlock) {
            self.takePhotoBlock();
        }
    }
}

@end
