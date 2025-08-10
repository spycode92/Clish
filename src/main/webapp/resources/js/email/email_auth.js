let sendMail = null;

export function initEmailAuth(emailInputId, buttonId, statusSpanId, options) {
	
	// DOM 요소 참조
	options = options || {};
	const emailInput = document.getElementById(emailInputId);
	const verifyBtn = document.getElementById(buttonId);
	const checkBtn = document.getElementById("checkEmailVerifiedBtn");
	const resultSpan = document.getElementById(statusSpanId);
	const purpose = typeof options.purpose !== "undefined" ? options.purpose : "user";
	
//	let emailCheckInterval = null;
	
	// 이메일 인증
	verifyBtn.addEventListener("click", () => {
	    const email = emailInput.value.trim();

	    if(!email) {
	        alert("이메일을 입력하세요!");
	        emailInput.focus();
	        return;
	    }

	    var bodyData = { userEmail: email };

	    if(purpose) bodyData.purpose = purpose;
				
	    // changePasswd일 때만, 아이디+이메일 체크
	    if(options.purpose === "changePasswd") {
			const userIdValue = document.getElementById("userId").value.trim();
			
			if(!userIdValue) {
		        alert("아이디를 입력하세요!");
		        return;
		    }

	        startCheckingUseIdAndEmail(userIdValue, email, function(isOk) {
			    if(!isOk) return;
			    sendEmailRequest();
			});
			return;
	    }

		// 일반 실행 경로
		sendEmailRequest();
		
		// ==========================================================================
		
		// 메일 전송
		function sendEmailRequest() {
	        fetch("/email/send", {
	            method: "POST",
	            headers: { "Content-Type": "application/json" },
	            body: JSON.stringify(bodyData)
	        })
	        .then(res => res.text())
	        .then(token => {
	            if(token) {
	                alert("이메일이 전송되었습니다. 받은 메일에서 인증 링크를 클릭하세요.");
	                resultSpan.innerText = "이메일 인증 중...";
	                resultSpan.style.color = "orange";
	                checkBtn.style.display = "inline-block";
	                sendMail = email;
	            } else {
	                alert("이메일 전송 실패!");
	            }
	        })
	        .catch(() => {
	            alert("서버 오류로 메일 전송 실패!");
	        });
	    }
		
	});
	
	// 로직 변경로 주석처리
//	function startEmailPolling(email) {
//		clearInterval(emailCheckInterval);
//
//		emailCheckInterval = setInterval(() => {
//			fetch(`/email/check?email=${encodeURIComponent(email)}`)
//				.then(res => res.json())
//				.then(data => {
//					if(data.verified) {
//						resultSpan.innerText = "이메일 인증 완료!";
//						resultSpan.style.color = "green";
//						
//						clearInterval(emailCheckInterval);
//						
//						emailInput.readOnly = true;
//						verifyBtn.disabled = true;
//						
//						document.querySelectorAll('.required_auth input, .required_auth select, .required_auth button')
//								.forEach(el => el.disabled = false);
//								
//						window.isEmailVerified = true; 
//						if(typeof window.updateSubmitButton === "function") updateSubmitButton();
//					}
//				}).catch(err => console.error("인증 상태 확인 실패", err));
//		}, 3000);
//	}

	// 인증 완료 버튼
	checkBtn.addEventListener("click", () => {
		const email = emailInput.value.trim().toLowerCase();
//		console.log("email : " + email)
//		console.log("sendMail : " + sendMail)
//		console.log("options : " + options.purpose);
		
		if(!email) {
			alert("이메일을 입력하세요!");
			emailInput.focus();
			return;
		}
		
		if (email != sendMail) {
	        alert("인증 요청한 이메일과 일치하지 않습니다.");
	        return;
	    }
		
		fetch(`/email/check?email=${encodeURIComponent(email)}`)
		.then(res => res.json())
		.then(data => {
			if(data.verified) {
				resultSpan.innerText = "이메일 인증 완료!";
				resultSpan.style.color = "green";
				
				if(options.purpose === "findLoginId") {
					console.log("testing1111");
					startFindLoginId(email);
				}
				
				emailInput.readOnly = true;
				verifyBtn.disabled = true;
				checkBtn.disabled = true;
				checkBtn.style.display = "none";
				
				if(options.purpose === "changePasswd") {
	                if(typeof onEmailAuthSuccess === "function") {
	                    onEmailAuthSuccess();
	                }
	            }

				if(options.purpose === "join") {
	                window.isEmailVerified = true;
					tryEnableFormAfterEmailVerified();
	            }
				
			
			} else {
				resultSpan.innerText = "아직 인증되지 않았습니다.";
				resultSpan.style.color = "red";
			}
		})
		.catch(() => {
			alert("인증 확인 중 오류 발생");
		});
	});
	
	// findLoginId AJAX
	function startFindLoginId(email) {
//		console.log("testing2");
	    fetch("/user/findLoginId?email=" + encodeURIComponent(email))
        .then(res => res.json())
        .then(data => {
            if(data.foundId) {
                onFindIdSuccess(data.foundId);
            } else {
				alert("해당 이메일로 가입된 아이디를 찾을 수 없습니다.");
				window.close();
            }
        })
        .catch(() => {
            alert("아이디 조회 중 오류 발생");
        });
	}
	
	function startCheckingUseIdAndEmail(userId, email, callback) {
	    let url = "/user/foundByIdEmail?email=" + encodeURIComponent(email) + "&userId=" + encodeURIComponent(userId);
	    fetch(url)
        .then(res => res.json())
        .then(data => {
            if (!data.exists) {
                resultSpan.innerText = "아이디와 이메일을 체크해주세요.";
                resultSpan.style.color = "red";
                callback(false); // 실패
                return;
            }
            callback(true); // 성공
        })
        .catch(() => {
            resultSpan.innerText = "서버 오류로 아이디/이메일 확인 실패!";
            resultSpan.style.color = "red";
            callback(false); // 실패
        });	
	}
	
	function tryEnableFormAfterEmailVerified() {
	    const userType = document.querySelector('input[name="userType"]').value;
	    const bizFileInput = document.getElementById('bizFile');
	    if(userType == "2") { // 기업회원
	        if(bizFileInput && bizFileInput.files && bizFileInput.files.length > 0) {
	            setFormEnable(true);
	        } else {
	            setFormEnable(false);
	            alert('사업자등록증 파일을 먼저 등록해 주세요!');
	        }
	    } else { // 일반회원
	        setFormEnable(true);
	    }
	}
	
	function setFormEnable(isEnable) {
	    document.querySelectorAll('.required_auth input, .required_auth select, .required_auth button')
	        .forEach(el => el.disabled = !isEnable);
	}
	
	if(options.purpose === "join") {
		const userType = document.querySelector('input[name="userType"]').value;
		const bizFileInput = document.getElementById('bizFile');
		if(userType == "2" && bizFileInput) {
		    bizFileInput.addEventListener('change', function () {
		        if(window.isEmailVerified) {
		            tryEnableFormAfterEmailVerified();
		        }
		    });
		}
	}
}

