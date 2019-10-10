@interface XiAJHomeCategoryCell : NSObject
+ (void)scaleBy;
+ (void)setQueryStringSerializationWithBlock;
+ (void)setDataTaskDidBecomeDownloadTaskBlock;
- (void)scrollViewContentSizeDidChange;
- (void)addChildVc;
- (void)setCenterOffset;
- (void)setProgressWithDownloadProgressOfTask;
- (void)cleanDiskWithCompletionBlock;
- (void)setInsets;
- (void)cancelBackgroundImageDownloadTaskForState;
- (void)storeImage;
- (void)setForegroundColor;
@end
