//
//  ResultItem.m
//  EstPoker
//
//  Created by chen Yi on 14-3-13.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "ResultItem.h"

@implementation ResultItem

-(id)initWithIndex:(NSString *)index result:(NSString *)result
{
    self = [super init];
    self.index = index;
    self.result = result;
    
    return self;
}

-(id)init
{
    return [self initWithIndex:@"1" result:@""];
}

@end
