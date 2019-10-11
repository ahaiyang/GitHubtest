@interface ChSDWebImagePrefetcher : NSObject
+ (void)setIndicatorStyle;
+ (void)pagingScrollViewDidFinishScrolling;
+ (void)popanimationDidReachToValue;
- (void)configureCellWithMusicDetails;
- (void)textView;
- (void)setStickyView;
- (void)willReleaseChildren;
- (void)addTimeCountedByTime;
- (void)didReachToValue;
- (void)setCenterOffset;
- (void)cachedImageExistsForURL;
- (void)emptyDataSetWillDisappear;
- (void)setCountDownTime;
@end
