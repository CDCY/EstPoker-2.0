//
//  EPResultViewController.h
//  EstPoker
//
//  Created by chen Yi on 14-3-12.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//
//  功能描述：本VC的主要功能是显示本轮估算各个参与者选择的结果，参与者就结果进行讨论，最终确认一个估算值。

#import <UIKit/UIKit.h>

@interface EPResultViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *finalResult;
@property (nonatomic,strong)NSMutableArray *planners;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
