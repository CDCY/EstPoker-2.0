//
//  EstimatorItemCell.h
//  EstPoker
//
//  Created by chen Yi on 14-3-4.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPEstimatorViewController.h"
#import "BNRItem.h"

@interface EstimatorItemCell : UITableViewCell <UIImagePickerControllerDelegate,UIActionSheetDelegate>

- (IBAction)takePicture:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) EPEstimatorViewController *parentViewController;
@property (weak, nonatomic) BNRItem *item;

@end
