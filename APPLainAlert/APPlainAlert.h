#import <UIKit/UIKit.h>

@protocol APPlainAlertDelegate <NSObject>

-(void)progressStatus:(float)floatcount;
-(void)closeButtonAction;

@end
typedef enum : NSUInteger {
    APPlainAlertError,
    APPlainAlertSuccess,
    APPlainAlertInfo,
    APPlainAlertProgress,
    APPlainAlertPanic,
    APPlainAlertUnknown
} APPlainAlertType;

typedef enum : NSUInteger {
    APPlainAlertPositionBottom = 0,
    APPlainAlertPositionTop
} APPlainAlertPosition;


typedef enum : NSInteger {
    APUseClassValue = -1,
    APNo = 0,
    APYes = 1
} APBoolean;

typedef enum : NSInteger {
    APBlurNO = 0,
    APBlurYES = 1
} APBoolBlur;
typedef void (^ ActionBlock)(void);


@interface APPlainAlert : UIViewController{
    UIView * infoView;
    NSInteger numberOfAlerts;
    NSUInteger X_POSITION;
    NSUInteger X_POSITION_ENDMINUS;
    BOOL progressenabled;
    NSTimer *urlTimer;
    UILabel * progressstitleLabel;


}
@property (nonatomic, strong) id<APPlainAlertDelegate> delegate;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) NSTimer *prgtimer;
@property (nonatomic, strong) ActionBlock action;
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIFont * subTitleFont;
@property (nonatomic, strong) UIFont * progressstitleLabelFont;

@property (nonatomic, strong) UIColor * messageColor;
@property (nonatomic, strong) UIColor * iconColor;
@property (nonatomic, strong) UIColor * messageColorTitle;
@property (nonatomic, strong) UIColor * messageColorSubtitle;
@property (nonatomic, strong) UIColor * progressTintColor;
@property (nonatomic, strong) UIColor * progressTrackColor;
@property float hiddenDelay;
@property BOOL blurDarkEffect;
@property (nonatomic, strong) UIImage * iconImage;

@property (nonatomic, copy) NSString * titleString;

@property (nonatomic, copy) NSString * subtitleString;
@property (nonatomic, copy) NSString * progressSubtitleString;

/*!
 * @brief Tap on alert bAPaviour; If value is equal to APUseClassValue(-1), then will used value defined by +updateShouldHideOnTap:
 *                                If value is equal to APNo(0), then alert dismissed only after delay, or by calling -hide: or +hideAll:
 *                                If value is equal to APYes(1), then alert would be dismissed even if +updateShouldHideOnTap: was setted to NO
 */
@property (nonatomic, assign) APBoolean shouldHideOnTap;
/*!
 * @brief Close icon visibility; If value is equal to APUseClassValue(-1), then would be used value defined by +updateShouldShowCloseIcon:
 *                               If value is equal to APNo(0), then close icon would not be shown
 *                               If value is equal to APYes(1), then close icon would be shown even if +updateShouldShowCloseIcon: was setted to NO
 */
@property (nonatomic, assign) APBoolean shouldShowCloseIcon;
@property (nonatomic, assign) APBoolBlur blurBackground;

-(void)updateprogressStatusSubtitleString:(NSString*)string;
-(void)progressView:(float)progress :(NSString*)progressStatus;
-(void)progressRunCount:(float)floatcout;

+ (instancetype)showError:(NSError *)error;
+ (instancetype)showDomainError:(NSError *)error;
+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message type:(APPlainAlertType)type;

+(void)hideAll:(BOOL)animated;

- (id)initWithTitle:(NSString *)title message:(NSString *)message type:(APPlainAlertType)type;
- (void)show;
- (void)hide;
- (void)hidedelayprogress;
+ (void)updateNumberOfAlerts:(NSInteger)numberOfAlerts;
+ (void)updatAPHidingDelay:(float)delay;
+ (void)updateTitleFont:(UIFont *)titleFont;
+ (void)updateSubTitleFont:(UIFont *)subtitleFont;
+ (void)updateProgressTitleFont:(UIFont *)prgtitleFont;
+ (void)updateTitleCOLOR:(UIColor *)titleColor;
+ (void)updateSubTitleCOLOR:(UIColor *)stitleColor;
+ (void)updateProgressTintCOLOR:(UIColor *)tintColor;
+ (void)updateProgressTrackCOLOR:(UIColor *)trackColor;
+ (void)updateAlertPosition:(APPlainAlertPosition)viewPosition;
+ (void)updateAlertColor:(UIColor *)color forType:(APPlainAlertType)type;
+ (void)updateAlertIcon:(UIImage *)image forType:(APPlainAlertType)type;
+ (void)updateShouldHideOnTap:(BOOL)hide;
+ (void)updateShouldShowCloseIcon:(BOOL)show;
+ (void)updateBlurBackground:(BOOL)blur;
+ (void)updateBlurDarkEffect:(BOOL)effect;
@end
