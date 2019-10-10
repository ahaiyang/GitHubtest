@interface XiMJRefreshBackFooter : NSObject
+ (void)loadSupermarketData;
+ (void)setSessionDidBecomeInvalidBlock;
+ (void)cancelImageDownloadTaskForState;
- (void)sdcancelBackgroundImageLoadForState;
- (void)sdremoveImageLoadOperationWithKey;
- (void)sdcancelImageLoadOperationWithKey;
- (void)scrollViewContentOffsetDidChange;
- (void)setMinimumDismissTimeInterval;
@end
