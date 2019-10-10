@interface XiAFImageDownloader : NSObject
+ (void)clearDiskOnCompletion;
+ (void)sdsetAnimationImagesWithURLs;
+ (void)cachedImageExistsForURL;
- (void)showWithMaskType;
- (void)mjdecode;
- (void)setForegroundColor;
- (void)setDidFinishEventsForBackgroundURLSessionBlock;
- (void)appendPartWithInputStream;
- (void)setTaskDidReceiveAuthenticationChallengeBlock;
- (void)prefetchURLs;
@end
