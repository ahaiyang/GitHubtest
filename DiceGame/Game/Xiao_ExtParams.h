@interface XiExtParams : NSObject
+ (void)scrollViewContentOffsetDidChange;
+ (void)setDataTaskWillCacheResponseBlock;
+ (void)setBackgroundColor;
- (void)moveBy;
- (void)setCenterOffset;
- (void)setAnimationImagesWithURLs;
- (void)setDownloadTaskDidResumeBlock;
- (void)setBackgroundImageWithURL;
- (void)appendPartWithHeaders;
@end
