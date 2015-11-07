//
//  ViewController.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "ViewController.h"

#import "YTOperations.h"

#import "CardViewController.h"
#import "LookThroughCardViewController.h"

#import "UIImage+Resize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CardViewController *cardvc = [[CardViewController alloc] initWithName:@"汉字"];
//    [self addChildViewController:cardvc];
//    [self.view addSubview:cardvc.view];
//    [cardvc didMoveToParentViewController:self];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    LookThroughCardViewController *vc = [[LookThroughCardViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    if (!self.originalImage) {
        [self chooseImage];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];

    if (self.originalImage) {
        CardViewController *cardvc = [[CardViewController alloc] init];
        [self addChildViewController:cardvc];
        [self.view addSubview:cardvc.view];
        [cardvc didMoveToParentViewController:self];
        
        [YTOperations identifyImage:[UIImage cutImage:self.originalImage size:CGSizeMake(200, 200)] ok:^(NSArray *array, NSError *error) {
            NSLog(@"array: %@", array);
            if (array.count > 0) {
                YTTagModel *model = [array firstObject];
                cardvc.name = model.tag_name;
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cardvc.imgView_staff.image = self.originalImage;
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
