@interface XiAJAnimationRefreshHeader : NSObject
+ (void)showErrorWithStatus;
+ (void)storeImageDataToDisk;
+ (void)setIndicatorStyle;
- (void)setDefaultStyle;
- (void)setSharedImageDownloader;
- (void)showSuccessWithStatus;
- (void)setBackgroundColor;
- (void)setCenterOffset;
- (void)setSuspended;
- (void)prefetchURLs;
- (void)setProgressWithUploadProgressOfTask;
- (void)setAuthorizationHeaderFieldWithUsername;
@end
