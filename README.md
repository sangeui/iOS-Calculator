
### Clone Coding of iOS Calculator App

* 배경
	* 앱 구조의 부재와 수차례 스파게티 코드 작성
	* 이로 인한 유지보수의 어려움 경험
* 목적
	* 앱 구조를 설계하고 이에 따른 구현
	* 현재의 요구사항에 충실하지만, 미래의 확장 가능성에 대한 최소한의 장치 마련
* 특징
	* 앱을 두개의 독립적인 레이어로 분리
		* UI 레이어
			* View와 이로부터 발생할 수 있는 이벤트를 담당
		* Core 레이어
			* 계산기의 핵심 로직을 담당
	* 핵심 컴포넌트의 추상화
		* Command 패턴을 사용해, 확장을 대비한 최소한의 장치 마련
			* Converter
				* 사용자가 입력한 중위 표현식을 전위 또는 후위 표현식으로 변환
			* Evaluator(또는 Calculator)
				* 변환된 표현식의 형태에 따른 계산
	* 데이터의 캡슐화
		* 데이터의 종류(연산자, 피연산자)에 상관없이 독립된 데이터 구조로 처리할 수 있도록 캡슐화
		* 이로 인해 중복되는 코드를 제거
	* 버튼 효과
		* Fluid Interface
			* iOS 계산기 앱에서 사용되는 버튼의 Fluid 인터페이스 구현
* 구조
	* 최상위 레벨: 유저 인터페이스 레이어 - 코어 레이어
	* 유저 인터페이스 레이어: Controller - View
	* 코어 레이어: Converter - Core - Calculator
	* <img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/Calculator.png">
* 결과
	* 플러스
		* 설계 경험
		* 비즈니스 로직 분리를 통한 장점 경험
			* UI 변경에 대한 부담 해소
		* 간단하지만 직접 Fluid Interface를 구현함으로써, 인터페이스 효과 구현의 자신감 함양
	* 마이너스
		* 디자인 패턴의 오용
		* 설계의 어려움, 다양한 장애물 경험
---

**FLUID INTERFACE의 구현**
(https://developer.apple.com/videos/play/wwdc2018/803/)

* 버튼 애니메이션
	* 터치 이벤트의 종류에 따라 애니메이션 효과 적용
	* `addTarget(_:action:for:)`
		* 버튼 터치 이벤트 시작
			* .touchDown, .touchDragEnter
		* 버튼 터치 이벤트 종료
			* .touchUpInside, touchDragExit, touchCancel
* 버튼 간 애니메이션
	* 문제점
		* 터치 이벤트는 화면 상 가장 전면의 서브 뷰로 전달 
		* 터치 이벤트가 특정 버튼에 묶이는 상황 발생
	* 해결
		* `DummyView`를 생성해 모든 터치 이벤트는 더미 뷰로 묶이도록 함
		* `DummyView`는 발생하는 터치 이벤트를 부모 `MainView`로 보냄
			* 이때 `MainView`는 더미 뷰와 버튼 뷰를 가지는 `MainView`
		* 터치 이벤트를 받은 `MainView`는, 터치 이벤트가 발생한 지점의 자식 뷰가 버튼일 때에만 해당 이벤트를 전달.
	* 결과
		* 일종의 이벤트 역전
		* iOS 계산기와 동일한 Fluid Interface 구현
		* 이것이 유일하고 옳은 방법이라고는 생각되지 않음
		* <img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/InversionOfEvent.jpeg" width="400">

---
**데모 이미지**

|FLUID EFFECT| 스크린샷1 |
|--|--|
|<img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/Fluid-Calculator.gif" width="200">|<img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/iOS-Clone-Calculator-1.png" width="200">|

|스크린샷2|스크린샷3|
|--|--|
|<img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/iOS-Clone-Calculator-2.png" width="200">|<img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/iOS-Clone-Calculator-3.png" width="200">|
