//
//  EstimatorItemCell.m
//  EstPoker
//
//  Created by chen Yi on 14-3-4.
//  Copyright (c) 2014年 Chenyi. All rights reserved.
//

#import "EstimatorItemCell.h"
#import "headPortraitView.h"
#import "BNRImageStore.h"

@implementation EstimatorItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)takePicture:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Take Photo"
                                  otherButtonTitles:@"Select Photo",nil];
    [actionSheet showInView:self.contentView];
    [actionSheet resignFirstResponder];
}//take picture

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing=YES;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])//照相不可用
        {
            if (buttonIndex==0)
            {
                picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        else
        {
            if (buttonIndex==0)
            {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                picker.showsCameraControls=TRUE;
            }
            else if (buttonIndex==1)
            {
                picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        [self.parentViewController presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [self.item imageKey];
    
    if (oldKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    UIImage *headImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //create a CFUUID
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    //translate defined CFUUID to string
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [self.item setImageKey:key];
    [[BNRImageStore sharedStore] setImage:headImg forKey:[self.item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    //show head portrait in cell
    CGRect iconRect = self.headView.bounds;
    headPortraitView *headView = [[headPortraitView alloc]initWithFrame:iconRect];
    headView.headImage = headImg;
    [self.headView addSubview:headView];
    headView.backgroundColor = [UIColor clearColor];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
