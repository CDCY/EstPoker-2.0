//
//  BNRItemStore.m
//  Homepwner
//
//  Created by chen Yi on 6/30/13.
//  Copyright (c) 2013 HaoToo. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"   

@implementation BNRItemStore

-(id) init
{
    self = [super init];
    if (self) {
        /*NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!allItems) {
            allItems = [[NSMutableArray alloc] init];
        }*/
        
        //read Homepwner.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        //set SQLite path
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open Failed" format:@"Reason: %@",[error localizedDescription]];
        }
        
        //create NSManagedObjectContext object
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        //close UNDO function
        [context setUndoManager:nil];
        [self loadAllItems];
    }
    return self;
}//init

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    //NSLog(@"%@",[documentDirectory stringByAppendingPathComponent:@"items.archive"]);
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
    
}//itemArchivePath

-(BOOL)saveChanges
{
    //NSString *path = [self itemArchivePath];
    //return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
    
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error Saving: %@", [err localizedDescription]);
    }
    return successful;
}//saveChanges

+(BNRItemStore *) sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}//sharedStore

-(void)loadAllItems
{
    if(!allItems){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        //NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES];
        
        //[request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@",[error localizedDescription]];
        }
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}//loadAllItems

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}//allocWithZone

-(NSArray *)allItems
{
    return allItems;
}//allItems

-(BNRItem *)createItem
{
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    [allItems addObject:p];
    return p;
}//createItem

-(void)removeItem:(BNRItem *)item
{
    NSString *key = [item imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [context deleteObject:item];
    [allItems removeObjectIdenticalTo:item];
}//removeItem

-(void)moveItemAtIndex:(int)from toIndex:(int)to
{
    //get BNRItem by index:from
    BNRItem *p = [allItems objectAtIndex:from];
    
    //remove p from allItems
    [allItems removeObjectAtIndex:from];
    
    //insert p into index:to
    [allItems insertObject:p atIndex:to];
}//moveItemAtIndex:toIndex:

@end
