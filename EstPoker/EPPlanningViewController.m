//
//  EPPlanningViewController.m
//  EstPoker
//
//  Created by chen Yi on 14-3-8.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EPPlanningViewController.h"
#import "EPPickPokerViewController.h"
#import "EPResultViewController.h"
#import "EPRecordViewController.h"
#import "headPortraitView.h"
#import "PlanningItemCell.h"
#import "Planner.h"
#import "ResultItem.h"
#import "PulsingHaloLayer.h"

@interface EPPlanningViewController ()

@end

@implementation EPPlanningViewController
{
    int selectedIndex;//记录用户点击的行号
    PulsingHaloLayer *halo;
}


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
    //注册Planning Cell的Xib文件
    UINib *nib = [UINib nibWithNibName:@"PlanningItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"PlanningItemCell"];
    
    self.uncoverBarItem.enabled = FALSE;
    if (self.results == nil) {
        self.results = [NSMutableArray arrayWithCapacity:40];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%d", self.results.count + 1];
    }
    halo = [PulsingHaloLayer layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.planners count];
}//tableView:numberOfRowsInSection:

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a UITableViewCell. before it, check whether has reuseable cell or not
    PlanningItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanningItemCell"];
    if (!cell) {
        cell = [[PlanningItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlanningItemCell"];
    }
    
    Planner *onePlanner = [self.planners objectAtIndex:[indexPath row]];
    if (onePlanner.isSelected){
        UIImage *img = [UIImage imageNamed:@"selectedPoker"];
        [cell.poker setImage:img];
    }else{
        UIImage *img = [UIImage imageNamed:@"Pokers"];
        [cell.poker setImage:img];
    }
    
    UIImage *plannerHead = onePlanner.headImage;
    if (plannerHead){
        CGRect iconRect = cell.headView.bounds;
        headPortraitView *headView = [[headPortraitView alloc]initWithFrame:iconRect];
        headView.headImage = plannerHead;
        [cell.headView addSubview:headView];
        headView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}//tableView:cellForRowAtIndexPath:

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = (int)[indexPath row];
    //如果已经做出了选择，就退出
    Planner *onePlanner = [self.planners objectAtIndex:selectedIndex];
    if (onePlanner.isSelected == YES) {
        return;
    }
    [self performSegueWithIdentifier:@"PickPoker" sender:nil];
    
}//tableView:didSelectRowAtIndexPath

//从PickPokerVC选择了poker之后调用
-(IBAction)unwindToPlanning:(UIStoryboardSegue *)segue
{
    EPPickPokerViewController *pickPokerVC = segue.sourceViewController;
    Planner *onePlanner = [self.planners objectAtIndex:selectedIndex];
    onePlanner.selectedValue = pickPokerVC.cardValue;
    onePlanner.isSelected = YES;
    [[self tableView] reloadData];
    
    //如果所有用户选择了poker并确认，激活uncoverButton
    if ([self areAllPlannersSelected]) {
        self.uncoverBarItem.enabled = YES;
        [self setPulsing:YES];
    }
}

//点击refresh Bar Button Item，清空所有的值并设置Poker为未选择状态
- (IBAction)refreshPlanning:(id)sender
{
    [self setPulsing:NO];
    [self refreshAll];
}

//设置所有planners到初始状态
-(void)refreshAll
{
    for (Planner *plan in self.planners) {
        plan.selectedValue = @"-2";
        plan.isSelected = NO;
    }
    self.uncoverBarItem.enabled = NO;
    [[self tableView] reloadData];
}

//判断是不是所有的用户都做出了自己的选择
-(BOOL)areAllPlannersSelected
{
    BOOL isSelected = YES;
    for (Planner *plan in self.planners) {
        isSelected *= plan.isSelected;
    }
    return isSelected;
}

//当用户在ResultVC中按下Cancel或Done则回到本函数处理
-(IBAction)unwindToResult:(UIStoryboardSegue *)segue
{
    EPResultViewController *resultVC = [segue sourceViewController];
    
    //删掉脉冲动画
    [self setPulsing:NO];
    
    //如果按下Cancel，清空planner，story index保持不变
    if (!resultVC.finalResult.text) {
        [self refreshAll];
    }else{
        //如果按下Done，将ResultVC中的finalResult中的值存入ResultItem，清空planner，story index加1
        ResultItem *rt = [[ResultItem alloc] initWithIndex:self.navigationItem.title result:resultVC.finalResult.text];
        [self.results addObject:rt];
        int indexInt = [self.navigationItem.title intValue];
        self.navigationItem.title = [NSString stringWithFormat:@"%d",indexInt+1];
        [self refreshAll];
    }
}

//在button上显示脉冲动画
-(void)setPulsing:(BOOL) isShow
{
    if (isShow){
        //引入脉冲动画
        halo.radius = 30.0;
        halo.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-22);
        UIColor *color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        halo.backgroundColor = color.CGColor;
        [self.view.layer addSublayer:halo];
    }else{
        [halo removeFromSuperlayer];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"PickPoker"]) {
        EPPickPokerViewController *pickPokerVC = segue.destinationViewController;
        pickPokerVC.headImage = [[self.planners objectAtIndex:selectedIndex] headImage];
    }
    
    if ([segue.identifier isEqualToString:@"showResult"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        EPResultViewController *resultVC = [navigationController viewControllers][0];
        resultVC.planners = self.planners;
        resultVC.navigationItem.title = self.navigationItem.title;
    }
    
    if ([segue.identifier isEqualToString:@"showRecord"]) {
        EPRecordViewController *recordVC = segue.destinationViewController;
        recordVC.results = self.results;
    }
}


@end
