<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

  .update-container {
    display: flex;
    justify-content: center;
    margin-top: 60px;
  }

  .update-form {
    background-color: white;
    padding: 40px;
    width: 600px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  }

  .update-form h3 {
    text-align: center;
    font-weight: bold;
    margin-bottom: 30px;
  }

  .update-form label {
    font-weight: bold;
  }

  .update-form .form-control {
    margin-bottom: 15px;
  }

  .link-area {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
  }

  .link-area a {
    text-decoration: none;
    color: #0d6efd;
    padding: 8px 12px;
  }

  .link-area a:hover {
    text-decoration: underline;
  }
</style>

<meta charset="UTF-8">
<title>회원 정보 수정</title>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="update-container">
  <form name="updateForm" id="updateForm" action="update" method="post" class="update-form">
    <h3>회원 정보 수정</h3>
    <input type="hidden" id="userid" name="userid" value="${memberInfo.userId}">

    <div class="mb-3">
      <label for="name" class="form-label">이름</label>
      <input type="text" name="name" id="name" required="required" class="form-control" value="${memberInfo.userName}">
    </div>

    <div class="mb-3">
      <label for="birth" class="form-label">생년월일</label>
      <fmt:formatDate value="${memberInfo.userBirth}" pattern="yyyy-MM-dd" var="formattedBirth"/>
      <input type="date" name="birth" id="birth" required="required" class="form-control" value="${formattedBirth}">
    </div>

    <div class="mb-3">
      <label for="phone" class="form-label">전화번호</label>
      <input type="text" name="phone" id="phone" maxlength="16" class="form-control" value="${memberInfo.userPhone}">
    </div>

    <div class="mb-3 d-flex gap-2">
      <div class="flex-grow-1">
        <label for="zipcode" class="form-label">우편번호</label>
        <input type="text" id="zipcode" name="zipcode" class="form-control" value="${memberInfo.userZipcode}">
      </div>
      <div class="mt-4">
        <input type="button" id="zipcode_button" value="우편찾기" class="btn btn-outline-secondary">
      </div>
    </div>

    <div class="mb-3">
      <label for="address" class="form-label">주소</label>
      <input type="text" id="address" name="address" class="form-control" value="${memberInfo.userAddr}">
    </div>

    <div class="mb-3">
      <label for="detail_address" class="form-label">상세주소</label>
      <input type="text" id="detail_address" name="detail_address" class="form-control" value="${memberInfo.userDetailAddr}">
    </div>

    <div class="link-area">
      <input type="submit" id="update" value="변경" class="btn btn-primary">
      <a href="${pageContext.request.contextPath}/detailView?userid=${memberInfo.userId}" class="btn btn-secondary">취소</a>
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
  let form = document.querySelector("#updateForm");
  if(form){
    form.addEventListener("submit", e => {
      e.preventDefault();
      const param = {
        userId: form.userid.value,
        userName: document.querySelector("#name").value,
        userBirth: form.birth.value,
        userPhone: form.phone.value,
        userZipcode: form.zipcode.value,
        userAddr: form.address.value,
        userDetailAddr: form.detail_address.value
      };

      fetch("update", {
        method: 'post',
        headers: {
          'Content-type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(param)
      })
      .then(response => response.json())
      .then(data => {
        res_code = data.res_code;
        if(res_code === "400"){					
          alert(data.res_msg)
        } else {
          alert(data.res_msg)
          location.href = "${pageContext.request.contextPath}/detailView?userid=" + form.userid.value;
        }
      });
    });
  }
</script>
</body>
</html>
