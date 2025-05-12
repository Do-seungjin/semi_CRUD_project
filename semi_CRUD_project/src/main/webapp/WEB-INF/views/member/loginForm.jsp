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

  .logincontainer {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 100px;
  }

  .login-form {
    background-color: white;
    padding: 40px;
    border-radius: 10px;
    width: 400px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  }

  .login-form label {
    font-weight: bold;
  }

  .login-form input[type="text"],
  .login-form input[type="password"] {
    margin-bottom: 15px;
  }

  .login-form input[type="submit"] {
    width: 100%;
  }
</style>

<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="logincontainer">
  <form action="login" name="loginForm" id="loginForm" class="login-form">
    <div class="mb-3">
      <label for="userid" class="form-label">아이디</label>
      <input type="text" name="userid" id="userid" required="required" class="form-control" placeholder="아이디를 입력해주세요" value="${param.userid}">
    </div>
    <div class="mb-3">
      <label for="passwd" class="form-label">비밀번호</label>
      <input type="password" name="passwd" id="passwd" required="required" class="form-control" placeholder="비밀번호를 입력해주세요">
    </div>
    <input type="submit" value="로그인" class="btn btn-primary">
  </form>
</div>

<script type="text/javascript">
  let loginForm = document.querySelector("#loginForm");
  const userid = document.querySelector("#userid");
  const passwd = document.querySelector("#passwd");
  if (loginForm) {
    loginForm.addEventListener("submit", e => {
      e.preventDefault();
      const param = {
        userId: userid.value,
        userPwd: passwd.value
      }

      fetch("login", {
        method: 'post',
        headers: {
          'Content-type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(param)
      })
        .then(response => {
          return response.json()
        })
        .then(data => {
          res_code = data.res_code;
          if (res_code == "400") {
            alert(data.res_msg)
            userid.value = "";
            passwd.value = "";
            userid.focus();
          } else {
            location.href = "./";
          }
        })

    })
  }
</script>
</body>
</html>
