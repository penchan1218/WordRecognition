//
//  LookforView.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "LookforView.h"

@interface LookforView ()

@property (nonatomic, copy) void (^takePhotoBlock)();
@property (nonatomic, copy) void (^backBlock)();

@end

@implementation LookforView

- (id)initWithStaffImage:(NSString *)staffImage takePhotoBlock:(void (^)())takePhotoBlock backBlock:(void (^)())backBlock
{
    self = [super initWithSize:SCREEN_BOUNDS.size];
    if (self) {
        self.takePhotoBlock = takePhotoBlock;
        self.backBlock = backBlock;
        self.staffImage = staffImage;
        
        [self runAction:[SKAction playSoundFileNamed:@"owngoods.mp3" waitForCompletion:NO]];
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    
    SKSpriteNode *backNode = [[SKSpriteNode alloc] initWithImageNamed:@"icon_fanhui"];
    backNode.position = CGPointMake(50, SCREEN_HEIGHT-45);
    backNode.name = @"back";
    [self addChild:backNode];
    
    SKSpriteNode *staffNode = [[SKSpriteNode alloc] initWithImageNamed:self.staffImage];
//    staffNode.xScale = 3.0;
//    staffNode.yScale = 3.0;
    staffNode.position = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-220);
    staffNode.name = @"staff";
    [self addChild:staffNode];
    
    SKSpriteNode *tipsNode = [[SKSpriteNode alloc] initWithImageNamed:@"img_lookfor"];
    tipsNode.position = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-380);
    staffNode.name = @"tip";
    [self addChild:tipsNode];
    
    SKSpriteNode *takePhoto = [[SKSpriteNode alloc] initWithImageNamed:@"icon_takePhoto"];
    takePhoto.position = CGPointMake(SCREEN_WIDTH/2, 80);
    takePhoto.name = @"takePhoto";
    [self addChild:takePhoto];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    [self checkNode:[self nodeAtPoint:location]];
}

- (void)backAction
{
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)takePhoto
{
    if (self.takePhotoBlock) {
        self.takePhotoBlock();
    }
}

- (void)checkNode:(SKNode *)node
{
    if (!node.name) {
        return ;
    } else if ([node.name isEqualToString:@"back"]) {
        [self backAction];
    } else if ([node.name isEqualToString:@"staff"]) {
        
    } else if ([node.name isEqualToString:@"tip"]) {
        
    } else if ([node.name isEqualToString:@"takePhoto"]) {
        [self takePhoto];
    }
    return ;
}

@end
