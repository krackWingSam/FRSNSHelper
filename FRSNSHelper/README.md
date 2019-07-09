 # 사용하기 앞서

## Facebook 준비절차
info.plist 파일에 아래 항목에 대한 내용을 추가
'''
<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleURLSchemes</key>
<array>
<string>fb2290163904407046</string>
</array>
</dict>
</array>
<key>FacebookAppID</key>
<string>2290163904407046</string>
<key>FacebookDisplayName</key>
<string>com.Fermata.FRSNSHelper</string>
...
<key>LSApplicationQueriesSchemes</key>
<array>
<string>fbapi</string>
<string>fb-messenger-api</string>
<string>fbauth2</string>
<string>fbshareextension</string>
</array>

'''

<key>CFBundleURLTypes</key>
<array>
<dict>
<key>CFBundleURLSchemes</key>
<array>
<string>fb2290163904407046</string>
</array>
</dict>
</array>
<key>FacebookAppID</key>
<string>2290163904407046</string>
<key>FacebookDisplayName</key>
<string>com.Fermata.FRSNSHelper</string>


## 카카오톡 준비 절차

plist에 카카오앱키 등록
'''
<key>KAKAO_APP_KEY</key>
<string>37673cfe01f8e7d54baa97fb99ea3e54</string>
'''

URL scheme 추가
URLScheme 값은 kakao+KAKAO_APP_KEY

White List 추가
'''
<key>LSApplicationQueriesSchemes</key>
<array>
...
<!-- 공통 -->
<string>kakao0123456789abcdefghijklmn</string>

<!-- 간편로그인 -->
<string>kakaokompassauth</string>
<string>storykompassauth</string>

<!-- 카카오톡링크 -->
<string>kakaolink</string>
<string>kakaotalk-5.9.7</string>

<!-- 카카오스토리링크 -->
<string>storylink</string>
</array>
'''


## Google
어디서든지(AppDelegate 가 아니더라도) client ID 삽입
URL Scheme 에 추가
'''
com.googleusercontent.apps. + client ID
'''
