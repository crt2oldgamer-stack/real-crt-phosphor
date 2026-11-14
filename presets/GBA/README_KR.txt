Real CRT Phosphor 보너스: GBA 색 보정 (GBA Comfort Color)

GBA 게임의 강한 형광색을 눌러서, 지금 화면에서 눈이 편하게 볼 수 있게 하는 색 보정입니다.
GBA 시절 화면은 어두워서 도트를 아주 진하고 밝게 찍은 게임이 많습니다. 요즘 밝은 화면으로 에뮬레이터를 돌리면
우주가 새파랗고 초록이 형광색처럼 보여 눈이 피로합니다. 이 보정은 그런 진한 색을 가라앉힙니다.
(실기 화면을 똑같이 재현하는 게 아니라, 편하게 보기 위한 색 보정입니다.)
확인한 게임: 슈퍼로봇대전 A·R·OG·D, 신약 성검전설, FF6 어드밴스

프리셋 6개 (이 폴더)
  색만 (패스 1개, 휴대기기에서도 가벼움)     색 + CRT (Real CRT Phosphor, 15패스)
  gba-light.slangp                           gba-crt-light.slangp
  gba-medium.slangp                          gba-crt-medium.slangp
  gba-strong.slangp                          gba-crt-strong.slangp

세기 고르기
- 약 (light): 아주 진한 형광색만 살짝 누르고, 나머지 색은 게임 그대로. 밝기는 원본의 90% 이상.
- 중 (medium): 형광색이 거의 다 사라지고 화면이 조금 차분해짐. 대부분의 게임에 무난 (슈퍼로봇대전 A도 충분).
- 강 (strong): 형광색으로 가득한 게임용 (예: 슈퍼로봇대전 A). 더 차분하고 어두움.
- 잘 모르겠으면 중부터 써 보세요.
  측정 예 (형광색 픽셀): 슈로대 A 35% → 약 22% / 중 0.1% / 강 0%. 슈로대 R·OG 약 7%, D 2%, FF6A·신약 성검전설 1% 미만.

쓰는 법
1. GBA 게임 실행 → Quick Menu → Shaders → Load → shaders_slang/real-crt-phosphor/presets/GBA/ 에서 하나 고르기
2. Save → Save Core Preset (mGBA 코어 전체) 또는 Save Game Preset (그 게임만)
   (예: 코어 프리셋은 중, 형광색이 유난히 강한 게임만 게임 프리셋으로 강)
- mGBA 코어 옵션의 색 보정은 꺼 두세요 (겹치면 두 번 보정됩니다).
- CRT 프리셋은 GBA가 액정 게임이라 번짐을 최소로 줄였습니다 (4K에서 맞춤, 마스크 간격 MASK_PITCH 5.5를 모든 화면에 사용).
- 셰이더 메뉴의 "앞에 추가(Prepend)"로 붙이면 색 보정이 두 번 걸릴 수 있으니 이 프리셋을 그대로 쓰세요.
- 셰이더 파일은 shaders/gba-comfort-color.slang 이고, 모든 항목 이름은 GBA_ 로 시작합니다
  (Real CRT Phosphor 항목과 이름이 겹치지 않게).
