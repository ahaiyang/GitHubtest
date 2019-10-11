@interface ChMLBSearchAuthorCell : NSObject
+ (void)setProgressWithDownloadProgressOfTask;
+ (void)prefetchURLs;
+ (void)configureViewForReadDetailsWithReadType;
- (void)addImage;
- (void)requestMovieDetailsById;
- (void)requestEssayRelatedsById;
- (void)moveMagnifier;
- (void)cycleScrollView;
- (void)popaddAnimation;
- (void)configureCellWithRelatedMusic;
- (void)requestMusicPraiseAndTimeCommentsWithItemId;
- (void)configureCellWithSerialDetails;
- (void)pagingScrollViewDidFinishScrolling;
- (void)setAnimatingWithStateOfTask;
- (void)yysetTextRubyAnnotation;
- (void)popanimationDidReachToValue;
- (void)configureViewWithKeywords;
@end
