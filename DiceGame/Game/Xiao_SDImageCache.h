@interface XiSDImageCache : NSObject
+ (void)showInfoWithStatus;
+ (void)setSuccessImage;
+ (void)setDefaultAnimationType;
- (void)setDataTaskDidBecomeDownloadTaskBlock;
- (void)setDidFinishEventsForBackgroundURLSessionBlock;
- (void)setIndicatorStyle;
- (void)calculateSizeWithCompletionBlock;
- (void)setTitle;
- (void)setErrorImage;
- (void)setViewForExtension;
- (void)setImages;
@end
