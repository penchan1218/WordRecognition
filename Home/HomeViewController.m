//
//  HomeViewController.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "HomeViewController.h"

#import "HomeScene.h"
#import "LookforView.h"
#import "CardView.h"

#import "MatchResultScene.h"

#import "YQNotificationPoster.h"
#import "YTOperations.h"

#import "UIImage+Resize.h"

#import <SpriteKit/SpriteKit.h>

@interface HomeViewController ()

@property (nonatomic, weak) SKView *coverView;

@property (nonatomic, weak) UIView *blockView;

@property (nonatomic, copy) NSString *currImageName;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ShowLookingForCard object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *imageName = [note.object objectForKey:@"cardImageName"];
        self.currImageName = imageName;
        
        __weak typeof(self) weakSelf = self;
        LookforView *lookforView = [[LookforView alloc] initWithStaffImage:[[imageName substringToIndex:imageName.length-6] stringByAppendingString:@"big"] takePhotoBlock:^{
            [weakSelf chooseImage];
        } backBlock:^{
            [weakSelf.coverView removeFromSuperview];
        }];
        
        SKView *anotherView = [[SKView alloc] initWithFrame:SCREEN_BOUNDS];
        anotherView.backgroundColor = [UIColor clearColor];
        [anotherView presentScene:lookforView];
        
        [self.view addSubview:anotherView];
        self.coverView = anotherView;
    }];
    
    UIButton *btn_back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30*109/65, 30)];
    btn_back.alpha = 0.5;
    [btn_back setImage:[UIImage imageNamed:@"icon_fanhui"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    btn_back._leftTop = CGPointMake(30, 30);
    [self.view addSubview:btn_back];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
        HomeScene *scene = [HomeScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
        [scene runAction:[SKAction playSoundFileNamed:@"enterhome.mp3" waitForCompletion:NO]];
    }
}

- (void)loadView
{
    SKView *skview = [[SKView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view = skview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    
    if (self.originalImage) {
//        UIView *blockView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
//        blockView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
//        [self.view addSubview:blockView];
//        blockView.userInteractionEnabled = YES;
//        self.blockView = blockView;
        
        CardView *cardView = [[CardView alloc] initWithFrame:CGRectInset(SCREEN_BOUNDS, 0, 0)];
        cardView.imgView_staff.image = self.originalImage;
        [self.view addSubview:cardView];
        self.blockView = cardView;
        
        [YTOperations identifyImage:[UIImage cutImage:self.originalImage size:CGSizeMake(200, 200)] ok:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                YTTagModel *model = [array firstObject];
                cardView.name = model.tag_name;
                
                if ([model.tag_name isEqualToString:[self convertImageName]]) {
                    [self newMatchResultScene:YES];
                } else {
                    [self newMatchResultScene:NO];
                }
            } else {
                [self newMatchResultScene:NO];
            }
        }];
        
//        UIButton *btn = [[UIButton alloc] init];
//        [btn addTarget:self action:@selector(reChooseImage) forControlEvents:UIControlEventTouchUpInside];
//        [btn setImage:[UIImage imageNamed:@"icon_takePhoto"] forState:UIControlStateNormal];
//        [cardView addSubview:btn];
//        [btn sizeToFit];
//        btn.center = CGPointMake(btn._width/2, SCREEN_HEIGHT-btn._height/2);
    }
}

- (void)reChooseImage
{
    [self.blockView removeFromSuperview];
    [self performSelector:@selector(chooseImage) withObject:nil afterDelay:0.1];
}

- (void)newMatchResultScene:(BOOL)won
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverView removeFromSuperview];
        
        SKView *skview = [[SKView alloc] initWithFrame:SCREEN_BOUNDS];
        [self.view addSubview:skview];
        self.coverView = skview;
        
        MatchResultScene *scene = [[MatchResultScene alloc] initWithSize:SCREEN_BOUNDS.size won:won];
        [skview presentScene:scene];
        
        __weak typeof(self) weakSelf = self;
        scene.backBlock = ^ {
            [weakSelf.coverView removeFromSuperview];
            [weakSelf.blockView removeFromSuperview];
        };
        scene.takePhotoBlock = ^ {
            [weakSelf takePhoto];
            [weakSelf.blockView removeFromSuperview];
        };
    });
}

- (NSString *)convertImageName
{
    if (!self.currImageName) {
        return nil;
    }
    
    if ([self.currImageName isEqualToString:@"img_hat_normal"]) {
        return @"帽子";
    } else if ([self.currImageName isEqualToString:@"img_shoe2_normal"]) {
        return @"鞋子";
    } else if ([self.currImageName isEqualToString:@"img_shoe1_normal"]) {
        return @"鞋子";
    } else if ([self.currImageName isEqualToString:@"img_bag_normal"]) {
        return @"包";
    }
    
    return nil;
}


@end
