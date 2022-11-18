_file=""
for file in `find . -name "*.aab"`; do
	_file=$file
done

echo "$_file"
if [[ device-spec.json ]]; then
	echo "文件存在。。。"
	rm device-spec.json
fi

_jks_file=""
for file in `find . -name "*.jks"`; do
	_jks_file=$file
done

echo "生成设备文件"
java -jar bundletool-all-1.11.0.jar get-device-spec --output=./device-spec.json

echo "生成apks"
java -jar bundletool-all-1.11.0.jar build-apks --bundle=$_file --output=./app-debug.apks  --mode=universal  --overwrite --ks=$_jks_file --ks-pass=pass:apana#2022 --ks-key-alias=apana --key-pass=pass:apana#2022 --device-spec=./device-spec.json

echo "获取apk"
#java -jar bundletool-all-1.11.0.jar install-apks --apks=./app-debug.apks
#java -jar bundletool-all-1.11.0.jar extract-apks --apks=./app-debug.apks  --output-dir=okDir --device-spec=./device-spec.json


#echo "开始安装"
#java -jar bundletool-all-1.11.0.jar install-apks --apks=./app-debug.apks
#
#echo "启动app"
#adb shell am start -n "com.apana.sprout/com.apana.sprout.login.ui.LauncherActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER