//
//  BNRImageStore.m
//  Homepwner
//
//  Created by chen Yi on 7/3/13.
//  Copyright (c) 2013 HaoToo. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}//O-allocWithZone:

-(id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        //register NSNotificationCenter for cleanning cash
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}//O-init

-(void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %lu images out of the cache",(unsigned long)[dictionary count]);
    [dictionary removeAllObjects];
}//clearCache:

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}//imagePathForKey:

+(BNRImageStore *)sharedStore
{
    static BNRImageStore *shareStore = nil;
    if (!shareStore) {
        //create single instance
        shareStore = [[super allocWithZone:NULL] init];
    }
    return shareStore;
}//sharedStore

-(void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    //get path of saving file
    NSString *imagePath = [self imagePathForKey:s];
    
    //get data with JPEG format
    //NSData *d = UIImageJPEGRepresentation(i, 0.5);
    CGSize origImageSize = [i size];
    
    CGRect newRect = CGRectMake(0, 0, 55, 55);
    
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio*origImageSize.width;
    projectRect.size.height = ratio*origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width)/2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height)/2.0;
    
    [i drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSData *d = UIImagePNGRepresentation(smallImage);
    
    UIGraphicsEndImageContext();
    
    //write data into file
    [d writeToFile:imagePath atomically:YES];
}//setImage:forKey:

-(UIImage *)imageForKey:(NSString *)s
{
    UIImage *result = [dictionary objectForKey:s];
    if (!result) {
        //create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        if (result) {
            [dictionary setObject:result forKey:s];
        }else{
            NSLog(@"Error: unable to find %@",[self imagePathForKey:s]);
        }
    }
    return result;
}//imageForKey:

-(void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
    }
    [dictionary removeObjectForKey:s];
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}//deleteImageForKey:

@end
