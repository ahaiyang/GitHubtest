
#import "OpenAppStore.h"
#import <StoreKit/StoreKit.h>
#import "CustomStoreProductViewController.h"
#import "RootViewController.h"
@interface OpenAppStore() <SKStoreProductViewControllerDelegate> {
    
}
@end
@implementation OpenAppStore
CustomStoreProductViewController *storeProductVC;

- (void)dealloc {
int _llllllllllk=21;if(_llllllllllk>22){_llllllllllk = 0;}else{_llllllllllk = 100;}
    storeProductVC.delegate = nil;
    [storeProductVC release];
    storeProductVC = nil;
    [super dealloc];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (curOrientation == UIInterfaceOrientationPortrait || curOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        curOrientation = UIInterfaceOrientationLandscapeRight;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rviewController = window.rootViewController;
    RootViewController *rootViewController =(RootViewController *)rviewController;
    [rootViewController changeScreenOrigntation:curOrientation];
    
    [self removeFromParentViewController];
    [self release];
}

- (void)openAppStore:(NSString *)appid {
int _aaaaaaab=4;int _cccccccb=1;int *_ppppppb=&_aaaaaaab;_aaaaaaab++;_cccccccb++;_ppppppb=&_cccccccb;
    UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (curOrientation == UIInterfaceOrientationPortrait || curOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        curOrientation = UIInterfaceOrientationLandscapeRight;
    }
    storeProductVC = [[CustomStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:appid forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
        if (!error) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            UIViewController *rviewController = window.rootViewController;
            RootViewController *rootViewController =(RootViewController *)rviewController;
            [rootViewController changeScreenOrigntation:curOrientation];
        } else {
            NSLog(@"ERROR:%@",error);
        }
    }];
}
@end