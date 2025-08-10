export function initPasswordChangeModule({formSelector, userId, userEmail}) {
    
	const form = document.querySelector(formSelector);
	
    const pw1 = form.querySelector(".password1");
    const pw2 = form.querySelector(".password2");
    const submitBtn = form.querySelector(".pw-change-btn");
    const resultSpan = form.querySelector(".pw-change-result");
    const pwCheckResult = form.querySelector(".pw-check-result");
    const pwCheckResult2 = form.querySelector(".pw-check-result2");
    const pwChangeResult = form.querySelector(".pw-change-result");
	let isPwOk = false;
	let isPw2Ok = false;

    // 비밀번호 유효성 검사 및 안전도
    pw1.onblur = function() {
        const pwd = this.value;
        const pattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%])[A-Za-z\d!@#$%]{8,16}$/;
        if(!pattern.test(pwd)) {
            pwCheckResult.innerText = "영문자, 숫자, 특수문자(!@#$%) 조합 8 ~ 16글자 필수!";
            pwCheckResult.style.color = "red";
            isPwOk = false;
        } else{
            pwCheckResult.innerText = pwd.length >= 12 ? "안전" : (pwd.length >= 10 ? "보통" : "위험");
            pwCheckResult.style.color = pwd.length >= 12 ? "green" : (pwd.length >= 10 ? "orange" : "red");
            isPwOk = true;
        }
    };
	
	// pw1 = pw2 확인
	pw2.addEventListener('input', function() {
        const pwd1 = pw1.value;
        const pwd2 = pw2.value;
        if(pwd2.length === 0) {
            pwCheckResult2.innerText = '';
            isPw2Ok = false;
            return;
        }
        if(pwd1 === pwd2) {
            pwCheckResult2.innerText = '비밀번호 일치';
            pwCheckResult2.style.color = 'green';
            isPw2Ok = true;
        } else {
            pwCheckResult2.innerText = '비밀번호 불일치';
            pwCheckResult2.style.color = 'red';
            isPw2Ok = false;
        }
    });
	
    submitBtn.onclick = function() {
        const pwVal1 = pw1.value.trim();
        const pwVal2 = pw2.value.trim();

        // 비밀번호 안전성 미통과
        if(!isPwOk) {
            resultSpan.innerText = "비밀번호 형식을 다시 확인하세요.";
            resultSpan.style.color = "red";
            return;
        }
        if(!pwVal1 || !pwVal2) {
            resultSpan.innerText = "비밀번호를 모두 입력하세요.";
            resultSpan.style.color = "red";
            return;
        }
        if(pwVal1 !== pwVal2) {
            resultSpan.innerText = "비밀번호가 일치하지 않습니다.";
            resultSpan.style.color = "red";
            return;
        }

        fetch('/change/resetPassword', {
		    method: 'POST',
		    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		    body: `userId=${encodeURIComponent(userId)}&userEmail=${encodeURIComponent(userEmail)}&newPasswd=${encodeURIComponent(pwVal1)}`
		})
		.then(res => res.json())
		.then(data => {
		     if(data.success) {
		        alert("변경 성공!");
		        window.close();
		    } else {
        		alert("변경 실패(일치하는 회원 없음)");
			}
		})
        .catch(() => {
            resultSpan.innerText = "서버 오류로 비밀번호 변경 실패!";
            resultSpan.style.color = "red";
        });
    };
}
