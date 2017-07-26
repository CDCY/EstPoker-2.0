//
//  EPRecordViewController.m
//  EstPoker
//
//  Created by chen Yi on 14-3-16.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EPRecordViewController.h"
#import "RecordItemCell.h"
#import "ResultItem.h"
#import "CHCSVParser.h"

@interface EPRecordViewController ()

- (IBAction)shareRecord:(id)sender;

@end

@implementation EPRecordViewController

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
    
    //注册Record Cell的Xib文件
    UINib *nib = [UINib nibWithNibName:@"RecordItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"RecordItemCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}//tableView:numberOfRowsInSection:

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create a UITableViewCell. before it, check whether has reuseable cell or not
    RecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordItemCell"];
    if (!cell) {
        cell = [[RecordItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecordItemCell"];
    }
    
    ResultItem *oneResult = [self.results objectAtIndex:[indexPath row]];
    cell.lbIndex.text = oneResult.index;
    cell.lbValue.text = oneResult.result;
    
    //[[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return cell;
}//tableView:cellForRowAtIndexPath:

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//构造一个dictionary存储
//将结果生成一个文件通过邮件和AirDrop分享出去
- (IBAction)shareRecord:(id)sender {
    
    //将构造的内容存入本地的csv文件
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = @"result.csv";
    NSURL *fileURL = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:documentsDirectory, filename, nil]];
    CHCSVWriter *cvsExport = [[CHCSVWriter alloc] initForWritingToCSVFile:[fileURL path]];
    NSArray *title = [NSArray arrayWithObjects:@"Index",@"Story Points", nil];
    [cvsExport writeLineOfFields:title];
    for (ResultItem *item in self.results) {
        NSArray *outLine = [NSArray arrayWithObjects:item.index,item.result, nil];
        [cvsExport writeLineOfFields:outLine];
        //[cvsExport finishLine];
    }
    [cvsExport closeStream];

    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    
    //屏蔽除了mail和AirDrop的activities
    NSArray *excludedActivities = @[UIActivityTypePostToFacebook,UIActivityTypePostToFlickr,UIActivityTypePostToTwitter,UIActivityTypePostToVimeo,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo,UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToTencentWeibo,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList];
    controller.excludedActivityTypes = excludedActivities;
    
    [self presentViewController:controller animated:YES completion:nil];
}
@end
