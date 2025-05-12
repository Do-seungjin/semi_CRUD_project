<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 등록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="container-fluid px-4 mt-5">
  <div class="mx-auto" style="max-width: 800px;">
    <h3 class="mb-4">게시글 등록</h3>
    <form name="postRegisterForm" id="postRegisterForm">
      <input type="hidden" name="boardNo" id="boardNo" value="${boardNo}"/>
      <input type="hidden" name="userNo" id="userNo" value="${userNo}"/>

      <div class="mb-3">
        <label for="title" class="form-label">제목</label>
        <input type="text" name="title" id="title" required class="form-control" placeholder="제목을 입력해주세요">
      </div>

      <div class="mb-3">
        <label for="content" class="form-label">내용</label>
        <textarea name="content" id="content" rows="10" required class="form-control" placeholder="내용을 입력해주세요"></textarea>
      </div>

      <div class="mb-4">
        <label for="isComment" class="form-label">댓글 허용 여부</label>
        <select name="isComment" id="isComment" class="form-select">
          <option value="Y">허용</option>
          <option value="N">비허용</option>
        </select>
      </div>

      <div class="text-end">
        <input type="submit" value="등록" class="btn btn-primary" />
      </div>
    </form>
  </div>
</div>

<script>
  let form = document.querySelector("#postRegisterForm");
  if (form) {
    form.addEventListener("submit", e => {
      e.preventDefault();
      const param = {
        userNo: form.userNo.value,
        boardNo: form.boardNo.value,
        postTitle: form.title.value,
        postContent: form.content.value,
        commentStatus: form.isComment.value
      };

      fetch("postRegist", {
        method: 'post',
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
          location.href = "${pageContext.request.contextPath}/postList?boardNo=" + form.boardNo.value;
        }
      });
    });
  }
</script>

</body>
</html>
