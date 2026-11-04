Real CRT Phosphor v1.1.1  — RetroArch용 CRT 셰이더 (slang)
제작: 건군 (기획·방향·실기 테스트·튜닝)
AI 저작물 표시: 코드 대부분을 AI(Claude, ChatGPT)가 작성했습니다. 자세한 내용은 LICENSE_KR.txt

■ 이 셰이더는
  실제 CRT TV를 가까이서 찍은 사진처럼, 화면이 RGB 형광체 줄로만 빛나게 만듭니다.
  - 바탕 그림 위에 마스크를 덮는 방식이 아니라, 빛이 오직 R·G·B 줄에서만 나옵니다.
  - 밝은 색의 줄은 굵어지고 어두운 색의 줄은 가늘어집니다 (색마다 줄 모양이 달라짐).
  - 아주 밝은 곳에서는 줄들이 빛 덩어리로 녹아듭니다.
  - 줄이 굵어져도 빛의 총량은 유지되어 어두워지거나 탁해지지 않습니다.

■ 설치
  1) real-crt-phosphor 폴더를 RetroArch/shaders/shaders_slang/ 안에 넣습니다.
  2) 비디오 드라이버는 Vulkan(권장) 또는 glcore, D3D11 등 slang을 지원하는 것.
  3) 게임 실행 → Quick Menu → Shaders → Load
     - 바로 써 보기: real-crt-phosphor.slangp
     - 추천 설정:   presets/4K/ (4K 모니터), presets/Ally/ (1080p 휴대기기)
  4) 마음에 들면 Save → Save Core Preset (기종마다)

■ v1.1.1 변경점 (속도 개선, 화면은 그대로)
  아이패드·스마트폰 같은 휴대기기 GPU에서 느리던 부분을 고쳤습니다.
  - 감마 변환(pow)을 화면 해상도 단계에서 게임 원래 해상도 단계로 옮김
    → 화면 픽셀마다 하던 pow 32번이 0번 (Signal 단계는 실수 버퍼로 선형값 저장)
  - 밝은 곳 빛 덩어리 계산을 exp 1번 + 보정식으로 간소화 (덩어리가 1.2px 이상일 때)
  - 화면 단계의 특수 함수(pow·exp 등) 계산량 약 1/4로 감소
  - 이전 버전과 결과 차이: 픽셀당 최대 2/255 (눈으로 구별 불가)
  ※ 기존 프리셋·게임 프리셋은 그대로 쓰면 됩니다. 폴더째 덮어쓰기만 하세요.

■ 두 가지 마스크 (v1.1 새 기능)
  Aperture Grille  세로 RGB 줄. 소니 계열 TV 느낌. 기본값.
  Slot Mask        RGB 묶음이 짧은 칸으로 끊기고, 옆 묶음과 반 칸씩 엇갈림(벽돌 배치).
                   일반 가정용 브라운관 TV 느낌.
  Shader Parameters 의 "Mask type: 0 Grille / 1 Slot" 으로 바로 바꿀 수 있습니다.

■ 추천 프리셋
  presets/4K/   (32인치 4K 모니터)     presets/Ally/ (ROG Ally 1080p)
    *-sfc / *-ps1 / *-ps2 / *-psp            Aperture Grille, 피치 4.5
    *-sfc-slot / ... / *-psp-slot            Slot Mask, 피치 3
    *-ps2-2d                                 PS2 2D 게임용, 피치 1.5
  자세한 구조와 게임별 조정법: presets/프리셋_사용법.txt

■ 자주 만지는 값
  RGB triad pitch px       RGB 줄 묶음 간격. 0 = 자동. Grille은 4.5, Slot은 3 추천
                           (슬롯은 피치가 크면 틈이 굵어져 무늬가 날카롭게 보임)
  Slot gap fraction        슬롯 틈 비율 (기본 0.22). 높이면 끊김이 뚜렷해짐
  Slot gap depth           슬롯 틈 진하기 (기본 0.6). 1.0 = 틈이 완전히 검게 꺼짐(디더처럼 보이기 쉬움)
                           낮출수록 틈에 빛이 조금 남아 벽돌 구조는 보이되 체크무늬가 약해짐.
                           평균 밝기는 자동 보정되어 값을 바꿔도 화면이 어두워지거나 밝아지지 않음
  Slot gap edge softness   슬롯 틈 가장자리 부드러움
  Slot follows scanlines   1(기본) = 슬롯 칸을 스캔라인에 맞춤. 틈이 줄 사이 어두운 곳에 오고
                           스캔라인과 엇갈리는 물결무늬가 생기지 않음. 0 = 스캔라인과 따로(물결 가능)
  Slot height in scanlines 슬롯 한 칸의 높이(스캔라인 수, 기본 2)
  Slot vertical pitch adjust  슬롯 상하 간격 미세 보정 (기본 1.0, 0.5~2.0)
                           1.0 = 스캔라인에 정확히 맞춤. 1.0에서 멀어질수록 칸이 길어지거나 짧아지는 대신
                           스캔라인과 조금씩 어긋나 옅은 물결이 다시 생길 수 있음. 0.9~1.1 사이부터 시험 권장
  Slot straight sides      1(기본) = 칸 옆면을 곧게. 줄 굵기가 스캔라인 사이에서 잘록해져
                           뼈다귀·육각형처럼 보이던 현상을 막음
  Horizontal softness      가로 번짐 (게임마다 조정 포인트)
  Vertical softness        세로 번짐 (스캔라인을 부드럽게)
  Convergence error        R은 왼쪽, B는 오른쪽으로 살짝 어긋남. 0.4~0.6이면 옛날 TV 맛
  Brightness               4K 밝은 모니터는 1.0 전후

■ 참고
  - 스크린샷을 축소해서 보면 RGB 줄이 사라지거나 무늬가 생깁니다. 원본 크기로 보세요.
  - 피치를 3 미만(예: 1.5)으로 두면 RGB 줄 대신 아주 고운 색 섞임으로 작동합니다.
    PS2 2D 게임에서는 도트 가장자리가 부드러워져 업스케일한 듯한 효과가 납니다(*-ps2-2d).
  - Slot follows scanlines 를 0으로 두면 슬롯이 스캔라인과 따로 계산되어 물결무늬가 생길 수 있습니다.

■ 이용 조건 (자세한 내용은 LICENSE_KR.txt)
  - 비상업적 목적이면 자유롭게 사용·수정·재배포 가능 (출처 표기, 이용 조건 파일 포함)
  - 상업적 이용은 사전 허락 필요
  - 공식 배포처가 아닌 곳에서 받은 파일의 오류·바이러스 등은 책임지지 않습니다
