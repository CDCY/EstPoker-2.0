//
//  BNRItem.m
//  Homepwner
//
//  Created by chen Yi on 7/6/13.
//  Copyright (c) 2013 HaoToo. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem


@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;

-(void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
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
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    UIGraphicsEndImageContext();
}//setThumbnailDataFromImage:

-(void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:[self thumbnailData]];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}//awakeFromFetch

-(void)awakeFromInsert
{
    [super awakeFromInsert];
}//awakeFromInsert

@end
