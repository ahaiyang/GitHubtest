@interface XiAFSecurityPolicy : NSObject
+ (void)removeImageForKey;
+ (void)setProgressWithDownloadProgressOfTask;
+ (void)hidesTabBar;
- (void)loadGoodsData;
- (void)mjencode;
- (void)saveImageToCache;
- (void)storeImageDataToDisk;
- (void)mjsetupIgnoredCodingPropertyNames;
- (void)addReadOnlyCachePath;
- (void)sdsetImageWithPreviousCachedImageWithURL;
- (void)setDownloadTaskDidFinishDownloadingBlock;
- (void)setTaskDidReceiveAuthenticationChallengeBlock;
- (void)mjreferenceReplacedKeyWhenCreatingKeyValues;
@end
