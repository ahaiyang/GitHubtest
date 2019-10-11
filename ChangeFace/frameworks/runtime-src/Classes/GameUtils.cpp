//
//  GameSprite.cpp
//  Arale
//
//  Created by shuo wang on 15/7/15.
//
//
#include "GameUtils.h"

bool GameUtils::alphaTouchCheck(cocos2d::Sprite* sprite,cocos2d::Point Nodepos)
{
    Image *myImage = GameUtils::createImageFromSprite(sprite);
    Director::getInstance()->getRenderer()->render();
    unsigned char *data = myImage->getData();
    //根据刚刚计算的相对坐标值，计算出触摸点代表了哪一个像素点      然后再提取出该像素点的alpha值
    //注意：因为图片坐标（0，0）是在左上角，所以要和触摸点的Y转换一下，也就是“(myImage->getHeight() - (int)(ps.y) - 1)”
    //该data值是把二维数组展开成一个一维数组,因为每个像素值由RGBA组成,所以每隔4个char为一个RGBA,并且像素以横向排列
    int pa = 4 * ((myImage->getHeight() - (int)(Nodepos.y) - 1) * myImage->getWidth() + (int)(Nodepos.x)) + 3;
    unsigned int ap = data[pa];

    myImage->release();
    free(data);
    if (ap > 20)
        return true;
    else
        return false;
}

Image* GameUtils::createImageFromSprite(cocos2d::Sprite* sp)
{
    Sprite* pNewSpr = Sprite::createWithSpriteFrame(sp->getSpriteFrame());
    pNewSpr->setAnchorPoint(Vec2::ZERO);
    pNewSpr->retain();
    RenderTexture* pRender = RenderTexture::create(pNewSpr->getContentSize().width, pNewSpr->getContentSize().height, Texture2D::PixelFormat::RGBA8888);
    pRender->retain();
    pRender->beginWithClear(0,0,0,0);
    pNewSpr->visit();
    pRender->end();
    Director::getInstance()->getRenderer()->render();
    pNewSpr->release();
    pRender->release();
    Image* image = pRender->newImage();
    image->retain();
    return image;
}

static int powerRebackTime = 0;
void GameUtils::setUserPowerRebackTime(int rebackTime)
{
    powerRebackTime = rebackTime;
}

int GameUtils::getUserPowerRebackTime()
{
    return powerRebackTime;
}

static int pvpRebackTime = 0;
void GameUtils::setUserPVPRebackTime(int rebackTime)
{
    pvpRebackTime = rebackTime;
}

int GameUtils::getUserPVPRebackTime()
{
    return pvpRebackTime;
}

void GameUtils::setEnableLocationPush(bool isEnable)
{
    UserDefault::getInstance()->setBoolForKey("isEnablePush", isEnable);
}

bool GameUtils::getEnableLocationPush()
{
    return UserDefault::getInstance()->getBoolForKey("isEnablePush",false);
}
