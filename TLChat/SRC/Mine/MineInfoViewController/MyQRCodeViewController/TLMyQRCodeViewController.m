//
//  TLMyQRCodeViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/4.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLMyQRCodeViewController.h"
#import "TLScanningViewController.h"
#import "TLQRCodeViewController.h"

#define         ACTIONTAG_SHOW_SCANNER      101

@interface TLMyQRCodeViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) TLQRCodeViewController *qrCodeVC;

@end

@implementation TLMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorDefaultBlack]];
    [self.navigationItem setTitle:@"我的二维码"];
    
    [self.view addSubview:self.qrCodeVC.view];
    [self addChildViewController:self.qrCodeVC];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    [self setUser:[TLUserHelper sharedHelper].user];
}

- (void)setUser:(TLUser *)user
{
    _user = user;
    self.qrCodeVC.avatarURL = user.avatarURL;
    self.qrCodeVC.username = self.user.showName;
    self.qrCodeVC.subTitle = self.user.location;
    self.qrCodeVC.qrCode = self.user.userID;
    self.qrCodeVC.introduction = @"扫一扫上面的二维码图案，加我微信";
}

#pragma mark - Delegate -
//MARK: UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTIONTAG_SHOW_SCANNER && buttonIndex == 2) {
        TLScanningViewController *scannerVC = [[TLScanningViewController alloc] init];
        [scannerVC setDisableFunctionBar:YES];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:scannerVC animated:YES];
    }
    else if (buttonIndex == 1) {
        [self.qrCodeVC saveQRCodeToSystemAlbum];
    }
}

#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet;
    if ([self.navigationController findViewController:@"TLScanningViewController"]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"换个样式", @"保存图片", nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"换个样式", @"保存图片", @"扫描二维码", nil];
        actionSheet.tag = ACTIONTAG_SHOW_SCANNER;
    }
    [actionSheet showInView:self.view];
}

#pragma mark - Getter -
- (TLQRCodeViewController *)qrCodeVC
{
    if (_qrCodeVC == nil) {
        _qrCodeVC = [[TLQRCodeViewController alloc] init];
    }
    return _qrCodeVC;
}

@end
