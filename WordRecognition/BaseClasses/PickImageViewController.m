//
//  PickImageViewController.m
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "PickImageViewController.h"

@interface PickImageViewController ()

@end

@implementation PickImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - target - action

- (void)chooseImage
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选取图片" delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册", nil];
    [as showInView:self.view];
}

#pragma mark footbar
//相册
- (void)photoLib
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing            = YES;
    picker.delegate                 = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing            = YES;
    picker.delegate                 = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (editedImage) {
        self.editedImage = editedImage;
    }
}

#pragma mark - action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self photoLib];
    }
}

@end
