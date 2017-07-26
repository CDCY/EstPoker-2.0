//
//  EPPlanningViewController.h
//  EstPoker
//
//  Created by chen Yi on 14-3-8.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//
//  功能描述：本VC的主要功能是提供用户轮流选择Poker的界面，refresh功能用户清空选择结果，在当前的story下重新选择。当所有用户确认选择完成Poker以后，翻牌按钮可用，点击可用查看结果进入resultVC。显示结果按钮打开估算结果显示界面查看结果。

#import <UIKit/UIKit.h>

@interface EPPlanningViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *planners;
@property (nonatomic,strong)NSMutableArray *results;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uncoverBarItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resultBarItem;

- (IBAction)refreshPlanning:(id)sender;

@end
