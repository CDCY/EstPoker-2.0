//
//  EPPickPokerViewController.m
//  EstPoker
//
//  Created by chen Yi on 14-3-10.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EPPickPokerViewController.h"
#import "headPortraitView.h"

@interface EPPickPokerViewController ()

@property (strong, nonatomic) IBOutlet UIView *headView;

@end

@implementation EPPickPokerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self headImage]){
        CGRect iconRect = self.headView.bounds;
        headPortraitView *headView = [[headPortraitView alloc]initWithFrame:iconRect];
        headView.headImage = [self headImage];
        [self.headView addSubview:headView];
        headView.backgroundColor = [UIColor clearColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel text]){
        self.cardValue = [button.titleLabel text];;
    }else{
        //如果选中的是coff卡，则设置其值为-1
        self.cardValue = @"-1";
    }
}
@end
