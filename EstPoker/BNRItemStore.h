//
//  BNRItemStore.h
//  Homepwner
//
//  Created by chen Yi on 6/30/13.
//  Copyright (c) 2013 HaoToo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
}

+(BNRItemStore *) sharedStore;

-(NSArray *)allItems;
-(BNRItem *)createItem;
-(void)removeItem:(BNRItem *)item;
-(void)moveItemAtIndex:(int)from toIndex:(int)to;
-(NSString *)itemArchivePath;
-(BOOL)saveChanges;
-(void)loadAllItems;

@end
