@interface XiAFHTTPSessionManager : NSObject
+ (void)setRefreshingTarget;
+ (void)setReachabilityStatusChangeBlock;
+ (void)setTaskDidReceiveAuthenticationChallengeBlock;
- (void)showErrorWithStatus;
- (void)setOffset;
- (void)addSupermarkProductToShopCar;
- (void)cancelTaskForImageDownloadReceipt;
- (void)calculateSizeWithCompletionBlock;
- (void)loadFootBannerData;
- (void)setDataTaskDidBecomeDownloadTaskBlock;
- (void)cachedImageExistsForURL;
@end
