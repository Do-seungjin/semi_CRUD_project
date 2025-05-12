<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 삭제</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center" style="min-height: 60vh;">
  <div class="card p-4 shadow-sm" style="width: 100%; max-width: 400px;">
    <h4 class="mb-4 text-center">게시글 삭제 확인</h4>
    <form name="postDeleteForm" id="postDeleteForm" action="postDelete">
      <input type="hidden" id="boardno" name="boardno" value="${boardNo}">
      <input type="hidden" id="postno" name="postno" value="${postNo}">

      <div class="mb-3">
        <label for="userpwd" class="form-label">비밀번호</label>
        <input type="password" id="userpwd" name="userpwd" class="form-control" placeholder="비밀번호를 입력하세요" required>
      </div>

      <div class="text-end">
        <input type="submit" value="삭제" class="btn btn-danger">
      </div>
    </form>
  </div>
</div>

<script>
  let postDeleteForm = document.querySelector("#postDeleteForm");
  if (postDeleteForm) {
    postDeleteForm.addEventListener("submit", function(e) {
      e.preventDefault();
      if (!confirm("게시글을 삭제하시겠습니까?")) {
        return;
      }

      const postno = document.querySelector("#postno").value;
      const userpwd = document.querySelector("#userpwd").value;
      const boardno = document.querySelector("#boardno").value;

      const param = {
        postno: postno,
        userpwd: userpwd
      };

      fetch("userPostDelete", {
        method: 'DELETE',
        headers: {
          'Content-type': 'application/json;charset=utf-8'
        },
        body: JSON.stringify(param)
      })
      .then(response => response.json())
      .then(data => {
        alert(data.res_msg);
        if (data.res_code === "400") {
          location.reload();
        } else {
          location.href = "${pageContext.request.contextPath}/postList?boardNo=" + boardno;
        }
      });
    });
  }
</script>
</body>
</html>
