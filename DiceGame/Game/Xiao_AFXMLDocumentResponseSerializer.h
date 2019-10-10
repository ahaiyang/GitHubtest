@interface XiAFXMLDocumentResponseSerializer : NSObject
+ (void)setupNewValueFromOldValue;
+ (void)setOriginKey;
+ (void)cleanDiskWithCompletionBlock;
- (void)setRefreshingTarget;
- (void)setForegroundColor;
- (void)addChildVc;
- (void)calculateSizeWithCompletionBlock;
- (void)saveImageToCache;
- (void)setAnimationImagesWithURLs;
- (void)loadFootBannerData;
- (void)mjencode;
- (void)setShowActivityIndicatorView;
- (void)setProgressWithDownloadProgressOfTask;
- (void)encodeWithCoder;
- (void)setDefaultMaskType;
@end
