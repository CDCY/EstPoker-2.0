//
//  EPEstimatorViewController.m
//  EstPoker
//
//  Created by chen Yi on 14-3-4.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EPEstimatorViewController.h"
#import "EstimatorItemCell.h"
#import "PulsingHaloLayer.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "BNRItem.h"
#import "headPortraitView.h"
#import "EPPlanningViewController.h"
#import "Planner.h"

@interface EPEstimatorViewController ()

- (IBAction)addNewEstimator:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bbiStart;

@end

@implementation EPEstimatorViewController
{
    PulsingHaloLayer *halo;
    NSMutableArray *midResults;
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
    //注册Estimator Cell的Xib文件
    UINib *nib = [UINib nibWithNibName:@"EstimatorItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"EstimatorItemCell"];
    
    //如果没有Estimator，在tutorial Bar Button Item上显示脉冲动画,并且Start设置为disable
    if ([[[BNRItemStore sharedStore] allItems] count] == 0) {
        halo = [PulsingHaloLayer layer];
        [self setPulsing:YES];
        self.bbiStart.enabled = NO;
    }else{
        self.bbiStart.enabled = YES;
    }
    
    //加载title image
    [self drawTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}//tableView:numberOfRowsInSection:

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a UITableViewCell. before it, check whether has reuseable cell or not
    EstimatorItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EstimatorItemCell"];
    if (!cell){
      cell = [[EstimatorItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EstimatorItemCell"];
    }
    
    //加载Estimator Cell
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    cell.item = p;
    cell.parentViewController = self;
    //取出数据文件中取出头像传递给Cell
    NSString *imageKey = [p imageKey];
    if (imageKey)
    {
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        if (imageToDisplay) {
            //show head portrait in cell
            CGRect iconRect = cell.headView.bounds;
            headPortraitView *headView = [[headPortraitView alloc]initWithFrame:iconRect];
            headView.headImage = imageToDisplay;
            [cell.headView addSubview:headView];
            headView.backgroundColor = [UIColor clearColor];
        }
    }else{
        //如果没有取到头像，则检查headView上有几个subview，并将最上层的view删除掉
        NSArray *sub = [cell.headView subviews];
        if ([sub count]>=2) {
            for (int i=[sub count];i>1; i--) {
                [sub[i-1] removeFromSuperview];
            }
        }
    }
    //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return cell;
}//tableView:cellForRowAtIndexPath:

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

//用户点击添加Estimator
- (IBAction)addNewEstimator:(id)sender
{
   
    //关闭在tutorial上的脉冲动画
    [self setPulsing:NO];
    self.bbiStart.enabled = YES;
    
    //添加新Estimator
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationBottom];
    [[self tableView] scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//删除Estimator
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        if (items.count == 1) {//如果是最后一个Estimator，则删掉后将Start设置为enable
            self.bbiStart.enabled = NO;
            [self setPulsing:YES];
        }
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        //delete table view row
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(IBAction)unwindToEstimator:(UIStoryboardSegue *)segue
{
    //在PlanningVC点击Cancel之后回到当前VC要做的工作
    EPPlanningViewController *planningVC = [segue sourceViewController];
    midResults = planningVC.results;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to cancel current planning?" delegate:self cancelButtonTitle:@"No,let's go on!" destructiveButtonTitle:@"Yes, I am sure!" otherButtonTitles:nil];
    [actionSheet showInView:planningVC.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        midResults = nil;
        return;
    }else{
        [self performSegueWithIdentifier:@"Planning" sender:nil];
    }
}

//从CoreData中加载一个Planner对象的数组，然后传递给PlanningVC
-(NSMutableArray *)loadPlanners
{
    NSMutableArray *allPlanners = [NSMutableArray arrayWithCapacity:40];
    
    for (int i=0;i<[[[BNRItemStore sharedStore] allItems] count];i++)
    {
        //初始化planner
        BNRItem *item = [[BNRItemStore sharedStore] allItems][i];
        NSString *key = [item imageKey];
        Planner *onePlanner = [[Planner alloc] init];
        onePlanner.row = i;
        onePlanner.isSelected = NO;
        onePlanner.selectedValue = @"-2";
        if (key)
        {
            UIImage *image = [[BNRImageStore sharedStore] imageForKey:key];
            if (image){
                onePlanner.headImage = image;
            }else{
                UIImage *imgHead = [UIImage imageNamed:@"defaultHead"];
                onePlanner.headImage = imgHead;
            }
        }else{
            UIImage *imgHead = [UIImage imageNamed:@"defaultHead"];
            onePlanner.headImage = imgHead;
        }
        [allPlanners addObject:onePlanner];
    }
    return allPlanners;
}

//在tutorial上显示脉冲动画
-(void)setPulsing:(BOOL) isShow
{
    if (isShow){
        //引入脉冲动画
        halo.radius = 26.0;
        halo.position = CGPointMake(self.navigationController.view.bounds.origin.x+28, self.navigationController.view.bounds.origin.y+41);
        UIColor *color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        halo.backgroundColor = color.CGColor;
        [self.navigationController.view.layer addSublayer:halo];
    }else{
        [halo removeFromSuperlayer];
    }
}

//在NavigationController正中画出title
-(void)drawTitle
{
    UIImage *titleImage = [UIImage imageNamed:@"title2"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
    
    CGRect rect = CGRectMake(115, 28, 90, 30);
    
    titleImageView.frame = rect;
    
    [self.navigationController.view addSubview:titleImageView];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Planning"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        EPPlanningViewController *planningVC = [navigationController viewControllers][0];
        //调用loadPlanners，传递给planningVC的planners数组
        planningVC.planners = [self loadPlanners];
        if (midResults) {
            planningVC.results = midResults;
        }
    }
    
    if ([segue.identifier isEqualToString:@"Info"]) {
        //关闭在tutorial上的脉冲动画
        [self setPulsing:NO];
    }
}

@end
