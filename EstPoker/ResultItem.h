//
//  ResultItem.h
//  EstPoker
//
//  Created by chen Yi on 14-3-13.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultItem : NSObject

@property NSString *index;
@property NSString *result;

-(id)initWithIndex:(NSString *)index result:(NSString *)result;

@end
