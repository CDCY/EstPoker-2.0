//
//  Planner.h
//  EstPoker
//
//  Created by chen Yi on 14-3-11.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Planner : NSObject

@property (nonatomic)int row;
@property (nonatomic,copy)UIImage *headImage;
@property (nonatomic)BOOL isSelected;
@property (nonatomic)NSString *selectedValue;

@end
