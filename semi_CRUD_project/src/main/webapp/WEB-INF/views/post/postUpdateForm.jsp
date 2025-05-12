<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게시글 수정</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%@ include file="../include/header.jsp"%>

<div class="container-fluid px-4 mt-5">
  <div class="mx-auto" style="max-width: 800px;">
    <h3 class="mb-4">게시글 수정</h3>
    <form name="postUpdateForm" id="postUpdateForm" action="postUpdate" method="post">
      <input type="hidden" name="boardNo" id="boardNo" value="${postUpdateDetail.boardNo}" />
      <input type="hidden" name="postNo" id="postNo" value="${postUpdateDetail.postNo}" />

      <div class="mb-3">
        <label for="postTitle" class="form-label">제목</label>
        <input type="text" name="postTitle" id="postTitle" value="${postUpdateDetail.postTitle}" class="form-control" required />
      </div>

      <div class="mb-3">
        <label for="postContent" class="form-label">내용</label>
        <textarea name="postContent" id="postContent" rows="10" class="form-control" required>${postUpdateDetail.postContent}</textarea>
      </div>

      <div class="mb-4">
        <label for="commentStatus" class="form-label">댓글 허용 여부</label>
        <select name="commentStatus" id="commentStatus" class="form-select">
          <option value="Y" ${postUpdateDetail.commentStatus == 'Y' ? 'selected' : ''}>허용</option>
          <option value="N" ${postUpdateDetail.commentStatus == 'N' ? 'selected' : ''}>비허용</option>
        </select>
      </div>

      <div class="text-end">
        <input type="submit" value="수정 완료" class="btn btn-primary" />
      </div>
    </form>
  </div>
</div>

<script>
  let form = document.querySelector("#postUpdateForm");
  if (form) {
    form.addEventListener("submit", e => {
      e.preventDefault();
      const param = {
        boardNo: form.boardNo.value,
        postNo: form.postNo.value,
        postTitle: form.postTitle.value,
        postContent: form.postContent.value,
        commentStatus: form.commentStatus.value
      };

      fetch("postUpdate", {
        method: "post",
        headers: {
          "Content-type": "application/json;charset=utf-8"
        },
        body: JSON.stringify(param)
      })
      .then(response => response.json())
      .then(data => {
        alert(data.res_msg);
        if (data.res_code !== "400") {
          location.href = "${pageContext.request.contextPath}/postDetailView?postno=" + form.postNo.value;
        }
      });
    });
  }
</script>
</body>
</html>
