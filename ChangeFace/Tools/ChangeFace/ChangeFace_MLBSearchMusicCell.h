@interface ChMLBSearchMusicCell : NSObject
+ (void)emptyDataSetDidTapView;
+ (void)didRollAndArchiveLogFile;
+ (void)mergeValuesForKeysFromModel;
- (void)setQueryStringSerializationWithBlock;
- (void)cleanDiskWithCompletionBlock;
- (void)scrollByOffset;
- (void)cacheHeight;
- (void)swipeViewDidEndScrollingAnimation;
@end
