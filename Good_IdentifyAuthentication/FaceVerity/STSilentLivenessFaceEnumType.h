//
//  STSilentLivenessFaceEnumType.h
//
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#ifndef STSilentLivenessFaceEnumType_h
#define STSilentLivenessFaceEnumType_h
/**
 *  活体检测失败类型
 */
typedef NS_ENUM(NSInteger, STIDSilentLivenessFaceError) {
    /** 人脸的状态未知 */
    STIDSilentLiveness_E_FACE_UNKNOWN,
    /** 没有人脸 */
    STIDSilentLiveness_E_NOFACE_DETECTED,
    /** 人脸遮挡 */
    STIDSilentLiveness_E_FACE_OCCLUSION,
    /** 活体检测失败 */
    STIDSilentLiveness_E_HACK
};
/**
 *  活体检测中人脸远近
 */
typedef NS_ENUM(NSInteger, STIDSilentLivenessFaceDistanceStatus) {
    /** 人脸距离手机过远 */
    STIDSilentLiveness_FACE_TOO_FAR,
    /** 人脸距离手机过近 */
    STIDSilentLiveness_FACE_TOO_CLOSE,
    /** 人脸距离正常 */
    STIDSilentLiveness_DISTANCE_FACE_NORMAL,
    /** 人脸距离未知 */
    STIDSilentLiveness_DISTANCE_UNKNOWN
};

/**
 *  活体检测中人脸的位置
 */
typedef NS_ENUM(NSUInteger, STIDSilentLivenessFaceBoundStatus) {
    /**  没有人脸 */
    STIDSilentLiveness_BOUND_NO_FACE,
    /** 人脸在框内 */
    STIDSilentLiveness_FACE_IN_BOUNDE,
    /** 人脸出框 */
    STIDSilentLiveness_BOUND_FACE_OUT_BOUND
};

/**
 *  人脸方向
 */
typedef NS_ENUM(NSUInteger, STIDSilentLivenessFaceOrientaion) {
    /** 人脸向上，即人脸朝向正常 */
    STIDSilentLiveness_FACE_UP = 0,
    /** 人脸向左，即人脸被逆时针旋转了90度 */
    STIDSilentLiveness_FACE_LEFT = 1,
    /** 人脸向下，即人脸被逆时针旋转了180度 */
    STIDSilentLiveness_FACE_DOWN = 2,
    /** 人脸向右，即人脸被逆时针旋转了270度 */
    STIDSilentLiveness_FACE_RIGHT = 3
};

#endif /* STSilentLivenessFaceEnumType_h */
