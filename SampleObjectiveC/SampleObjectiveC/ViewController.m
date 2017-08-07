//
//  ViewController.m
//  SampleObjectiveC
//
//  Created by ichise on 2017/07/31.
//

#import "ViewController.h"
@import PageSheetForm;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)click:(id)sender {
    __weak PageSheetFormController *pageSheetFormController = [PageSheetFormController instantiate];
    [pageSheetFormController setTitleText:@"Title"];
    [pageSheetFormController setCancelButtonText:@"Cancel"];
    [pageSheetFormController setSendButtonText:@"Send"];
    [pageSheetFormController setCompletionHandler:^(NSString *sendText) {
        
        if ([sendText length] > 5) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"The number of characters exceeds the upper limit. Please enter within 20 characters." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertController addAction:cancelAction];
            [pageSheetFormController presentViewController:alertController animated:YES completion:nil];

            return;
        }
        
        if ([sendText length] == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"It is not input. Please enter.." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertController addAction:cancelAction];
            [pageSheetFormController presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        [self dismissViewControllerAnimated:true completion:nil];
    }];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoPreviewViewController];
    [navigationController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:pageSheetFormController animated:true completion:nil];
}

@end
