//
//  InfoView.m
//  EstPoker
//
//  Created by chen Yi on 14-3-14.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "InfoView.h"

@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *img = [UIImage imageNamed:@"infoImage"];
    //CGSize sz = [img size];
    //CGRect drawRect = CGRectMake(0, 0, sz.width, sz.height);
    self.ivInfo = [[UIImageView alloc] initWithImage:img];
    [self.ivInfo drawRect:rect];
}


@end
