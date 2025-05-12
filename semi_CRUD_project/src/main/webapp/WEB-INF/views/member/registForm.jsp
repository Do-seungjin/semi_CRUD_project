<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
  body {
    background-color: #f8f9fa;
    font-family: sans-serif;
  }

  .registercontainer {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    margin-top: 80px;
  }

  .register-form {
    background-color: white;
    padding: 40px;
    border-radius: 10px;
    width: 600px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  }

  .register-form label {
    font-weight: bold;
  }

  .register-form .form-control {
    margin-bottom: 15px;
  }

  .register-form input[type="submit"],
  .register-form input[type="reset"] {
    width: 100px;
  }

  #useridMsg,
  #passwdMsg {
    display: block;
    font-size: 14px;
    margin-top: -10px;
    margin-bottom: 10px;
  }
</style>

<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="registercontainer">
  <form name="registerForm" id="registerForm" action="register" method="post" class="register-form">
    <div class="mb-3 d-flex align-items-center gap-2">
      <div class="flex-grow-1">
        <label for="userid" class="form-label">아이디</label>
        <input type="text" name="userid" id="userid" required="required" class="form-control" placeholder="아이디를 입력해주세요">
        <span id="useridMsg" class="text-danger" style="display: none;"></span>
      </div>
      <input type="button" value="중복확인" id="validButton" class="btn btn-secondary mt-4">
    </div>

    <div class="mb-3">
      <label for="passwd" class="form-label">비밀번호</label>
      <input type="password" name="passwd" id="passwd" required="required" class="form-control" placeholder="비밀번호를 입력해주세요">
      <span id="passwdMsg" class="text-danger" style="display: none;"></span>
    </div>

    <div class="mb-3">
      <label for="passwd2" class="form-label">비밀번호 확인</label>
      <input type="password" name="passwd2" id="passwd2" required="required" class="form-control" placeholder="비밀번호를 다시 입력해주세요">
    </div>

    <div class="mb-3">
      <label for="name" class="form-label">이름</label>
      <input type="text" name="name" id="name" required="required" class="form-control" placeholder="이름을 입력해주세요">
    </div>

    <div class="mb-3">
      <label for="birth" class="form-label">생년월일</label>
      <input type="date" name="birth" id="birth" required="required" class="form-control">
    </div>

    <div class="mb-3">
      <label for="phone" class="form-label">전화번호</label>
      <input type="text" name="phone" id="phone" maxlength="16" class="form-control" placeholder="전화번호를 입력해주세요">
    </div>

    <div class="mb-3 d-flex gap-2">
      <div class="flex-grow-1">
        <label for="zipcode" class="form-label">우편번호</label>
        <input type="text" id="zipcode" name="zipcode" class="form-control" placeholder="우편번호를 입력해주세요" readonly>
      </div>
      <div class="mt-4">
        <input type="button" id="zipcode_button" value="우편찾기" class="btn btn-outline-secondary">
      </div>
    </div>

    <div class="mb-3">
      <label for="address" class="form-label">주소</label>
      <input type="text" id="address" name="address" class="form-control" placeholder="주소를 입력해주세요" readonly>
    </div>

    <div class="mb-4">
      <label for="detail_address" class="form-label">상세주소</label>
      <input type="text" id="detail_address" name="detail_address" class="form-control" placeholder="상세주소를 입력해주세요">
    </div>

    <div class="d-flex justify-content-between">
      <input type="submit" value="회원가입" class="btn btn-primary">
      <input type="reset" value="초기화" class="btn btn-secondary">
    </div>
  </form>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	window.onload = function(){
	    document.getElementById("zipcode_button").addEventListener("click", function(){
	        new daum.Postcode({
	            oncomplete: function(data) {
	                document.getElementById("zipcode").value = data.zonecode;
	                document.getElementById("address").value = data.address;
	            }
	        }).open();
	    });
	}
</script>
<script>
	let existUserId = true;
	let validClicked = false;
	let validChecked = false;
	let form = document.querySelector("#registerForm");
	let validButton = document.querySelector("#validButton");
	const passwd = document.querySelector("#passwd");
	const passwd2 = document.querySelector("#passwd2");
	const useridCheck = document.querySelector("#userid");
	
	const useridMsg = document.querySelector("#useridMsg");
	const passwdMsg = document.querySelector("#passwdMsg");
	
	useridCheck.addEventListener("input", () => validClicked = false);
	
	if(form){
		form.addEventListener("submit",e=>{
			e.preventDefault();
			
			useridMsg.style.display = "none";
			passwdMsg.style.display = "none";
			
			if(!confirm("회원 가입하시겠습니까?")){
				return;
			}
			
			if(validClicked === false){
				alert("아이디 중복을 검사해주세요");
				return;
			}
			
			if (useridCheck.value.length < 8) {
				useridMsg.textContent = "아이디는 최소 8자 이상이어야 합니다.";
				useridMsg.style.display = "inline";
				useridCheck.focus();
				return;
			}
			
			 // 메시지 초기화
			  passwdMsg.style.display = "none";

			  // 비밀번호 유효성 검사
			  const pwRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?`~]).{8,}$/;
			  if (!pwRegex.test(passwd.value)) {
			    passwdMsg.textContent = "영문자, 숫자, 특수문자를 포함한 8자 이상이어야 합니다.";
			    passwdMsg.style.display = "inline";
			    passwd.value = "";
			    passwd2.value = "";
			    passwd.focus();
			    return;
			  } else {
			    passwdMsg.style.display = "none"; //
			  }

			  // 비밀번호 일치 검사
			  if (passwd.value !== passwd2.value) {
			    passwdMsg.textContent = "비밀번호가 일치하지 않습니다.";
			    passwdMsg.style.display = "inline";
			    passwd.value = "";
			    passwd2.value = "";
			    passwd.focus();
			    return;
			  } else {
			    passwdMsg.style.display = "none"; //
			  }
			
			const param ={
					userId : form.userid.value, 
					userPwd : form.passwd.value,
					userName : document.querySelector("#name").value,
					userBirth : form.birth.value,
					userPhone : form.phone.value,
					userZipcode : form.zipcode.value,
					userAddr : form.address.value,
					userDetailAddr : form.detail_address.value
			}
			
			fetch("register",{
				method : 'post',
				headers : {
					'Content-type':'application/json;charset=utf-8'
				},
				body:JSON.stringify(param)
			})
			.then(response => {
				return response.json()
			})
			.then(data => {
				res_code = data.res_code;
				alert(data.res_msg)
				  if (res_code === "400") {
					    location.reload();
					  } else {
					    location.href = "loginForm";
					  }
			})
	
		})
	}
	
	if (validButton) {
		  validButton.addEventListener("click", e => {
		    const userid = document.querySelector("#userid");
		    useridMsg.style.display = "none"; // 초기화

		    if (userid.value.length === 0) {
		      alert("아이디를 입력해주세요");
		      userid.focus();
		      return;
		    }

		    // 아이디 길이 검사
		    if (userid.value.length < 8) {
		      useridMsg.textContent = "아이디는 최소 8자 이상이어야 합니다.";
		      useridMsg.style.display = "inline";
		      userid.focus();
		      return;
		    } else {
		      useridMsg.style.display = "none";
		    }

		    // 아이디 유효성 검사 통과한 경우만 서버에 중복 검사 요청

		    fetch("isExistUserId", {
		      method: 'post',
		      headers: {
		        'Content-Type': 'application/json;charset=utf-8'
		      },
		      body: JSON.stringify({ userId: userid.value })
		    })
		      .then(response => response.json())
		      .then(json => {
		        existUserId = json.existUserId;
		        if (existUserId) {
		          alert("[" + userid.value + "] 해당 아이디는 사용 불가능 합니다 ");
		        } else {
		          alert("[" + userid.value + "] 해당 아이디는 사용 가능 합니다 ");
				  validClicked = true;
		        }
		      });
		  });
		}
</script>
</body>
</html>