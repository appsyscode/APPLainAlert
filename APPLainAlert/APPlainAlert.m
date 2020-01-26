#import "APPlainAlert.h"


#define APDEFAULT_TITLE_FONT [UIFont systemFontOfSize:15]
#define APDEFAULT_SUBTITLE_FONT [UIFont systemFontOfSize:12]
#define APDEFAULT_PROGRESSTITLE_FONT [UIFont boldSystemFontOfSize:14]
#define APDEFAULT_TITLE_COLOR [UIColor colorWithRed:0.988235 green:1.000000 blue:1.000000 alpha:1.0F]
#define APDEFAULT_SUBTITLE_COLOR [UIColor colorWithRed:0.988235 green:1.000000 blue:1.000000 alpha:1.0F]
#define APDEFAULT_PROGRESSTINT_COLOR [UIColor colorWithRed:0.200000 green:0.592157 blue:0.996078 alpha:1.0F]
#define APDEFAULT_PROGRESSTRACK_COLOR [UIColor colorWithRed:0.909804 green:0.913725 blue:0.909804 alpha:0.7F]
#define APDEFAULT_MAX_ALERTS_NUMBER 3
#define APDEFAULT_HIDING_DELAY 4
#define INFOVIEWHEIGT 90
#define INFOVIEW_X_POSITION 5
#define INFOVIEW_X_ENDMINUS 10
#define APPOSITIONFORALERT(i) (_APAlertPosition == APPlainAlertPositionBottom)?screenSize.height - INFOVIEWHEIGT * (i + 1) - 1.5 * (i):INFOVIEWHEIGT * (i) + 1.5 * (i)

static NSInteger _APNumberOfVisibleAlerts = APDEFAULT_MAX_ALERTS_NUMBER;
static APPlainAlertPosition _APAlertPosition = APPlainAlertPositionBottom;
static float _APHidingDelay = APDEFAULT_HIDING_DELAY;
static UIFont * _APTitleFont = nil;
static UIFont * _APSubTitleFont = nil;
static UIFont * _APProgressTitleFont = nil;
static UIColor * _APTitleColor = nil;
static UIColor * _APSubTitleColor = nil;
static UIColor * _APProgressTintColor = nil;
static UIColor * _APProgressTrackColor = nil;

static BOOL _APShouldHideOnTap = YES;
static BOOL _APShouldShowCloseIcon = YES;
static BOOL _APBlurBackground = NO;
static BOOL _APBlurDarkEffect = NO;

static NSMutableDictionary * _APColorsDictionary = nil;
static NSMutableDictionary * _APIconsDictionary = nil;
static NSMutableDictionary * _APProgressDictionary = nil;


@implementation APPlainAlert
{
    CGSize screenSize;
    APPlainAlertType _alertType;
    BOOL _iconSetted;
}

static NSMutableArray * currentAlertArray = nil;

+ (instancetype)showError:(NSError *)error
{
    return [self showAlertWithTitle:@"Error" message:error.localizedDescription type:APPlainAlertError];
}


+ (instancetype)showDomainError:(NSError *)error
{
    return [self showAlertWithTitle:error.domain message:error.localizedDescription type:APPlainAlertError];
}


+ (instancetype)showAlertWithTitle:(NSString *)title message:(NSString *)message type:(APPlainAlertType)type
{
    APPlainAlert * alert = [[APPlainAlert alloc] initWithTitle:title message:message type:type];
    [alert show];
    return alert;
}

+(void)hideAll:(BOOL)animated
{
    for (APPlainAlert * alert in currentAlertArray)
    {
        [alert hide:@(animated)];
    }
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message type:(APPlainAlertType)type;
{
    self = [super init];
    if (self)
    {
        self.titleString = title;
        self.subtitleString = message;
        _shouldShowCloseIcon = -1;
        _shouldHideOnTap = -1;
        if (!currentAlertArray)
        {
            currentAlertArray = [NSMutableArray new];
        }
        [APPlainAlert  updateColorsDictionary];
        [APPlainAlert  updateIconsDictionary];
        [APPlainAlert  updateProgressDictionary];
        _alertType = type;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self)
    {
        if (!currentAlertArray)
        {
            currentAlertArray = [NSMutableArray new];
        }
        [APPlainAlert updateColorsDictionary];
        [APPlainAlert updateIconsDictionary];
        [APPlainAlert updateProgressDictionary];
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // what ever you want to prepare
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self handleInterfaceOrientation];
    }];
}

- (void)handleInterfaceOrientation {
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        // Landscape
        X_POSITION=INFOVIEW_X_POSITION+10;
        X_POSITION_ENDMINUS=INFOVIEW_X_ENDMINUS+30;
    } else {
        // Portrait
        X_POSITION=INFOVIEW_X_POSITION;
        X_POSITION_ENDMINUS=INFOVIEW_X_ENDMINUS;
    }
}
+ (void)updateProgressDictionary
{
    if (!_APProgressDictionary)
    {
        _APProgressDictionary = [@{ @(APPlainAlertError) : @NO,
                                  @(APPlainAlertSuccess) : @NO,
                                  @(APPlainAlertInfo) :  @NO,
                                  @(APPlainAlertProgress) : @YES,
                                  @(APPlainAlertPanic) : @NO
                                  } mutableCopy];
    }
}

+ (void)updateColorsDictionary
{
    if (!_APColorsDictionary)
    {
        _APColorsDictionary = [@{ @(APPlainAlertError) : [UIColor colorWithRed:1.000000 green:0.572549 blue:0.129412 alpha:1.0F],
                                  @(APPlainAlertSuccess) : [UIColor colorWithRed:0.333333 green:0.717647 blue:0.282353 alpha:1.0F],
                                  @(APPlainAlertInfo) :  [UIColor colorWithRed:0.286275 green:0.760784 blue:0.996078 alpha:1.0F],
                                  @(APPlainAlertProgress) : [UIColor colorWithRed:0.317647 green:0.423529 blue:0.721569 alpha:1.0F],
                                  @(APPlainAlertPanic) :[UIColor colorWithRed:0.878431 green:0.203922 blue:0.058824 alpha:1.0F]
                                  } mutableCopy];
    }
}

+ (void)updateIconsDictionary
{
    if (!_APIconsDictionary)
    {
        _APIconsDictionary = [@{ @(APPlainAlertError) : [UIImage imageNamed:@"alert_warning"],
                                 @(APPlainAlertSuccess) : [UIImage imageNamed:@"alert_success"],
                                 @(APPlainAlertInfo) :  [UIImage imageNamed:@"alert_info"],
                                 @(APPlainAlertProgress) :  [UIImage imageNamed:@"alert_info"],
                                 @(APPlainAlertPanic) :[UIImage imageNamed:@"alert_error"]
                                 } mutableCopy];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    progressenabled=NO;
    //_blurDarkEffect=_APBlurDarkEffect;
    
    if (!_APTitleFont)
    {
        _APTitleFont = APDEFAULT_TITLE_FONT;
    }
    if (!_APSubTitleFont)
    {
        _APSubTitleFont = APDEFAULT_SUBTITLE_FONT;
    }
    if (!_APProgressTitleFont)
    {
        _APProgressTitleFont = APDEFAULT_PROGRESSTITLE_FONT;
    }
    if (!_APTitleColor)
    {
        _APTitleColor = APDEFAULT_TITLE_COLOR;
    }
    if (!_APSubTitleColor)
    {
        _APSubTitleColor = APDEFAULT_SUBTITLE_COLOR;
    }
    if (!_APProgressTintColor)
    {
        _APProgressTintColor = APDEFAULT_PROGRESSTINT_COLOR;
    }
    if (!_APProgressTrackColor)
    {
        _APProgressTrackColor = APDEFAULT_PROGRESSTRACK_COLOR;
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    screenSize = [UIScreen mainScreen].bounds.size;
    self.view.frame = CGRectMake(X_POSITION, (_APAlertPosition)?-INFOVIEWHEIGT:screenSize.height, screenSize.width-X_POSITION_ENDMINUS , INFOVIEWHEIGT);
    self.view.layer.masksToBounds = NO;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // portrait
        X_POSITION=INFOVIEW_X_POSITION;
        X_POSITION_ENDMINUS=INFOVIEW_X_ENDMINUS;
        
    } else {
        // landscape
        X_POSITION=INFOVIEW_X_POSITION+10;
        X_POSITION_ENDMINUS=INFOVIEW_X_ENDMINUS+30;
    }
    
    [self constructAlert];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)constructAlert
{
    infoView = [UIView new];
    _APBlurDarkEffect=_blurDarkEffect;

    if (_hiddenDelay) {
          _APHidingDelay=_hiddenDelay;
    }
    
    NSUInteger posnumber=_APAlertPosition;
    int number_Y;
    if (posnumber == 0) {
        number_Y=-40;
    }else{
        number_Y=40;
    }
    
    infoView.frame = CGRectMake(X_POSITION, number_Y, self.view.bounds.size.width-X_POSITION_ENDMINUS , INFOVIEWHEIGT);
    infoView.layer.cornerRadius=12;
    
    infoView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    infoView.autoresizesSubviews = YES;
   // infoView.clipsToBounds = YES;
    
    if (_blurBackground == 1){
        
        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:(_APBlurDarkEffect == NO)?UIBlurEffectStyleLight:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        blurView.frame = infoView.bounds;
        blurView.layer.cornerRadius=12;
        blurView.layer.masksToBounds=YES;
        blurView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        blurView.autoresizesSubviews = YES;
        [infoView addSubview:blurView];
        
    }
    
    [self.view addSubview:infoView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, infoView.frame.size.width - INFOVIEWHEIGT, 70)];
    titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    titleLabel.autoresizesSubviews = YES;
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = _messageColorTitle ? _messageColorTitle : _APTitleColor;
    titleLabel.font=_titleFont ? _titleFont : _APTitleFont;
    titleLabel.numberOfLines = 0;
    [infoView addSubview:titleLabel];
    
    progressstitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 67, infoView.frame.size.width - INFOVIEWHEIGT, 17)];
    progressstitleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    progressstitleLabel.autoresizesSubviews = YES;
    //progressstitleLabel.backgroundColor = [UIColor systemPinkColor];
    progressstitleLabel.textAlignment = NSTextAlignmentLeft;
    progressstitleLabel.textColor = _messageColorSubtitle ? _messageColorSubtitle : _APSubTitleColor;
    progressstitleLabel.font=_progressstitleLabelFont ? _progressstitleLabelFont : _APProgressTitleFont;
    progressstitleLabel.numberOfLines = 0;
    [infoView addSubview:progressstitleLabel];
    
    NSMutableAttributedString * titleString = [[NSMutableAttributedString alloc] initWithString:_titleString ? _titleString : @""
                                                                                     attributes:@{NSFontAttributeName : _titleFont ? _titleFont : _APTitleFont,NSForegroundColorAttributeName : _messageColorTitle ? _messageColorTitle : _APTitleColor}];

    NSAttributedString * messageString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",_subtitleString ? _subtitleString : @""]
                                                                         attributes:@{NSFontAttributeName : _subTitleFont ? _subTitleFont : _APSubTitleFont,NSForegroundColorAttributeName : _messageColorSubtitle ? _messageColorSubtitle : _APSubTitleColor}];

    [titleString appendAttributedString:messageString];
    titleLabel.attributedText = titleString;

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 50, INFOVIEWHEIGT)];
    UIColor * bgColor = [_APColorsDictionary objectForKey:@(_alertType)];
    if (!_iconSetted)
        _iconImage = [_APIconsDictionary objectForKey:@(_alertType)];
    if (!bgColor)
    {
        bgColor = [UIColor clearColor];
    }
    if (_iconColor) {
        imageView.tintColor=_iconColor;
    }else{
        imageView.tintColor=[UIColor whiteColor];
    }
    
    infoView.backgroundColor = _messageColor ? _messageColor : bgColor;
    imageView.image = _iconImage;
    imageView.contentMode = UIViewContentModeCenter;
    [infoView addSubview:imageView];
    
    
    if (_shouldShowCloseIcon == 1 || (_APShouldShowCloseIcon && _shouldShowCloseIcon == -1))
    {
        UIImageView * closeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_close"]];
        closeView.frame = CGRectMake(infoView.bounds.size.width - 15, 8, 7, 7);
        closeView.contentMode = UIViewContentModeCenter;
        

        closeView.translatesAutoresizingMaskIntoConstraints = false;
        closeView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        closeView.autoresizesSubviews = YES;
        
        closeView.userInteractionEnabled = YES;
        [infoView addSubview:closeView];
        
          NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:closeView
           attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeRight multiplier:1 constant:-8];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:closeView
         attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeTop multiplier:1 constant:5];
        
        [infoView addConstraint:right];
        [infoView addConstraint:top];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseTap:)];
        [closeView addGestureRecognizer:tapGesture];
    }
    progressenabled = [[_APProgressDictionary objectForKey:@(_alertType)]boolValue];
    if (progressenabled) {
    self.progressBar=[[UIProgressView alloc] initWithFrame:CGRectMake(infoView.frame.origin.x+10, infoView.frame.size.height-10, infoView.frame.size.width-X_POSITION_ENDMINUS-40, 2)];
    self.progressBar.center=infoView.center;
    
    self.progressBar.trackTintColor =_progressTintColor ? _progressTintColor : _APProgressTintColor;;
    self.progressBar.tintColor=_progressTrackColor ? _progressTrackColor : _APProgressTrackColor;;
    
    self.progressBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    self.progressBar.autoresizesSubviews = YES;
    self.progressBar.progress = 0.0;
    [infoView addSubview:self.progressBar];
    }
}

-(void)progressRunCount:(float)floatcout{
    
    self.prgtimer=[NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        static int count=0;
        self.progressBar.hidden=NO;
        count++;
        if (count <=100) {
            self.progressBar.progress=count/floatcout;
            //NSLog(@"Count prg:%@",[NSString stringWithFormat:@"%d %%",count]);
        }else{
            [self.prgtimer invalidate];
            self.prgtimer=nil;
            count=0;
            self.progressBar.hidden=YES;
        }
        if ([[self delegate] respondsToSelector:@selector(progressStatus:)]) {
            [self.delegate progressStatus:self.progressBar.progress*100];
        }
        self->progressstitleLabel.text=self->_progressSubtitleString;
        
    }];
}
-(void)progressView:(float)progress :(NSString*)progressStatus{
     self.progressBar.progress=progress;
     self->progressstitleLabel.text=progressStatus;
}

-(void)updateprogressStatusSubtitleString:(NSString*)string{
    self->progressstitleLabel.text=string;
}

- (void)show
{
    [self performSelectorOnMainThread:@selector(showInMain) withObject:nil waitUntilDone:NO];
}

- (void)showInMain
{
    @synchronized (currentAlertArray) {
        
        if ([currentAlertArray count] == _APNumberOfVisibleAlerts)
        {
            [[currentAlertArray firstObject] hide:@(YES)];
        }
        
        
        numberOfAlerts = [currentAlertArray count];
        if (numberOfAlerts == 0){
            [[[[UIApplication sharedApplication] windows]firstObject] addSubview:self.view];
            self.view.frame = CGRectMake(X_POSITION, APPOSITIONFORALERT(numberOfAlerts), self->screenSize.width-X_POSITION_ENDMINUS, INFOVIEWHEIGT);
        }else{

            [[[[UIApplication sharedApplication] windows]firstObject] insertSubview:self.view belowSubview:[((APPlainAlert *)[currentAlertArray lastObject]) view]];
            
            NSUInteger APPPOSITIONINTEGER=APPOSITIONFORALERT(self->numberOfAlerts);
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self->X_POSITION, APPPOSITIONINTEGER, self->screenSize.width-self->X_POSITION_ENDMINUS, INFOVIEWHEIGT);
        }];
        }
        
        [currentAlertArray addObject:self];
                
        [self performSelector:@selector(hide:) withObject:@(YES) afterDelay:_APHidingDelay];
        
    }
}

- (void)hide:(NSNumber *)nAnimated
{
    [self performSelectorOnMainThread:@selector(hideInMain:) withObject:nAnimated waitUntilDone:NO];
}

- (void)hideInMain:(NSNumber *)nAnimated
{
    @synchronized (currentAlertArray) {
        [currentAlertArray removeObject:self];
        BOOL animated = [nAnimated boolValue];
        if (animated)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.alpha = 0.5;
                self.view.frame = CGRectMake(self->X_POSITION, (_APAlertPosition)?-130:self->screenSize.height, self->screenSize.width-self->X_POSITION_ENDMINUS , INFOVIEWHEIGT);
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
            
            for (int i = 0; i < [currentAlertArray count]; i++)
            {
                APPlainAlert * alert = [currentAlertArray objectAtIndex:i];
                NSUInteger APPPOSITIONINTEGER=APPOSITIONFORALERT(i);
                [UIView animateWithDuration:0.5 animations:^{
                    alert.view.frame = CGRectMake(self->X_POSITION, APPPOSITIONINTEGER, self->screenSize.width-self->X_POSITION_ENDMINUS, INFOVIEWHEIGT);
                }];
            }
        }
        else
        {
            [self.view removeFromSuperview];
            for (int i = 0; i < [currentAlertArray count]; i++)
            {
                APPlainAlert * alert = [currentAlertArray objectAtIndex:i];
                alert.view.frame = CGRectMake(X_POSITION, APPOSITIONFORALERT(i), screenSize.width-X_POSITION_ENDMINUS, INFOVIEWHEIGT);
            }
        }
    }
}

- (void)hide
{
    [self hide:@(YES)];
}
- (void)hidedelayprogress
{
    [self performSelector:@selector(hidecompletteprogress) withObject:self afterDelay:2];
}
-(void)hidecompletteprogress{
    
    [UIView animateWithDuration:0.5 animations:^{
           self.view.alpha = 0.5;
         self.view.frame = CGRectMake(self->X_POSITION, (_APAlertPosition)?-130:self->screenSize.height, self->screenSize.width-self->X_POSITION_ENDMINUS , INFOVIEWHEIGT);
       } completion:^(BOOL finished) {
         [self hide:@(YES)];
       }];
}

- (void)onTap
{
    if (_shouldHideOnTap == 1 || (_APShouldHideOnTap && _shouldShowCloseIcon == -1)) {
        [self hide];
    }
    
    if (_action != nil)
    {
        _action();
    }
}

- (void)onCloseTap:(UIGestureRecognizer *)gesture
{
    NSLog(@"Close");
    [self hide];
}

#pragma mark - Setters
- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    _iconSetted = YES;
}

#pragma mark - Default bAPaviour

+ (void)updateNumberOfAlerts:(NSInteger)numberOfAlerts
{
    if (numberOfAlerts > 0)
    {
        _APNumberOfVisibleAlerts = numberOfAlerts;
    }
}

+ (void)updatAPHidingDelay:(float)delay
{
    if (delay >= 0)
    {
        _APHidingDelay = delay;
    }
}
+ (void)updateBlurDarkEffect:(BOOL)effect
{
    _APBlurDarkEffect = effect;
}
+ (void)updateTitleFont:(UIFont *)titleFont
{
    _APTitleFont = titleFont;
}

+ (void)updateSubTitleFont:(UIFont *)stitleFont
{
    _APSubTitleFont = stitleFont;
}

+ (void)updateProgressTitleFont:(UIFont *)prgtitleFont
{
    _APProgressTitleFont = prgtitleFont;
}

+ (void)updateTitleCOLOR:(UIColor *)titleColor
{
    _APTitleColor = titleColor;
}

+ (void)updateSubTitleCOLOR:(UIColor *)stitleColor
{
    _APSubTitleColor = stitleColor;
}
+ (void)updateProgressTintCOLOR:(UIColor *)tintColor
{
    _APProgressTintColor = tintColor;
}
+ (void)updateProgressTrackCOLOR:(UIColor *)trackColor
{
    _APProgressTrackColor = trackColor;
}

+ (void)updateAlertPosition:(APPlainAlertPosition)viewPosition
{
    _APAlertPosition = viewPosition;
}

+ (void)updateAlertColor:(UIColor *)color forType:(APPlainAlertType)type
{
    [APPlainAlert updateColorsDictionary];
    if (color)
    {
        [_APColorsDictionary setObject:color forKey:@(type)];
    }
    else
    {
        [_APColorsDictionary removeObjectForKey:@(type)];
    }
}


+ (void)updateAlertIcon:(UIImage *)image forType:(APPlainAlertType)type
{
    [APPlainAlert updateIconsDictionary];
    if (image)
    {
        [_APIconsDictionary setObject:image forKey:@(type)];
    }
    else
    {
        [_APIconsDictionary removeObjectForKey:@(type)];
    }
}

+ (void)updateShouldHideOnTap:(BOOL)hide
{
    _APShouldHideOnTap = hide;
}

+ (void)updateShouldShowCloseIcon:(BOOL)show
{
    _APShouldShowCloseIcon = show;
}
+ (void)updateBlurBackground:(BOOL)blur
{
    _APBlurBackground = blur;
}
@end
