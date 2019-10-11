//
//  GameSprite.h
//  Arale
//
//  Created by shuo wang on 15/7/15.
//
//

#ifndef __Arale__GameSprite__
#define __Arale__GameSprite__

#include "cocos2d.h"
USING_NS_CC;


class GameUtils{
public:
    static bool alphaTouchCheck(cocos2d::Sprite* sprite,cocos2d::Point Nodepos);
    static Image* createImageFromSprite(cocos2d::Sprite* sp);
    
    static void setUserPowerRebackTime(int rebackTime);
    static int getUserPowerRebackTime();
    
    static void setUserPVPRebackTime(int rebackTime);
    static int getUserPVPRebackTime();
    
    static void setEnableLocationPush(bool isEnable);
    static bool getEnableLocationPush();
};

#endif /* defined(__Arale__GameSprite__) */
