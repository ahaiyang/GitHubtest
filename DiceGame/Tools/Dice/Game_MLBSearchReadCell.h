@interface GaMLBSearchReadCell : NSObject
+ (void)configureViewForReadDetailsWithReadType;
+ (void)clearDiskOnCompletion;
+ (void)throttleBandwidthWithPacketSize;
- (void)cancelImageDownloadTaskForState;
- (void)appendPartWithFileData;
- (void)appendDescription;
- (void)willReleaseObject;
- (void)setDataTaskDidReceiveDataBlock;
- (void)changeActivityState;
- (void)insertPagesAtIndexes;
- (void)swipeView;
- (void)cacheHeight;
@end
