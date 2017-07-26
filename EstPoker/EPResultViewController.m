//
//  EPResultViewController.m
//  EstPoker
//
//  Created by chen Yi on 14-3-12.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EPResultViewController.h"
#import "ResultItemCell.h"
#import "headPortraitView.h"
#import "Planner.h"

@interface EPResultViewController ()

@property (strong, nonatomic) IBOutlet UISlider *resultSlider;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bbiDone;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bbiCancel;

- (IBAction)sliderMoved:(id)sender;

@end

@implementation EPResultViewController

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
    // 注册Result Cell的Xib
    UINib *nib = [UINib nibWithNibName:@"ResultItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"ResultItemCell"];
    
    //计算平均值，设置label和slider
    int result = [self meanValue];
    self.resultSlider.value = result;
    self.finalResult.text = [NSString stringWithFormat:@"%d",result];
    //[self configureSlider];
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
    ResultItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultItemCell"];
    if (!cell) {
        cell = [[ResultItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResultItemCell"];
    }
    
    Planner *onePlanner = [self.planners objectAtIndex:[indexPath row]];
    NSString *value = onePlanner.selectedValue;
    if (![value isEqualToString:@"-1"]) {
        [cell.valueLabel setText:value];
    }else{
        UIImage *coffCard = [UIImage imageNamed:@"coffCard"];
        [cell.selectPoker setImage:coffCard];
        [cell.valueLabel setText:@""];
    }
    UIImage *plannerHead = onePlanner.headImage;
    if (plannerHead){
        //show head portrait in cell
        CGRect iconRect = cell.headView.bounds;
        headPortraitView *headView = [[headPortraitView alloc]initWithFrame:iconRect];
        headView.headImage = plannerHead;
        [cell.headView addSubview:headView];
        headView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}//tableView:cellForRowAtIndexPath:

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // 如果用户按下Cancel，说明用户选择放弃此次估算选择重做。如果用户按下Done，则说明用户确认此次确定的估算值，然后回到PlanningVC
    if (sender == self.bbiCancel) {
        self.finalResult.text = nil;
    }
}

- (IBAction)sliderMoved:(UISlider *)slider
{
    self.finalResult.text = [NSString stringWithFormat:@"%d",(int)slider.value];
}

//计算平均值
-(int)meanValue
{
    int mv = 0;
    int div = (int)[self.planners count];
    for (Planner *plan in self.planners)
    {
        if ([plan.selectedValue isEqualToString:@"?"]||[plan.selectedValue isEqualToString:@"-1"]) {
            div--;
        }else{
            mv += [plan.selectedValue intValue];
        }
    }
    if (div!=0) {
        mv = mv/div;
    }
    return mv;
}

//美化slider
-(void)configureSlider
{
    UIImage *thumbImageNormal = [UIImage imageNamed:@"SliderThumb-Normal"];
    [self.resultSlider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    
    UIImage *thumbImageHighlighted = [UIImage imageNamed:@"SliderThumb-Highlighted"];
    [self.resultSlider setThumbImage:thumbImageHighlighted forState:UIControlStateHighlighted];
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"SliderTrackLeft"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [self.resultSlider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    UIImage *trackRightImage = [[UIImage imageNamed:@"SliderTrackRight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
    [self.resultSlider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
}
@end
