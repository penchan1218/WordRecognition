//
//  HomeScene.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "HomeScene.h"

@implementation HomeScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // background image
        SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"img_home_bg"];
        bgNode.position = CGPointMake(size.width/2, size.height/2);
        [self addChild:bgNode];
    }
    
    return self;
}

@end
