//
//  ViewController.m
//  APPLainAlert
//
//  Created by Parti Albert on 2020. 01. 20..
//  Copyright © 2020. Parti Albert. All rights reserved.
//

#import "ViewController.h"
#import "APPlainAlert.h"
@interface ViewController ()<APPlainAlertDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>{
    APPlainAlert * progressAlert;
    float progresss;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

        [APPlainAlert updateAlertPosition:APPlainAlertPositionTop];

    //    [APPlainAlert updateTitleFont:[UIFont fontWithName:@"TrebuchetMS" size:18]];
    //    [APPlainAlert updateSubTitleFont:[UIFont fontWithName:@"TrebuchetMS" size:10]];
    //    [APPlainAlert updateNumberOfAlerts:4];
    //    [APPlainAlert updateAlertColor:[UIColor colorWithWhite:0 alpha:0.5] forType:ViewAlertPanic];
    //    [APPlainAlert updatAPHidingDelay:2.5f];
    //    [APPlainAlert updateAlertIcon:nil forType:ViewAlertInfo];
        // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)successAlert:(id)sender
{
    [APPlainAlert showAlertWithTitle:@"Success!!!!" message:@"Something works! Lorem ipsum-Something works! Lorem ipsum-Something works! Lorem ipsum-!\nLorem\nlorem" type:APPlainAlertSuccess];
    [APPlainAlert updatAPHidingDelay:5.0f];
}

- (IBAction)failureAlert:(id)sender
{
    NSError * error = [[NSError alloc] initWithDomain:@"www.appsyscode.com"
                                                 code:1337
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                                        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
                                                        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)}];
    [APPlainAlert showError:error];
}

- (IBAction)infoAlert:(id)sender
{
    APPlainAlert * APAlert = [[APPlainAlert alloc] initWithTitle:@"Info\n" message:@"This is info message" type:APPlainAlertInfo];
    APAlert.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:15];
    APAlert.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:12];
    APAlert.shouldShowCloseIcon = YES;
    APAlert.messageColorTitle=[UIColor blackColor];
    APAlert.messageColorSubtitle=[UIColor darkGrayColor];
    APAlert.iconColor=[UIColor blackColor];
    APAlert.hiddenDelay=20.f;
    
    [APAlert show];

}

- (IBAction)progressAlert:(id)sender
{
    progressAlert = [[APPlainAlert alloc] initWithTitle:@"Info" message:@"This is info message" type:APPlainAlertProgress];
    progressAlert.titleFont = [UIFont fontWithName:@"TrebuchetMS" size:17];
    progressAlert.subTitleFont = [UIFont fontWithName:@"TrebuchetMS-Italic" size:14];
    progressAlert.shouldShowCloseIcon = YES;
    progressAlert.messageColor=[UIColor clearColor];
    progressAlert.blurBackground=YES;
    progressAlert.messageColorTitle=[UIColor whiteColor];
    progressAlert.blurDarkEffect=YES;
    progressAlert.messageColorSubtitle=[UIColor lightGrayColor];
    progressAlert.iconColor=[UIColor whiteColor];
    progressAlert.hiddenDelay=100.f;
    progressAlert.delegate=self;
    progressAlert.progressTintColor=[UIColor lightGrayColor];
    progressAlert.progressTrackColor=[UIColor redColor];
    progressAlert.iconImage=[UIImage imageNamed:@"alert_download"];
    progressAlert.iconColor=[UIColor systemGreenColor];
    //[progressAlert progressRunCount:100.f];
    [progressAlert show];
    [self downloadfile];

}

- (IBAction)panicAlert:(id)sender
{
    [APPlainAlert showAlertWithTitle:@"Panic!" message:@"Something brokе!" type:APPlainAlertPanic];
    [APPlainAlert updatAPHidingDelay:10.0f];

}

- (IBAction)infoWithSafari:(id)sender
{
    APPlainAlert * APAlert = [[APPlainAlert alloc] initWithTitle:@"Hmm..." message:@"Tap for information" type:APPlainAlertInfo];
    APAlert.action = ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"https://www.appsyscode.com"];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
          [application openURL:URL options:@{}
             completionHandler:^(BOOL success) {
          }];
        }
    };
    APAlert.messageColor = [UIColor purpleColor];
    APAlert.iconImage = nil;
    [APAlert show];
}

- (IBAction)hideAll:(id)sender
{
    [APPlainAlert hideAll:YES];
}
-(void)progressStatus:(float)floatcount{
    
    NSLog(@"Status:%.f",floatcount);
    progressAlert.progressSubtitleString=[NSString stringWithFormat:@"%.f %%",floatcount];
    if (floatcount==100) {
        [progressAlert hidedelayprogress];
    
    }
}
-(void)downloadfile{
    
    NSURL * url = [NSURL URLWithString:@"http://ipv4.download.thinkbroadband.com/50MB.zip"];
      NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
      NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];

      NSURLSessionDownloadTask * downloadTask =[ defaultSession downloadTaskWithURL:url];
      [downloadTask resume];
}

#pragma mark - Delegate Methods
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat prog = (float)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"downloaded %d", (int)(100.0*prog));
    NSString* strint=[NSString stringWithFormat:@"%d %%",(int)(100.0*prog)];
    
    [progressAlert progressView:prog :strint];
    if ((int)(100.0*prog)==100) {
        [progressAlert updateprogressStatusSubtitleString:@"Success!"];
        [progressAlert hidedelayprogress];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error == nil)
    {
        NSLog(@"Download is Succesfull");
    }
    else
        NSLog(@"Error %@",[error userInfo]);
}


@end
