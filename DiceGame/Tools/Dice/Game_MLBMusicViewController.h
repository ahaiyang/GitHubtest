@interface GaMLBMusicViewController : NSObject
+ (void)updateBounciness;
+ (void)setFont;
+ (void)setSharedImageDownloader;
- (void)configureViewWithKeywords;
- (void)didArchiveLogFile;
- (void)scrollByNumberOfItems;
- (void)willReleaseChildren;
- (void)imagePrefetcher;
- (void)setImageWithURLRequest;
- (void)emptyDataSet;
- (void)showHUDSuccessWithText;
- (void)log;
- (void)loadRequest;
- (void)addFormatter;
- (void)yysetStrikethroughStyle;
- (void)didAddToLogger;
- (void)configureCellWithRelatedMusic;
@end
