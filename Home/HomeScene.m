//
//  HomeScene.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "HomeScene.h"

#import "YQNotificationPoster.h"

@interface HomeScene ()

@property (nonatomic, weak) SKSpriteNode *hat;
@property (nonatomic, weak) SKSpriteNode *shoe1;
@property (nonatomic, weak) SKSpriteNode *shoe2;
@property (nonatomic, weak) SKSpriteNode *bag;

@property (nonatomic, strong) NSArray *animatedArray;

@end

@implementation HomeScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        [self setupBG];
        [self setupStaffs];
    }
    
    return self;
}

- (void)setupBG
{
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"img_home_bg"];
    bgNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:bgNode];
}

- (void)setupStaffs
{
    SKSpriteNode *light = [SKSpriteNode spriteNodeWithImageNamed:@"img_light_normal"];
    [self node:light move2Left:275 top:61];
    
    SKSpriteNode *picture1 = [SKSpriteNode spriteNodeWithImageNamed:@"img_picture1_normal"];
    [self node:picture1 move2Left:40 top:275];
    
    SKSpriteNode *picture2 = [SKSpriteNode spriteNodeWithImageNamed:@"img_picture2_normal"];
    [self node:picture2 move2Left:128 top:284];
    
    SKSpriteNode *blacket = [SKSpriteNode spriteNodeWithImageNamed:@"img_tanket_normal"];
    [self node:blacket move2Left:79 top:472];

    SKSpriteNode *sofa = [SKSpriteNode spriteNodeWithImageNamed:@"img_sofa_normal"];
    [self node:sofa move2Left:79 top:418];
    
    SKSpriteNode *bag = [SKSpriteNode spriteNodeWithImageNamed:@"img_bag_gray"];
    bag.name = @"bag";
    self.bag = bag;
    [self node:bag move2Left:183 top:454];
    
    SKSpriteNode *desk1 = [SKSpriteNode spriteNodeWithImageNamed:@"img_desk1_normal"];
    [self node:desk1 move2Left:202 top:495];
    
    SKSpriteNode *shoe2 = [SKSpriteNode spriteNodeWithImageNamed:@"img_shoe2_gray"];
    shoe2.name = @"shoe2";
    self.shoe2 = shoe2;
    [self node:shoe2 move2Left:50 top:693];
    
    SKSpriteNode *shoe1 = [SKSpriteNode spriteNodeWithImageNamed:@"img_shoe1_gray"];
    shoe1.name = @"shoe1";
    self.shoe1 = shoe1;
    [self node:shoe1 move2Left:183 top:695];
    
    SKSpriteNode *desk2 = [SKSpriteNode spriteNodeWithImageNamed:@"img_desk2_normal"];
    [self node:desk2 move2Left:375 top:720];
    
    SKSpriteNode *chair1 = [SKSpriteNode spriteNodeWithImageNamed:@"img_chair1_normal"];
    [self node:chair1 move2Left:385 top:800];
    
    SKSpriteNode *chair2 = [SKSpriteNode spriteNodeWithImageNamed:@"img_chair2_normal"];
    [self node:chair2 move2Left:621 top:782];
    
    SKSpriteNode *tvdesk = [SKSpriteNode spriteNodeWithImageNamed:@"img_tvdesk_normal"];
    [self node:tvdesk move2Left:515 top:464];
    
    SKSpriteNode *hat = [SKSpriteNode spriteNodeWithImageNamed:@"img_hat_gray"];
    hat.name = @"hat";
    self.hat = hat;
    [self node:hat move2Left:524 top:455];
    
    SKSpriteNode *tv = [SKSpriteNode spriteNodeWithImageNamed:@"img_tv_normal"];
    [self node:tv move2Left:604 top:402];
    
    self.animatedArray = @[self.hat, self.shoe1, self.shoe2, self.bag];
//    [self animateRandomly];
}

- (void)animateRandomly
{
    NSInteger index = arc4random()%(self.animatedArray.count);
    if (index >= 0) {
        [self nodeAnimate:self.animatedArray[index]];
    }
    [self performSelector:@selector(animateRandomly) withObject:nil afterDelay:2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKSpriteNode *node = [self checkNode:[self nodeAtPoint:location]];
//    if (node) {
//        [self switchNode:node];
//    }
    if (node) {
        NSString *imageName = [self nodeImageName:node];
        if (imageName) {
            [YQNotificationPoster postNotification_showLookingForCard:imageName];
        }
    }
}

- (void)node:(SKSpriteNode *)node move2Left:(CGFloat)left top:(CGFloat)top
{
    static NSInteger zPosi = 1;
    node.position = CGPointMake(left/2+node.size.width/2,
                                SCREEN_HEIGHT-(top/2+node.size.height/2));
    node.zPosition = zPosi++;
    [self addChild:node];
}

- (void)nodeAnimate:(SKSpriteNode *)node
{
    CGFloat offset = 5.0;
    
    SKAction *actionMoveup = [SKAction moveBy:CGVectorMake(0, offset+3) duration:0.5];
    SKAction *actionMovedown = [SKAction moveBy:CGVectorMake(0, -2*offset) duration:1.0];
    SKAction *actionMoveback = [SKAction moveBy:CGVectorMake(0, offset-3) duration:0.5];
    
    [node runAction:[SKAction sequence:@[actionMoveup, actionMovedown, actionMoveback]]];
}

- (SKSpriteNode *)checkNode:(SKNode *)node
{
    if (!node.name) {
        return nil;
    } else if ([node.name isEqualToString:@"hat"]) {
        return self.hat;
    } else if ([node.name isEqualToString:@"shoe1"]) {
        return self.shoe1;
    } else if ([node.name isEqualToString:@"shoe2"]) {
        return self.shoe2;
    } else if ([node.name isEqualToString:@"bag"]) {
        return self.bag;
    }
    return nil;
}

- (NSString *)nodeImageName:(SKSpriteNode *)node
{
    NSString *imgName = nil;
    if (node == self.hat) {
        imgName = @"img_hat_normal";
    } else if (node == self.shoe2) {
        imgName = @"img_shoe2_normal";
    } else if (node == self.shoe1) {
        imgName = @"img_shoe1_normal";
    } else if (node == self.bag) {
        imgName = @"img_bag_normal";
    }
    return imgName;
}

- (void)switchNode:(SKSpriteNode *)node
{
    NSString *imgName = [self nodeImageName:node];
    if (!imgName) {
        return ;
    }
    
    SKSpriteNode *newNode = [SKSpriteNode spriteNodeWithImageNamed:imgName];
    newNode.position = node.position;
    newNode.zPosition = node.zPosition;
    [self addChild:newNode];
    [node removeFromParent];
}

@end
