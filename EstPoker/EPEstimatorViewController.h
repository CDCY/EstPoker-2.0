//
//  EPEstimatorViewController.h
//  EstPoker
//
//  Created by chen Yi on 14-3-4.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//
// 功能描述：本VC主要功能为添加和删除Estimator，并启动估算过程

#import <UIKit/UIKit.h>

@interface EPEstimatorViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
