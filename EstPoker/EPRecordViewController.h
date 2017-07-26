//
//  EPRecordViewController.h
//  EstPoker
//
//  Created by chen Yi on 14-3-16.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPRecordViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *results;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
