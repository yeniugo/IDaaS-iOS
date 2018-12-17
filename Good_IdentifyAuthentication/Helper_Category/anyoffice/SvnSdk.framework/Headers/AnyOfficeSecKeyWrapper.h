//
//  AnyOfficeSecKeyWrapper.h
//  sCos_iPhone_HTTP
//
//  Created by kf1 on 16/2/4.
//
//

#import <Foundation/Foundation.h>
typedef void (*AnyOfficeSecKeySaveAccessGoup)(char* pcAccess);
typedef char* (*AnyOfficeSecKeyReadAccessGoup)();
void AnyOffice_SecKeyEngineLoad(AnyOfficeSecKeySaveAccessGoup savefunc,
                                AnyOfficeSecKeyReadAccessGoup readfunc);

@interface AnyOfficeSecKeyWrapper : NSObject
+(SecKeyRef) getPrivateKey;
+(SecCertificateRef) getCert;
+ (void) setAccessGroup: (NSString*) accessgroup;
+ (NSString*) getX509SubjectNameEntry :(NSString*) name;
+ (NSString*) getX509IssuerNameEntry :(NSString*) name;
+ (NSString*) getCertSeriaNum;
+ (void) initwith :(NSString*) accessgroup isManager:(BOOL)manager;
@end
