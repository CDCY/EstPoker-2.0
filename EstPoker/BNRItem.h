//
//  BNRItem.h
//  Homepwner
//
//  Created by chen Yi on 7/6/13.
//  Copyright (c) 2013 HaoToo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNRItem : NSManagedObject


@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic,strong) UIImage *thumbnail;

-(void)setThumbnailDataFromImage:(UIImage *)image;

@end
