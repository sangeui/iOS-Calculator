
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
		* iOS 계산기 앱에서 사용되는 버튼의 Fluid 인터페이스 구현
* 결과
	* 디자인 패턴의 오용
	* 설계의 중요성과 동시에 어려움 경험

---

<table>
  <tr>
    <td>Fluid Effect</td>
  </tr>
  <tr>
    <td><img src="https://github.com/sangeui/iOS-Calculator/blob/main/Resources/Fluid-Calculator.gif" width="200"></td>
  </tr>
 </table>
