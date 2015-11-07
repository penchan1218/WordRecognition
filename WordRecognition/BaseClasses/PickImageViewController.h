//
//  PickImageViewController.h
//  Youtu
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *editedImage;

- (void)chooseImage;

- (void)photoLib;
- (void)takePhoto;

@end
