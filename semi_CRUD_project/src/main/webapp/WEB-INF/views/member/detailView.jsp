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

  .member-table {
    width: 600px;
    margin: 50px auto;
    border-collapse: collapse;
    background-color: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  }

  .member-table th,
  .member-table td {
    padding: 12px 16px;
    border: 1px solid #dee2e6;
    vertical-align: middle;
  }

  .member-table caption {
    caption-side: top;
    font-size: 22px;
    font-weight: bold;
    padding: 15px;
    text-align: center;
  }

  .link-area {
    width: 600px;
    margin: 20px auto 0;
    text-align: right;
    padding-right: 10px;
  }

  .link-area input[type="button"],
  .link-area a {
    margin-left: 8px;
    font-size: 14px;
  }

  .link-area input[type="button"] {
    padding: 6px 12px;
    background-color: #0d6efd;
    border: none;
    color: white;
    border-radius: 4px;
  }

  .link-area input[type="button"]:hover {
    background-color: #0b5ed7;
    cursor: pointer;
  }

  .link-area a {
    text-decoration: none;
    color: #0d6efd;
  }

  .link-area a:hover {
    text-decoration: underline;
  }
</style>

<meta charset="UTF-8">
<title>회원 정보 상세보기</title>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<table border="1" class="member-table">
  <caption>회원 정보</caption>
  <tr>
    <td>아이디</td>
    <td>${memberInfo.userId}</td>
  </tr>
  <tr>
    <td>이름</td>
    <td>${memberInfo.userName}</td>
  </tr>
  <tr>
    <td>비밀번호</td>
    <td>${memberInfo.userPwd}</td>
  </tr>
  <tr>
    <td>생년월일</td>
    <td><fmt:formatDate value="${memberInfo.userBirth}" pattern="yyyy년 MM월 dd일"/></td>
  </tr>
  <tr>
    <td>전화번호</td>
    <td>${memberInfo.userPhone}</td>
  </tr>
  <tr>
    <td>우편번호</td>
    <td>${memberInfo.userZipcode}</td>
  </tr>
  <tr>
    <td>주소</td>
    <td>${memberInfo.userAddr}</td>
  </tr>
  <tr>
    <td>상세주소</td>
    <td>${memberInfo.userDetailAddr}</td>
  </tr>
  <tr>
    <td>등록일</td>
    <td><fmt:formatDate value="${memberInfo.userRegDate}" pattern="yyyy년 MM월 dd일" /></td>
  </tr>
  <tr>
    <td>최근로그인일시</td>
    <td><fmt:formatDate value="${memberInfo.loginTime}" pattern="yyyy년 MM월 dd일 HH시 mm분 ss초" /></td>
  </tr>
</table>

<div class="link-area">
  <c:if test="${sessionScope.member.isManager eq 'Y' && memberInfo.accountStatus eq 'Y'}">
    <input type="button" id="resetButton" value="로그인 잠금 해제">
  </c:if>
  <c:if test="${sessionScope.member.userNo != memberInfo.userNo && sessionScope.member.isManager == 'Y' && memberInfo.isManager == 'N'}">
    <input type="button" id="grantButton" value="관리자 권한 부여">
  </c:if>
  <c:if test="${sessionScope.member.userNo != memberInfo.userNo && sessionScope.member.isManager == 'Y' && memberInfo.isManager == 'Y'}">
    <input type="button" id="revokeButton" value="관리자 권한 해제">
  </c:if>
  <a href="updateForm?userid=${memberInfo.userId}">수정</a>
  <a id="deleteButton">탈퇴</a>
</div>

<script>
  let deleteButton = document.querySelector("#deleteButton")
  deleteButton.addEventListener("click", function(e) {
    e.preventDefault();
    if (!confirm("탈퇴 후에는 복구할 수 없습니다. 정말 탈퇴하시겠습니까?")) {
      return;
    }
    fetch("delete", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json;charset=utf-8"
      },
      body: JSON.stringify({
        userid: "${memberInfo.userId}"
      })
    })
    .then(response => response.json())
    .then(data => {
      res_code = data.res_code;
      if (res_code == "400") {
        alert(data.res_msg)
      } else {
        alert(data.res_msg)
        if (data.isSelfDelete) {
          location.href = "${pageContext.request.contextPath}/";
        } else {
          location.href = "${pageContext.request.contextPath}/userList";
        }
      }
    })
  });

  let resetButton = document.querySelector("#resetButton")
  if (resetButton) {
    resetButton.addEventListener("click", function(e) {
      e.preventDefault();
      if (!confirm("로그인 실패 상태를 해제하시겠습니까?")) {
        return;
      }
      fetch("resetStatus", {
        method: "POST",
        headers: {
          "Content-Type": "application/json;charset=utf-8"
        },
        body: JSON.stringify({
          userid: "${memberInfo.userId}"
        })
      })
      .then(response => response.json())
      .then(data => {
        res_code = data.res_code;
        if (res_code == "400") {
          alert(data.res_msg)
        } else {
          alert(data.res_msg)
          location.href = "${pageContext.request.contextPath}/";
        }
      })
    });
  }

  let grantButton = document.querySelector("#grantButton")
  if (grantButton) {
    grantButton.addEventListener("click", function(e) {
      e.preventDefault();
      if (!confirm("관리자 권한을 부여하시겠습니까?")) {
        return;
      }
      fetch("grantManager", {
        method: "POST",
        headers: {
          "Content-Type": "application/json;charset=utf-8"
        },
        body: JSON.stringify({
          userid: "${memberInfo.userId}"
        })
      })
      .then(response => response.json())
      .then(data => {
        res_code = data.res_code;
        if (res_code == "400") {
          alert(data.res_msg)
        } else {
          alert(data.res_msg)
          location.href = "${pageContext.request.contextPath}/detailView?userid=${memberInfo.userId}";
        }
      })
    });
  }

  let revokeButton = document.querySelector("#revokeButton")
  if (revokeButton) {
    revokeButton.addEventListener("click", function(e) {
      e.preventDefault();
      if (!confirm("관리자 권한을 해제하시겠습니까?")) {
        return;
      }
      fetch("revokeManager", {
        method: "POST",
        headers: {
          "Content-Type": "application/json;charset=utf-8"
        },
        body: JSON.stringify({
          userid: "${memberInfo.userId}"
        })
      })
      .then(response => response.json())
      .then(data => {
        res_code = data.res_code;
        if (res_code == "400") {
          alert(data.res_msg)
        } else {
          alert(data.res_msg)
          location.href = "${pageContext.request.contextPath}/detailView?userid=${memberInfo.userId}";
        }
      })
    });
  }
</script>
</body>
</html>
