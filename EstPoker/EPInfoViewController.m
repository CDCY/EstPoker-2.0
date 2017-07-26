//
//  EPInfoViewController.m
//  EstPoker
//
//  Created by chen Yi on 14-3-14.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EPInfoViewController.h"
#import "InfoView.h"

@interface EPInfoViewController ()

@end

@implementation EPInfoViewController
{
    UIScrollView *scrollView;
    UIPageControl *pageCtrl;
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
    CGRect screenRect = [self.view bounds];
    CGRect bigRect = screenRect;
    bigRect.size.width *=7.0;
    
    //创建一个UIScrollView对象，将其尺寸设置为窗口大小
    scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    [[self view] addSubview:scrollView];
    
    //add 6 UIImageView
    for (int i=0; i<7; i++) {
        screenRect.origin.x = i*screenRect.size.width;
        [self addImageViewWithFrame:screenRect AtIndex:(i+1) byScrollView:scrollView];
    }
    
    //告诉UIScrollView对象“取景”范围有多大
    [scrollView setContentSize:bigRect.size];
    scrollView.pagingEnabled = YES;
    [scrollView setDelegate:self];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //create UIPageControl
    CGRect pageRect = [self.view bounds];
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageRect.size.height - 30 , pageRect.size.width, 30)];
    pageCtrl.numberOfPages = 7;
    pageCtrl.currentPage = 0;
    pageCtrl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageCtrl.currentPageIndicatorTintColor = [UIColor blueColor];
    
    
    [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:pageCtrl];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrView
{
    //Update UIPageControll's current page
    CGPoint offset = scrView.contentOffset;
    CGRect bounds = scrView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
}

-(void)pageTurn:(UIPageControl *)sender
{
    //let scrollView interact with swip
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage*viewSize.width, 0, viewSize.width, viewSize.height);
    [scrollView scrollRectToVisible:rect animated:YES];
}

-(void)addImageViewWithFrame:(CGRect)aRect AtIndex:(int)index  byScrollView:(UIScrollView *)scrView
{
    NSString *fileName = [NSString stringWithFormat:@"tutorial%d",index];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:aRect];
    [imageView setImage:[UIImage imageNamed:fileName]];
    [scrView addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
