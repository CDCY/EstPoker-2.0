//
//  headPortraitView.m
//  PokerMeeting
//
//  Created by chen Yi on 14-1-8.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "headPortraitView.h"

@implementation headPortraitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = self.bounds;
    
    CGPoint aCenter;
    aCenter.x = bounds.origin.x + bounds.size.width/2.0;
    aCenter.y = bounds.origin.y + bounds.size.height/2.0;
    float maxRadius = hypot(aCenter.x, aCenter.y)/1.6;
    
    CGContextSaveGState(ctx);
    
    CGSize offset = CGSizeMake(0, 0);
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    CGContextSetShadowWithColor(ctx, offset, 1.0, color);
    
    CGContextSetLineWidth(ctx, 2);
    [[UIColor lightGrayColor] setStroke];
    CGContextAddArc(ctx, aCenter.x, aCenter.y, maxRadius, 0.0, M_PI*2.0, YES);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
    
    CGContextAddArc(ctx, aCenter.x, aCenter.y, maxRadius, 0.0, M_PI*2.0, YES);
    CGContextClip(ctx);
    
    UIImage *aIcon = self.headImage;
    [aIcon drawInRect:bounds];
    
    UIGraphicsEndImageContext(); 
}

@end
