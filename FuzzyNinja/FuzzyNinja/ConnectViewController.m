//
//  ConnectViewController.m
//  FuzzyNinja
//
//  Created by stranbird on 13-5-18.
//  Copyright (c) 2013年 stranbird. All rights reserved.
//

#import "ConnectViewController.h"
#import "ControlViewController.h"
#import <ZXingObjC.h>

#import "MyClient.h"

@interface ConnectViewController ()<ZXCaptureDelegate>

@property (nonatomic, retain) ZXCapture* capture;

@end

@implementation ConnectViewController

@synthesize capture;

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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.title = @"扫一扫";
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.delegate = self;
    self.capture.rotation = -90.0f;
    self.capture.camera = self.capture.back;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    NSLog(@"1");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)displayForResult:(ZXResult*)result {
    NSString *formatString;
    switch (result.barcodeFormat) {
        case kBarcodeFormatAztec:
            formatString = @"Aztec";
            break;
            
        case kBarcodeFormatCodabar:
            formatString = @"CODABAR";
            break;
            
        case kBarcodeFormatCode39:
            formatString = @"Code 39";
            break;
            
        case kBarcodeFormatCode93:
            formatString = @"Code 93";
            break;
            
        case kBarcodeFormatCode128:
            formatString = @"Code 128";
            break;
            
        case kBarcodeFormatDataMatrix:
            formatString = @"Data Matrix";
            break;
            
        case kBarcodeFormatEan8:
            formatString = @"EAN-8";
            break;
            
        case kBarcodeFormatEan13:
            formatString = @"EAN-13";
            break;
            
        case kBarcodeFormatITF:
            formatString = @"ITF";
            break;
            
        case kBarcodeFormatPDF417:
            formatString = @"PDF417";
            break;
            
        case kBarcodeFormatQRCode:
            formatString = @"QR Code";
            break;
            
        case kBarcodeFormatRSS14:
            formatString = @"RSS 14";
            break;
            
        case kBarcodeFormatRSSExpanded:
            formatString = @"RSS Expanded";
            break;
            
        case kBarcodeFormatUPCA:
            formatString = @"UPCA";
            break;
            
        case kBarcodeFormatUPCE:
            formatString = @"UPCE";
            break;
            
        case kBarcodeFormatUPCEANExtension:
            formatString = @"UPC/EAN extension";
            break;
            
        default:
            formatString = @"Unknown";
            break;
    }
    
    return [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
}

- (void)captureResult:(ZXCapture *)theCapture result:(ZXResult *)result {
    if (result) {
        // We got a result. Display information about the result onscreen.
//        [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:[self displayForResult:result] waitUntilDone:YES];
        NSString *code = [self displayForResult:result];
        NSLog(@"%@", [self displayForResult:result]);
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [theCapture stop];
        
        [[MyClient sharedClient] postPath:@"/players/2222/connect" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"1");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"2");
        }];
        
//        ControlViewController *controlViewController = [[ControlViewController alloc] initWithNibName:@"ControlViewController" bundle:nil];
//        [self.navigationController pushViewController:controlViewController animated:YES];
    }
}

- (void)captureSize:(ZXCapture *)capture width:(NSNumber *)width height:(NSNumber *)height {
    
}

@end