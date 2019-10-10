#include "Game_MLBUtilities.h"
#include "Game_DDFileLogger.h"
#include "Game_POPAnimation.h"
#include "Game_NYTPhotosOverlayView.h"
#include "Game_MLBMovieDetailsViewController.h"
#include "Game_MLBReadDetailsView.h"
#include "Game_SDImageCache.h"
#include "Game_POPDecayAnimation.h"
#include "Game_FBObjectiveCGraphElement.h"
#include "Game_MLBMovieStory.h"
#include "Game_MLBSearchReadCell.h"
#include "Game_MLBUserHomeViewController.h"
#include "Game_YYTextUnarchiver.h"
#include "Game_AFNetworkReachabilityManager.h"
#include "Game_AFImageDownloadReceipt.h"
#include "Game_TPKeyboardAvoidingCollectionView.h"
#include "Game_MLBPreviousViewController.h"
#include "Game_YYTextShadow.h"
#include "Game_FLWeakProxy.h"
#include "Game_AFXMLParserResponseSerializer.h"
#include "Game_DDContextWhitelistFilterLogFormatter.h"
#include "Game_AFHTTPSessionManager.h"
#include "Game_MLBCommentListViewController.h"
#include "Game_AFHTTPResponseSerializer.h"
#include "Game_MLBTopTenArtical.h"
#include "Game_MTLModel.h"
#include "Game_MLBReadDetailsAuthorInfoCell.h"
#include "Game_MLeaksMessenger.h"
#include "Game_TADotView.h"
#include "Game_YYTextMagnifier.h"
#include "Game_MLBReadPreviousCell.h"
#include "Game_MLBIntroduceViewController.h"
#include "Game_MLBReadBaseCell.h"
#include "Game_MLBCommonFooterView.h"
#include "Game_AFImageDownloader.h"
#include "Game_NYTPhotoViewController.h"
#include "Game_SDWebImageDownloader.h"
#include "Game_MLBReadEssay.h"
#include "Game_NYTPhotosDataSource.h"
#include "Game_YYImageFrame.h"
#include "Game_YYImageDecoder.h"
#include "Game_NYTPhotosViewController.h"
#include "Game_MLBMusicControlView.h"
#include "Game_YYTextEffectWindow.h"
#include "Game_YYTextKeyboardManager.h"
#include "Game_PopMenu.h"
#include "Game_MLBMusicViewController.h"
#include "Game_MBBarProgressView.h"
#include "Game_FBNodeEnumerator.h"
#include "Game_YYLabel.h"
#include "Game_MLBSearchRead.h"
#include "Game_TPKeyboardAvoidingScrollView.h"
#include "Game_DDASLLogCapture.h"
#include "Game_AFCompoundResponseSerializer.h"
#include "Game_YYTextBinding.h"
#include "Game_MASConstraint.h"
void register_all_oc_files(){
  GaMLBUtilities* m_GaMLBUtilities = [GaMLBUtilities new];
  [m_GaMLBUtilities release];
  m_GaMLBUtilities = nil;
  GaDDFileLogger* m_GaDDFileLogger = [GaDDFileLogger new];
  [m_GaDDFileLogger release];
  m_GaDDFileLogger = nil;
  GaPOPAnimation* m_GaPOPAnimation = [GaPOPAnimation new];
  [m_GaPOPAnimation release];
  m_GaPOPAnimation = nil;
  GaNYTPhotosOverlayView* m_GaNYTPhotosOverlayView = [GaNYTPhotosOverlayView new];
  [m_GaNYTPhotosOverlayView release];
  m_GaNYTPhotosOverlayView = nil;
  GaMLBMovieDetailsViewController* m_GaMLBMovieDetailsViewController = [GaMLBMovieDetailsViewController new];
  [m_GaMLBMovieDetailsViewController release];
  m_GaMLBMovieDetailsViewController = nil;
  GaMLBReadDetailsView* m_GaMLBReadDetailsView = [GaMLBReadDetailsView new];
  [m_GaMLBReadDetailsView release];
  m_GaMLBReadDetailsView = nil;
  GaSDImageCache* m_GaSDImageCache = [GaSDImageCache new];
  [m_GaSDImageCache release];
  m_GaSDImageCache = nil;
  GaPOPDecayAnimation* m_GaPOPDecayAnimation = [GaPOPDecayAnimation new];
  [m_GaPOPDecayAnimation release];
  m_GaPOPDecayAnimation = nil;
  GaFBObjectiveCGraphElement* m_GaFBObjectiveCGraphElement = [GaFBObjectiveCGraphElement new];
  [m_GaFBObjectiveCGraphElement release];
  m_GaFBObjectiveCGraphElement = nil;
  GaMLBMovieStory* m_GaMLBMovieStory = [GaMLBMovieStory new];
  [m_GaMLBMovieStory release];
  m_GaMLBMovieStory = nil;
  GaMLBSearchReadCell* m_GaMLBSearchReadCell = [GaMLBSearchReadCell new];
  [m_GaMLBSearchReadCell release];
  m_GaMLBSearchReadCell = nil;
  GaMLBUserHomeViewController* m_GaMLBUserHomeViewController = [GaMLBUserHomeViewController new];
  [m_GaMLBUserHomeViewController release];
  m_GaMLBUserHomeViewController = nil;
  GaYYTextUnarchiver* m_GaYYTextUnarchiver = [GaYYTextUnarchiver new];
  [m_GaYYTextUnarchiver release];
  m_GaYYTextUnarchiver = nil;
  GaAFNetworkReachabilityManager* m_GaAFNetworkReachabilityManager = [GaAFNetworkReachabilityManager new];
  [m_GaAFNetworkReachabilityManager release];
  m_GaAFNetworkReachabilityManager = nil;
  GaAFImageDownloadReceipt* m_GaAFImageDownloadReceipt = [GaAFImageDownloadReceipt new];
  [m_GaAFImageDownloadReceipt release];
  m_GaAFImageDownloadReceipt = nil;
  GaTPKeyboardAvoidingCollectionView* m_GaTPKeyboardAvoidingCollectionView = [GaTPKeyboardAvoidingCollectionView new];
  [m_GaTPKeyboardAvoidingCollectionView release];
  m_GaTPKeyboardAvoidingCollectionView = nil;
  GaMLBPreviousViewController* m_GaMLBPreviousViewController = [GaMLBPreviousViewController new];
  [m_GaMLBPreviousViewController release];
  m_GaMLBPreviousViewController = nil;
  GaYYTextShadow* m_GaYYTextShadow = [GaYYTextShadow new];
  [m_GaYYTextShadow release];
  m_GaYYTextShadow = nil;
  GaFLWeakProxy* m_GaFLWeakProxy = [GaFLWeakProxy new];
  [m_GaFLWeakProxy release];
  m_GaFLWeakProxy = nil;
  GaAFXMLParserResponseSerializer* m_GaAFXMLParserResponseSerializer = [GaAFXMLParserResponseSerializer new];
  [m_GaAFXMLParserResponseSerializer release];
  m_GaAFXMLParserResponseSerializer = nil;
  GaDDContextWhitelistFilterLogFormatter* m_GaDDContextWhitelistFilterLogFormatter = [GaDDContextWhitelistFilterLogFormatter new];
  [m_GaDDContextWhitelistFilterLogFormatter release];
  m_GaDDContextWhitelistFilterLogFormatter = nil;
  GaAFHTTPSessionManager* m_GaAFHTTPSessionManager = [GaAFHTTPSessionManager new];
  [m_GaAFHTTPSessionManager release];
  m_GaAFHTTPSessionManager = nil;
  GaMLBCommentListViewController* m_GaMLBCommentListViewController = [GaMLBCommentListViewController new];
  [m_GaMLBCommentListViewController release];
  m_GaMLBCommentListViewController = nil;
  GaAFHTTPResponseSerializer* m_GaAFHTTPResponseSerializer = [GaAFHTTPResponseSerializer new];
  [m_GaAFHTTPResponseSerializer release];
  m_GaAFHTTPResponseSerializer = nil;
  GaMLBTopTenArtical* m_GaMLBTopTenArtical = [GaMLBTopTenArtical new];
  [m_GaMLBTopTenArtical release];
  m_GaMLBTopTenArtical = nil;
  GaMTLModel* m_GaMTLModel = [GaMTLModel new];
  [m_GaMTLModel release];
  m_GaMTLModel = nil;
  GaMLBReadDetailsAuthorInfoCell* m_GaMLBReadDetailsAuthorInfoCell = [GaMLBReadDetailsAuthorInfoCell new];
  [m_GaMLBReadDetailsAuthorInfoCell release];
  m_GaMLBReadDetailsAuthorInfoCell = nil;
  GaMLeaksMessenger* m_GaMLeaksMessenger = [GaMLeaksMessenger new];
  [m_GaMLeaksMessenger release];
  m_GaMLeaksMessenger = nil;
  GaTADotView* m_GaTADotView = [GaTADotView new];
  [m_GaTADotView release];
  m_GaTADotView = nil;
  GaYYTextMagnifier* m_GaYYTextMagnifier = [GaYYTextMagnifier new];
  [m_GaYYTextMagnifier release];
  m_GaYYTextMagnifier = nil;
  GaMLBReadPreviousCell* m_GaMLBReadPreviousCell = [GaMLBReadPreviousCell new];
  [m_GaMLBReadPreviousCell release];
  m_GaMLBReadPreviousCell = nil;
  GaMLBIntroduceViewController* m_GaMLBIntroduceViewController = [GaMLBIntroduceViewController new];
  [m_GaMLBIntroduceViewController release];
  m_GaMLBIntroduceViewController = nil;
  GaMLBReadBaseCell* m_GaMLBReadBaseCell = [GaMLBReadBaseCell new];
  [m_GaMLBReadBaseCell release];
  m_GaMLBReadBaseCell = nil;
  GaMLBCommonFooterView* m_GaMLBCommonFooterView = [GaMLBCommonFooterView new];
  [m_GaMLBCommonFooterView release];
  m_GaMLBCommonFooterView = nil;
  GaAFImageDownloader* m_GaAFImageDownloader = [GaAFImageDownloader new];
  [m_GaAFImageDownloader release];
  m_GaAFImageDownloader = nil;
  GaNYTPhotoViewController* m_GaNYTPhotoViewController = [GaNYTPhotoViewController new];
  [m_GaNYTPhotoViewController release];
  m_GaNYTPhotoViewController = nil;
  GaSDWebImageDownloader* m_GaSDWebImageDownloader = [GaSDWebImageDownloader new];
  [m_GaSDWebImageDownloader release];
  m_GaSDWebImageDownloader = nil;
  GaMLBReadEssay* m_GaMLBReadEssay = [GaMLBReadEssay new];
  [m_GaMLBReadEssay release];
  m_GaMLBReadEssay = nil;
  GaNYTPhotosDataSource* m_GaNYTPhotosDataSource = [GaNYTPhotosDataSource new];
  [m_GaNYTPhotosDataSource release];
  m_GaNYTPhotosDataSource = nil;
  GaYYImageFrame* m_GaYYImageFrame = [GaYYImageFrame new];
  [m_GaYYImageFrame release];
  m_GaYYImageFrame = nil;
  GaYYImageDecoder* m_GaYYImageDecoder = [GaYYImageDecoder new];
  [m_GaYYImageDecoder release];
  m_GaYYImageDecoder = nil;
  GaNYTPhotosViewController* m_GaNYTPhotosViewController = [GaNYTPhotosViewController new];
  [m_GaNYTPhotosViewController release];
  m_GaNYTPhotosViewController = nil;
  GaMLBMusicControlView* m_GaMLBMusicControlView = [GaMLBMusicControlView new];
  [m_GaMLBMusicControlView release];
  m_GaMLBMusicControlView = nil;
  GaYYTextEffectWindow* m_GaYYTextEffectWindow = [GaYYTextEffectWindow new];
  [m_GaYYTextEffectWindow release];
  m_GaYYTextEffectWindow = nil;
  GaYYTextKeyboardManager* m_GaYYTextKeyboardManager = [GaYYTextKeyboardManager new];
  [m_GaYYTextKeyboardManager release];
  m_GaYYTextKeyboardManager = nil;
  GaPopMenu* m_GaPopMenu = [GaPopMenu new];
  [m_GaPopMenu release];
  m_GaPopMenu = nil;
  GaMLBMusicViewController* m_GaMLBMusicViewController = [GaMLBMusicViewController new];
  [m_GaMLBMusicViewController release];
  m_GaMLBMusicViewController = nil;
  GaMBBarProgressView* m_GaMBBarProgressView = [GaMBBarProgressView new];
  [m_GaMBBarProgressView release];
  m_GaMBBarProgressView = nil;
  GaFBNodeEnumerator* m_GaFBNodeEnumerator = [GaFBNodeEnumerator new];
  [m_GaFBNodeEnumerator release];
  m_GaFBNodeEnumerator = nil;
  GaYYLabel* m_GaYYLabel = [GaYYLabel new];
  [m_GaYYLabel release];
  m_GaYYLabel = nil;
  GaMLBSearchRead* m_GaMLBSearchRead = [GaMLBSearchRead new];
  [m_GaMLBSearchRead release];
  m_GaMLBSearchRead = nil;
  GaTPKeyboardAvoidingScrollView* m_GaTPKeyboardAvoidingScrollView = [GaTPKeyboardAvoidingScrollView new];
  [m_GaTPKeyboardAvoidingScrollView release];
  m_GaTPKeyboardAvoidingScrollView = nil;
  GaDDASLLogCapture* m_GaDDASLLogCapture = [GaDDASLLogCapture new];
  [m_GaDDASLLogCapture release];
  m_GaDDASLLogCapture = nil;
  GaAFCompoundResponseSerializer* m_GaAFCompoundResponseSerializer = [GaAFCompoundResponseSerializer new];
  [m_GaAFCompoundResponseSerializer release];
  m_GaAFCompoundResponseSerializer = nil;
  GaYYTextBinding* m_GaYYTextBinding = [GaYYTextBinding new];
  [m_GaYYTextBinding release];
  m_GaYYTextBinding = nil;
  GaMASConstraint* m_GaMASConstraint = [GaMASConstraint new];
  [m_GaMASConstraint release];
  m_GaMASConstraint = nil;
}
