if [-d "src_et"];then
	echo "删除编译文件"
	rm -r src_et
fi

basepath=$(cd 'dirname $0';pwd)
DADIZHU_MAC_RUNNABLE=$basepath/runtime/mac/InterestPoker-desktop.app/Contents/MacOS/InterestPoker-desktop
$DADIZHU_MAC_RUNNABLE -workdir $basepath -console disable
