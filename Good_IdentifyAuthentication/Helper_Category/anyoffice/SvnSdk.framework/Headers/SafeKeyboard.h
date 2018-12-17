//
//  AlphabetPad.h
//


#import <UIKit/UIKit.h>
#import "SafeKeyboardStyle.h"

@protocol SafeKeyboardDelegate;

@interface SafeKeyboard : UIView <UIInputViewAudioFeedback>

+ (instancetype)safeKeyboardWithDelegate:(id<SafeKeyboardDelegate>)delegate keyboardStyleClass:(Class)styleClass;

+ (instancetype)safeKeyboardWithDelegate:(id<SafeKeyboardDelegate>)delegate;
/*Begin modify by fanjiepeng on 2016-08-08,for ICBC POC*/
+ (instancetype)safeKeyboardWithDelegate:(id<SafeKeyboardDelegate>)delegate useKeyboardLoginStyle:(BOOL)style;
/*End modify by fanjiepeng on 2016-08-08,for ICBC POC*/
- (NSString *)getSafeCode;
- (NSString *)getFakeCode;
-(NSMutableString *)setSafeCode:(NSString *)code;
-(void)setShowSafeCode:(BOOL)show;
-(void)hiddenSafeKeyBoard;

/**
 *  Left function button for custom configuration
 */
@property (strong, readonly, nonatomic) UIButton *leftFunctionButton;

/**
 *  The class to use for styling the number pad
 */
@property (strong, readonly, nonatomic) Class<SafeKeyboardStyle> styleClass;

@end

@protocol SafeKeyboardDelegate <NSObject>

@optional

- (void)safeKeyboard:(SafeKeyboard *)safeKeyboard functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput;
- (void)safeKeyboardDoneButtonClick;

@end
