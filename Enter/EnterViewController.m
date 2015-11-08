//
//  EnterViewController.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "EnterViewController.h"
#import "HomeViewController.h"
#import "CardViewController.h"
#import "YQImagePageViewController.h"

#import "YTOperations.h"

#import "UIImage+Resize.h"

@interface EnterViewController ()

@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action 

- (IBAction)gotoMyHome
{
    [self.navigationController pushViewController:[[HomeViewController alloc] init] animated:YES];
}

- (IBAction)gotoMyLib
{
    YQImagePageViewController *imagePageVC = [[YQImagePageViewController alloc] init];
    imagePageVC.selectedIndex = 0;
    imagePageVC.numOfImages = 7;
    [self.navigationController pushViewController:imagePageVC animated:YES];
}

- (IBAction)gotoMyTaking
{
    [self chooseImage];
}

#pragma mark - override

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // use self.originalImage;
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    
    if (self.originalImage) {
        CardViewController *cardvc = [[CardViewController alloc] init];
        [self.navigationController pushViewController:cardvc animated:YES];
        
        [YTOperations identifyImage:[UIImage cutImage:self.originalImage size:CGSizeMake(200, 200)] ok:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                YTTagModel *model = [array firstObject];
                cardvc.name = model.tag_name;
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cardvc.imgView_staff.image = self.originalImage;
        });
    }
}

@end
