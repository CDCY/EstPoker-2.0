//
//  ResultItemCell.h
//  EstPoker
//
//  Created by chen Yi on 14-3-12.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIImageView *selectPoker;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end
